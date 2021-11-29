#include "TLPropPass.hpp"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Passes/PassBuilder.h"
#include "spot/tl/print.hh"
#include "sogtgbautils.hh"
#include "FunctionGAL.hpp"
#include "AtProp.hpp"
#include <sstream>
#include <system_error>
#include <stdexcept>

namespace llvm {
using namespace std;
#define DEBUG_TYPE "llvm-tl"

// testcases
#ifdef TESTCASE_1
const string TESTCASEPROP = "G atp0";
const string TESTCASEFUNCS = "main;";
#elif defined(TESTCASE_2)
const string TESTCASEPROP = "G(atp1 -> F atp2)";
const string TESTCASEFUNCS = "main;";
#else
#error "Select a testcase to compile for using -DTESTCASE_n."
#endif

/* -- legacy pass registration
static RegisterPass<TLPropPass> X("llvm-tl", "LLVM *TL", true, true);
char TLPropPass::ID = 0;
*/ 

static cl::opt<string> FuncsOfInterest("tl-func",
cl::desc("Functions to check for the provided LTL property"),
cl::value_desc("func1;func2..."), cl::ValueRequired);

static cl::opt<string> TheTLProp("tl-prop",
cl::desc("LTL property to check"),
cl::value_desc("LTL property in PSL syntax"), cl::ValueRequired);

extern "C" LLVM_ATTRIBUTE_WEAK
PassPluginLibraryInfo llvmGetPassPluginInfo() {
	return {LLVM_PLUGIN_API_VERSION, "LLVM-TL", LLVM_VERSION_STRING,
			[](PassBuilder& PB) {
				PB.registerPipelineParsingCallback(
					[](StringRef Name, ModulePassManager &MPM,
						ArrayRef<PassBuilder::PipelineElement>) {
							if (Name == "llvm-tl") {
								cl::AddLiteralOption(FuncsOfInterest, "tl-funcs");
								cl::AddLiteralOption(TheTLProp, "tl-prop");
								MPM.addPass(TLPropPass());
								return true;
							} else return false;
						});
			}};
}
	
const string allowedFuncChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

static ExitOnError EOE ("LLVM-TL INIT ERROR\n");

PreservedAnalyses TLPropPass::run(Module& M, ModuleAnalysisManager& MAM) {
	runOnModule(M);
	return PreservedAnalyses::all();
}

Error TLPropPass::getCommandLine () {
	//prop = spot::parse_infix_psl(TheTLProp.getValue());
	prop = spot::parse_infix_psl(TESTCASEPROP);
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

	//const string& in_flist = FuncsOfInterest.getValue();
	const string& in_flist = TESTCASEFUNCS;
	size_t pos = in_flist.find_first_of(';');
	size_t ppos = 0;
	while (pos != string::npos) {
		string fname (in_flist, ppos, pos - ppos);
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
	
TLPropPass::TLPropPass() {
	EOE(getCommandLine());
}

bool TLPropPass::runOnModule(Module& M) {
	SmallVector<Function*, 16> toCheck;
	stringstream conv;
	spot::print_psl(conv, prop.f, true);	
	LLVM_DEBUG(dbgs() << "Checking PSL (LTL) property " << conv.str() << '\n'); 

	// find and check functions of interest
	for (auto& foi : flist) {
		LLVM_DEBUG(dbgs() << "Checking for function " << foi.first << "in module " << M.getName() << ":");
		Function* F;
		if ( (F = M.getFunction(foi.first)) ) {
			toCheck.push_back(F);
			LLVM_DEBUG(dbgs() << " found as " << F->getName() << '\n');
			if (foi.second != f_check_stat::UNCHECKED) {
				LLVM_DEBUG(dbgs() << "\tNote: this function was previously found and checked in \
					another module.\n");
			}
			Expected<bool> xsat = checkFunction(F);
			if (!xsat) EOE(xsat.takeError());
			bool sat = *xsat;
			
			foi.second = (sat) ? f_check_stat::SAT : f_check_stat::UNSAT;
			LLVM_DEBUG(dbgs() << "\tRESULT: " << ((sat) ? "SAT" : "UNSAT") << '\n');
		} else {
			LLVM_DEBUG(dbgs() << " not found" << '\n');
		}
	}

	return false; // module not modified
}

Expected<bool> TLPropPass::checkFunction(Function* F) {
	// build a GAL model of the function
	FunctionGAL gal (F);
	LLVM_DEBUG(dbgs() << "\t Built GAL model:\n\n" << gal.print() << "\n\n");

	sogits::LTLChecker checker;
	checker.setFormula(prop.f);
	checker.setModel(&gal.model);
	checker.setOptions("Cou99", true);
	checker.setPlaceSyntax(true);
	
	bool sat;
	try {
		sat = checker.model_check(sogits::SLAP_FST);
	} catch (char const* e) {
		return createStringError(make_error_code(errc::invalid_argument), e);
	}

	return sat;
}

} // namespace llvm
