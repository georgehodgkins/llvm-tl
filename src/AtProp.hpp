#pragma once
#include <llvm/IR/BasicBlock.h>
#include <llvm/ADT/DenseMap.h>
#include <spot/tl/formula.hh>
#include <vector>
#include <functional>
#include <stdexcept>

namespace llvm {

typedef std::function<bool(const BasicBlock*)> BBClassifier;

class AtPropSet;
class AtProp {
	friend class AtPropSet;
	private:
	DenseMap<const BasicBlock*, bool> cache;
	BBClassifier decide;

	public:
	AtProp(BBClassifier&);
	AtProp() = delete;
	bool check (const BasicBlock*);
};

class AtPropSet {
	private:
	static bool instat;
	std::vector<AtProp> props;

	public:
	AtPropSet(BBClassifier*, size_t);
	AtPropSet();
	size_t size() const;
	void addProp (BBClassifier);
	std::vector<bool> checkBlock (const BasicBlock*);
	bool checkFormula(spot::formula);
};
extern AtPropSet the_AtPropSet;

} // namespace llvm
