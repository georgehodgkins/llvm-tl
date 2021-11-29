#include "FunctionGAL.hpp"
#include "AtProp.hpp"
#include <cassert>
#include <sstream>
#include <algorithm>
#include <llvm/Support/Debug.h>

using namespace its;
namespace llvm {
#define DEBUG_TYPE "llvm-tl"

FunctionGAL::block_idx_t FunctionGAL::indexBlock (const BasicBlock* BB) {
	assert(cIdx < std::numeric_limits<block_idx_t>::max() && "OK, now you really have to change \
		the size (here and in libDDD)");
	auto emplit = blockIdx.try_emplace(BB, cIdx+1);
	if (emplit.second) {
		++cIdx;
		LLVM_DEBUG(dbgs() << "\tIndexed BB " << (void*) BB << " to index " << (*emplit.first).second << '\n');
	}
	return (*emplit.first).second;
}

void FunctionGAL::addTransitions (BasicBlock* from) {
	const Instruction* arnold = from->getTerminator();

	std::vector<bool> from_props = the_AtPropSet.checkBlock(from);
	std::stringstream trans_label;
	std::stringstream atp_label;
	for (unsigned i = 0; i < arnold->getNumSuccessors(); ++i) {	
		BasicBlock* to = arnold->getSuccessor(i);
		trans_label << from->getName().data() << "->" << to->getName().data();
		GuardedAction trans (trans_label.str());
		
		// condition: state == starting block
		BoolExpression guard = BoolExpressionFactory::createComparison(EQ, Variable("state"),
			indexBlock(from));
		trans.setGuard(guard);

		// all the assignments are coalesced and performed as an atomic action
		std::vector<SyncAssignment::assign_t> assgn;
		// transition action: set state to destination block
		assgn.push_back(std::make_pair(Variable("state"), indexBlock(to)));
		// atprop action(s): update any atomic propositions whose values change 
		std::vector<bool> to_props = the_AtPropSet.checkBlock(to);
		assert(to_props.size() == from_props.size());
		for (size_t i = 0; i < to_props.size(); ++i) {
	   		if (from_props[i] != to_props[i]) {
				atp_label << "atp" << i;
				if (from_props[i]) { // true -> false
					assgn.push_back(std::make_pair(Variable(atp_label.str()), 0));
				} else { // false -> true
					assgn.push_back(std::make_pair(Variable(atp_label.str()), 1));
				}
				atp_label.str("");
			}
		}
		trans.getAction().add(SyncAssignment(assgn));
		addTransition(trans);
		
		trans_label.str("");
	}
}

void FunctionGAL::addTransitions (BasicBlock& from) {
	addTransitions(&from);
}

std::string FunctionGAL::print() const {
	// display constructed model
	std::stringstream conv;
	conv << *this;
	return conv.str();
}
			
FunctionGAL::FunctionGAL (Function* F) : GAL(F->getName().data()), cIdx(-1) {
	// we encode the function as a GAL model
	// see https://lip6.github.io/ITSTools-web/gal
	BasicBlock& entry = F->getEntryBlock();
	
	// variables:
	// state, encoded as the integer address of the current block
	addVariable(Variable("state"), indexBlock(&entry));
	// array of booleans encoding atomic proposition checks
	const auto entry_states = the_AtPropSet.checkBlock(&entry); // get the value of each atprop in the initial state
	std::stringstream atp;
	for (unsigned i = 0; i < entry_states.size(); ++i) {
		atp << "atp" << i;
		addVariable(Variable(atp.str()), entry_states[i] ? 1 : 0); 
		atp.str("");
	}
		
	// then we add transitions for each block 
	for (auto it = F->begin(); it != F->end(); ++it)
		addTransitions(*it);
	model.declareType(*this);	
	model.setInstance(getName(), "main");
	model.setInstanceState("init");
}

} // namespace llvm

