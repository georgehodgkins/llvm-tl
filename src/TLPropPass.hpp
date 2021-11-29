#include <llvm/IR/PassManager.h>
#include <spot/tl/parse.hh>
#include <string>

namespace llvm {
using namespace std;

enum class f_check_stat {UNCHECKED, UNSAT, SAT};

class TLPropPass : public PassInfoMixin<TLPropPass> {
	public:
//	static char ID;
	bool runOnModule(Module& M);
	PreservedAnalyses run (Module&, ModuleAnalysisManager&);
	TLPropPass();	

	private:
	Error getCommandLine();
	Expected<bool> checkFunction(Function*);

	SmallVector<pair<string, f_check_stat>, 16> flist; // list of functions to check
	DenseMap<BasicBlock*, short> blockIdx; // small block index map, to make libDDD happy
	spot::parsed_formula prop;
};

} // namespace llvm
		
