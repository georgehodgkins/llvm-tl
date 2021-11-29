#pragma once
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/IR/InstrTypes.h>
#include <llvm/ADT/StringRef.h>

namespace llvm {

// this used to be an instvisitor, but that breaks const-propagation
class BoolCallbackVisitor {
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
	
	void visit (const BasicBlock* BB) {
		for (auto it = BB->begin(); it != BB->end(); ++it) {
			if (!all && cb(&*it)) sat = true; // checking any
			else if (all && !cb(&*it)) sat = false; // checking all
		}
	}

	bool operator() (const BasicBlock* BB) {
		reset();
		visit(BB);
		return check();
	}
};

static bool IcallsFuncByName (const Instruction* I, const StringRef Name) {
	if (!isa<CallInst> (I)) return false;
	
	return (cast<CallInst>(I)->getCalledFunction()->getName() == Name);
}

static bool IisAtomic (const Instruction* I) {
	return (isa<AtomicCmpXchgInst>(I) || isa<AtomicRMWInst>(I));
}
	
BBClassifier atprop_iset[] = {
	BoolCallbackVisitor(IisAtomic),
	BoolCallbackVisitor([](const Instruction* I)
		{return IcallsFuncByName(I, "pthread_mutex_lock");}),
	BoolCallbackVisitor([](const Instruction* I)
		{return IcallsFuncByName(I, "pthread_mutex_unlock");})
};
#define ATPROP_ISET_SIZE 3

}
