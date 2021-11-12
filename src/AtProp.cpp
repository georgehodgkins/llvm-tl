#include <llvm/Analysis/TLProp/AtProp.hpp>
#include <utility>
#include <cassert>
#include <algorithm>

namespace llvm {

AtProp::AtProp (BBClassifier& func) : cache(), decide(func) {
	assert(func != nullptr);
}

bool AtProp::check (BasicBlock* BB) {
	const auto lookup = cache.find(BB);
	if (lookup != cache.end()) return *lookup;
	
	bool result = decide(BB);
	cache.insert(std::make_pair(BB, result));
	return result;
}

AtPropSet::AtPropSet(const BBClassifier* iset, size_t n) : props() {
   if (instat) throw std::runtime_error("AtPropSet is a singleton!");
   instat = true;

   props.reserve(n);
   for (size_t i = 0; i < n; ++i) addProp(iset[i]);
}

AtPropSet::AtPropSet() : AtPropSet(nullptr, 0) {}

size_t AtPropSet::size() const {
	return props.size();
}

void AtPropSet::addProp(BBClassifier& c) {
	props.emplace_back(c);
}

std::vector<bool> AtPropSet::checkBlock (BasicBlock* BB) {
	std::vector<bool> checkSet (size());
	// let's learn how to use lambdas, he said...
	std::transform(props.begin(), props.end(), checkSet.begin(),
			[BB](AtProp& P) {return P.check(BB)});
	return checkSet;
}


} // namespace llvm
	
