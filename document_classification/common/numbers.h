#ifndef ML_NUMBERS_H_
#define ML_NUMBERS_H_

#include <vector>
#include <random>
#include <limits>
#include <algorithm>

namespace ml    {

    template<bool unique = false, typename T = int32_t, typename DISTRIBUTION = std::uniform_int_distribution<> >
        struct genT {

            genT(const T minT =std::numeric_limits<T>::min(), const T maxT = std::numeric_limits<T>::max())
                : dis_(minT, maxT)  {
                    
                    if (minT > maxT)    {
                        typename DISTRIBUTION::param_type p(maxT, minT);
                        dis_.param(p);
                    }

                    std::random_device rd;
                    gen_.seed(rd());
                }

            T operator ()() {
                auto p = dis_(gen_);
                if (unique) {
                    for (auto& a : vec_)    {
                        if (a == p) {
                            return this->operator()();
                        }
                    }
                }

                vec_.push_back(p);
                
                return vec_.back();
            }

            DISTRIBUTION dis_;
            std::mt19937 gen_;
            std::vector<T> vec_;
        };

    typedef genT<> int_gen_t;

    template <bool unique = false, typename T=int>
        std::vector<T> generate_numbers (const T minT, const T maxT, const size_t N) {
            genT<unique, T> g (minT, maxT);
            std::vector<T> vec(N);
            std::generate (begin(vec), end(vec), g);
            return vec;
        }

    template <typename fwd_itr_t>
        fwd_itr_t max (fwd_itr_t first, fwd_itr_t last) {
            auto m = *first;
            auto ret = first;
            while (++first != last)   {
                if (*first > m) {
                    m = *first;
                    ret = first;
                }
            }
            return ret;
        }

}
#endif
