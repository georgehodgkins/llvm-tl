#pragma once
#include <llvm/IR/BasicBlock.h>
#include <llvm/ADT/DenseMap.h>
#include <vector>
#include <functional>

namespace llvm {

typedef std::function<bool, BasicBlock*> BBClassifier;

class AtPropSet;
class AtProp {
	friend class AtPropSet;
	private:
	DenseMap<BasicBlock*, bool> cache;
	BBClassifier decide;

	public:
	AtProp(BBClassifier&);
	AtProp() = delete;
	bool check (BasicBlock*);
};

class AtPropSet {
	private:
	static bool instat = false;
	std::vector<AtProp> props;

	public:
	AtPropSet(const AtProp*, size_t);
	AtPropSet();
	size_t size() const;
	void addProp (BBClassifier&);
	std::vector<bool> checkBlock (const BasicBlock*);
};
extern AtPropSet the_AtPropSet;

} // namespace llvm
