#include "FunctionGAL.hpp"
#include "AtProp.hpp"
#include <cassert>
#include <sstream>
#include <algorithm>

using namespace its;
namespace llvm {

void FunctionGAL::addTransitions (const BasicBlock* from) {
	const Instruction* arnold = from->getTerminator();

	std::vector<bool> from_props = the_AtPropSet.checkBlock(from);
	std::stringstream trans_label;
	std::stringstream atp_label("n");
	for (unsigned i = 0; i < arnold->getNumSuccessors(); ++i) {	
		const BasicBlock* to = arnold->getSuccessor(i);
		trans_label << from->getName().data() << "->" << to->getName().data();
		GuardedAction trans (trans_label.str());
		
		// condition: state == starting block
		BoolExpression guard = BoolExpressionFactory::createComparison(EQ, Variable("state"), (uintptr_t) from);
		trans.setGuard(guard);

		// all the assignments are coalesced and performed as an atomic action
		std::vector<SyncAssignment::assign_t> assgn;
		// transition action: set state to destination block
		assgn.push_back(std::make_pair(Variable("state"), (uintptr_t) to));
		// atprop action(s): update any atomic propositions whose values change 
		std::vector<bool> to_props = the_AtPropSet.checkBlock(to);
		assert(to_props.size() == from_props.size());
		for (size_t i = 0; i < to_props.size(); ++i) {
	   		if (from_props[i] != to_props[i]) {
				atp_label << i;
				if (from_props[i]) { // true -> false
					assgn.push_back(std::make_pair(Variable(atp_label.str()), 0));
				} else { // false -> true
					assgn.push_back(std::make_pair(Variable(atp_label.str()), 1));
				}
				atp_label.str("n");
			}
		}
		trans.getAction().add(SyncAssignment(assgn));
		addTransition(trans);
		
		trans_label.str("");
	}
}

void FunctionGAL::addTransitions (const BasicBlock& from) {
	addTransitions(&from);
}
			
FunctionGAL::FunctionGAL (const Function* F) : GAL(F->getName().data()) {
	// we encode the function as a GAL model
	// see https://lip6.github.io/ITSTools-web/gal
	const BasicBlock& entry = F->getEntryBlock();
	
	// variables:
	// state, encoded as the integer address of the current block
	addVariable(Variable("state"), (uintptr_t) &entry);
	// array of booleans encoding atomic proposition checks
	size_t atp_count = the_AtPropSet.size();
	std::vector<int> zeros (atp_count);
	addArray("atp", zeros);
		
	// then we add transitions for each block 
	for (auto it = F->begin(); it != F->end(); ++it)
		addTransitions(*it);
	model.declareType(*this);	
	model.setInstance(getName(), "main");
	model.setInstanceState("init");
}

} // namespace llvm

