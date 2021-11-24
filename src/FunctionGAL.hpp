#pragma once
#include <llvm/IR/Function.h>
#include <its/ITSModel.hh>
#include <its/gal/GAL.hh>

namespace llvm {

class FunctionGAL : public its::GAL {
	private:
	void addTransitions(const BasicBlock*);	
	void addTransitions(const BasicBlock&);

	public:
	its::ITSModel model;
	FunctionGAL(const Function* F);
};

} // namespace llvm
