#pragma once
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/IR/InstrTypes.h>

namespace llvm {

class BoolCallbackVisitor : public InstVisitor<BoolCallbackVisitor> {
	private:
	bool sat;
	const bool all;
	std::function<bool(const Instruction*)> cb;

	public:
	BoolCallbackVisitor (std::function<bool(const Instruction*)> cb_, bool all_ = false) : cb(cb_), all(all_) {
		reset();
	}

	BoolCallbackVisitor (const BoolCallbackVisitor& oth) = default;
	BoolCallbackVisitor (BoolCallbackVisitor&& oth) = default;

	bool check () const { return sat; }

	void reset () { sat = (all) ? true : false; }
	
	void visitInstruction (Instruction& I) {
		if (!all && cb(&I)) sat = true; // checking any
		else if (all && !cb(&I)) sat = false; // checking all
	}

	bool operator() (BasicBlock* BB) {
		reset();
		visit(BB);
		return check();
	}
};

static bool IcallsFunc (const Instruction* I, const Function* F) {
	if (!isa<CallInst> (I)) return false;
	
	return (cast<CallInst>(I)->getCalledFunction() == F);
}

static bool IisAtomic (const Instruction* I) {
	return (isa<AtomicCmpXchgInst>(I) || isa<AtomicRMWInst>(I));
}
	
BBClassifier atprop_iset[] = {
	BoolCallbackVisitor(IisAtomic)
};
#define ATPROP_ISET_SIZE 1

}
