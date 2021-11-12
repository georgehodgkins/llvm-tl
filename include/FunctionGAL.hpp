#pragma once
#include <LLVM/IR/Function.hpp>
#include <its/ITSModel.hh>
#include <its/gal/GAL.hh>

namespace llvm {

class FunctionGAL : public GAL {
	public:
	its::ITSModel model;
	TLFuncModel(const Function* F);
}

} // namespace llvm
