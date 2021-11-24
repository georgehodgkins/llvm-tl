#include <llvm/IR/PassManager.h>
#include <spot/tl/parse.hh>
#include <string>

namespace llvm {
using namespace std;

enum class f_check_stat {UNCHECKED, UNSAT, SAT};

class TLPropPass : protected ModulePass {
	public:
	static char passID;
	bool runOnModule(Module& M);
	TLPropPass();	

	private:
	Error getCommandLine();
	bool checkFunction(const Function*);

	SmallVector<pair<string, f_check_stat>, 16> flist; // list of functions to check
	spot::parsed_formula prop;
};

} // namespace llvm
		
