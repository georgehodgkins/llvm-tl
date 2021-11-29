#pragma once
#include <llvm/IR/Function.h>
#include <its/ITSModel.hh>
#include <its/gal/GAL.hh>
#include <string>

namespace llvm {

class FunctionGAL : public its::GAL {
	private:
	typedef short block_idx_t;
	void addTransitions(BasicBlock*);	
	void addTransitions(BasicBlock&);
	DenseMap<const BasicBlock*, block_idx_t> blockIdx;
	std::vector<const BasicBlock*> idxBlock;
	block_idx_t cIdx;
	block_idx_t indexBlock(const BasicBlock*);

	public:
	its::ITSModel model;
	std::string print() const;
	FunctionGAL(Function* F);
};

} // namespace llvm
