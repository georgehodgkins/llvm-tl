#include "FunctionGAL.hpp"
#include "AtProp.hpp"
#include <cassert>
#include <sstream>
#include <algorithm>
#include <llvm/Support/Debug.h>
#include <llvm/IR/Instructions.h>

using namespace its;
namespace llvm {
#define DEBUG_TYPE "llvm-tl"

// create the internal index for a block or return it if it already exists
// we create these indices because libDDD uses small ints to store internal state
// and so pointers cannot be used directly
FunctionGAL::block_idx_t FunctionGAL::indexBlock (const BasicBlock* BB) {
	assert(cIdx < std::numeric_limits<block_idx_t>::max() && "OK, now you really have to change \
		the size (here and in libDDD)");
	auto emplit = blockIdx.try_emplace(BB, cIdx+1);
	if (emplit.second) {
		++cIdx;
		idxBlock.push_back(BB);
		assert(idxBlock.size() == cIdx+1);
		LLVM_DEBUG(dbgs() << "\tIndexed BB " << (void*) BB << " to index " << (*emplit.first).second << '\n');
	}
	return (*emplit.first).second;
}

// returns a vector of assignments for the changes in atprop values between two blocks
static inline std::vector<SyncAssignment::assign_t>
encodeAtPropTransit(const std::vector<bool>& from, const std::vector<bool>& to) {
	assert(from.size() == to.size());
	std::vector<SyncAssignment::assign_t> assgn;
	std::stringstream atp_label;
	for (size_t i = 0; i < from.size(); ++i) {
		if (from[i] != to[i]) {
			atp_label << "atp" << i;
			if (from[i]) { // true -> false
				assgn.push_back(std::make_pair(Variable(atp_label.str()), 0));
			} else { // false -> true
				assgn.push_back(std::make_pair(Variable(atp_label.str()), 1));
			}
			atp_label.str("");
		}
	}
	return assgn;
}

// adds transitions from the input block to all its successors
void FunctionGAL::addTransitions (BasicBlock* from) {
	const Instruction* arnold = from->getTerminator();

	std::vector<bool> from_props = the_AtPropSet.checkBlock(from);
	std::stringstream trans_label;
	std::stringstream atp_label;

	// condition for all transitions: state == starting block
	BoolExpression guard = BoolExpressionFactory::createComparison(EQ, Variable("state"),
		indexBlock(from));

	for (unsigned i = 0; i < arnold->getNumSuccessors(); ++i) {	
		BasicBlock* to = arnold->getSuccessor(i);
		trans_label << from->getName().data() << "->" << to->getName().data();
		GuardedAction trans (trans_label.str());
		trans.setGuard(guard);
		
		// atprop action(s): update any atomic propositions whose values change 
		std::vector<bool> to_props = the_AtPropSet.checkBlock(to);
		auto assgn = encodeAtPropTransit(from_props, to_props);
		// transition action: set state to destination block
		assgn.push_back(std::make_pair(Variable("state"), indexBlock(to)));

		// all the assignments are coalesced and performed as an atomic action
		trans.getAction().add(SyncAssignment(assgn));
		addTransition(trans);		
		trans_label.str("");
	}

	// solver expects closed graphs, so returns loop back to the entry point
	const static auto entry_props = the_AtPropSet.checkBlock(idxBlock[0]);
	if (isa<ReturnInst>(from->getTerminator())) {
		trans_label << from->getName().data() << " return loop";
		GuardedAction trans (trans_label.str());
		trans.setGuard(guard);
		
		auto assgn = encodeAtPropTransit(from_props, entry_props);
		assgn.push_back(std::make_pair(Variable("state"), 0));

		trans.getAction().add(SyncAssignment(assgn));
		addTransition(trans);
		trans_label.str("");
	}		
}

void FunctionGAL::addTransitions (BasicBlock& from) {
	addTransitions(&from);
}

// output constructed model as human-readable GAL
std::string FunctionGAL::print() const {
	std::stringstream conv;
	conv << *this;
	return conv.str();
}
			
/*
 * Creates a model of the given function's reduced SSA graph in GAL. Encodes an integer variable
 * "state" representing the current block and boolean variables "atp#" for the atprops
 * in the global atprop set.
 */
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

