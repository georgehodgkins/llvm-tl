#include "TLPropPass.hpp"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "sogtgbautils.hh"
#include "FunctionGAL.hpp"
#include "AtProp.hpp"
#include <sstream>
#include <system_error>
#include <stdexcept>

namespace llvm {
using namespace std;
#define DEBUG_TYPE "llvm-tl"

static cl::opt<string> FuncsOfInterest("tl-func",
cl::desc("Functions to check for the provided LTL property"),
cl::value_desc("func1;func2..."), cl::ValueRequired);

static cl::opt<string> TheTLProp("tl-prop",
cl::desc("LTL property to check"),
cl::value_desc("LTL property in PSL syntax"), cl::ValueRequired);

const string allowedFuncChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

static ExitOnError EOE ("TL CHECKER ERROR");

Error TLPropPass::getCommandLine () {
	prop = spot::parse_infix_psl(TheTLProp.getValue());
	stringstream err;
	if (prop.format_errors(err)) {
		return createStringError(make_error_code(errc::invalid_argument), err.str());
	}

	// validate atprops in the formula
	try {
		prop.f.traverse([](spot::formula f){return the_AtPropSet.checkFormula(f);});
	} catch (const invalid_argument& e) {
		return createStringError(make_error_code(errc::invalid_argument), e.what());
	}

	const string& in_flist = FuncsOfInterest.getValue();
	size_t pos = in_flist.find_first_of(';');
	size_t ppos = 0;
	while (pos != string::npos) {
		string fname (in_flist, pos, pos - ppos);
		if (fname.find_first_not_of(allowedFuncChars) != string::npos) {
			err << "Function name \'" << fname << "\' is invalid: non-alphanumeric characters";
			return createStringError(make_error_code(errc::invalid_argument), err.str());
		}
		flist.emplace_back(make_pair(move(fname), f_check_stat::UNCHECKED));
		ppos = pos+1;
		pos = in_flist.find_first_of(';', ppos);
	}
	
	return Error::success();
}
	
TLPropPass::TLPropPass() : ModulePass(passID) {
	EOE(getCommandLine());
}

bool TLPropPass::runOnModule(Module& M) {
	SmallVector<Function*, 16> toCheck;

	// find and check functions of interest
	for (auto& foi : flist) {
		LLVM_DEBUG(dbgs() << "Checking for function " << foi.first << "in module " << M.getName() << ":");
		Function* F;
		if ( (F = M.getFunction(foi.first)) ) {
			toCheck.push_back(F);
			LLVM_DEBUG(dbgs() << " found as " << F->getName() << '\n');
			if (foi.second != f_check_stat::UNCHECKED) {
				LLVM_DEBUG(dbgs() << "\tNote: this function was previously found and checked in \
					another module.");
			}
			bool sat = checkFunction(F);
			foi.second = (sat) ? f_check_stat::SAT : f_check_stat::UNSAT;
		} else {
			LLVM_DEBUG(dbgs() << " not found" << '\n');
		}
	}

	return false; // module not modified
}

bool TLPropPass::checkFunction(const Function* F) {
	// build a GAL model of the function
	FunctionGAL gal (F);

	sogits::LTLChecker checker;
	checker.setFormula(prop.f);
	checker.setModel(&gal.model);
	checker.setPlaceSyntax(true);
	
	return checker.model_check(sogits::SLAP_FST);
}

} // namespace llvm
