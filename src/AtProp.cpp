#include "AtProp.hpp"
#include "BBClassifiers.hpp"
#include <utility>
#include <cassert>
#include <cstdlib>
#include <algorithm>
#include <sstream>

namespace llvm {

AtProp::AtProp (BBClassifier& func) : cache(), decide(func) {
	assert(func != nullptr);
}

bool AtProp::check (BasicBlock* BB) {
	const auto lookup = cache.find(BB);
	if (lookup != cache.end()) return lookup->second;
	
	bool result = decide(BB);
	cache.insert(std::make_pair(BB, result));
	return result;
}

bool AtPropSet::instat = false;

AtPropSet::AtPropSet(BBClassifier* iset, size_t n) : props() {
   if (instat) throw std::runtime_error("AtPropSet is a singleton!");
   instat = true;

   props.reserve(n);
   for (size_t i = 0; i < n; ++i) addProp(iset[i]);
}

AtPropSet::AtPropSet() : AtPropSet(nullptr, 0) {}

size_t AtPropSet::size() const {
	return props.size();
}

void AtPropSet::addProp(BBClassifier c) {
	props.emplace_back(c);
}

std::vector<bool> AtPropSet::checkBlock (BasicBlock* BB) {
	std::vector<bool> checkSet (size());
	auto lambda = [BB](AtProp& P) {return P.check(BB);};
	std::transform(props.begin(), props.end(), checkSet.begin(), lambda);
	return checkSet;
}

// DFS callback to ensure a formula uses only available atprops
bool AtPropSet::checkFormula (spot::formula f) {
	if (!f.is(spot::op::ap)) return false; // not an atprop
	
	const std::string& name = f.ap_name();
	if (strncmp("atp", name.c_str(), 3)) throw std::invalid_argument("Atprop prefix missing");
	char* pcheck = NULL;
	unsigned long id = std::strtoul(name.c_str() + 3, &pcheck, 0);
	if (id == 0 && pcheck == name.c_str() + 3) throw std::invalid_argument("Atprop index malformed");
	
	if (id >= size()) throw std::invalid_argument("Atprop index does not exist");
	return true;
}
	
AtPropSet the_AtPropSet (atprop_iset, ATPROP_ISET_SIZE);

} // namespace llvm
	
