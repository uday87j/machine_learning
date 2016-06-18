#include "prior.h"
#include "numbers.h"

#include <array>
#include <fstream>
#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <limits>
#include <cstdint>

namespace ml    {

    struct bow_classifier_t;
    double p (double event, const bow_classifier_t& bc, size_t samples, double smooth = 1.0);

    struct bow_classifier_t {
        typedef double accuracy_t;

        enum yk_enum_t  { BUS = 0, ENT, POL, SPO, TEC, TOTAL_YK };

        bow_classifier_t( const string fname = "" )
        : yk_ {bowY_t{BUS, "business"}, bowY_t{ENT, "entertainment"},
          bowY_t{POL, "politics"}, bowY_t{SPO, "sport"}, bowY_t{TEC, "tech"}},
          prob_per_yk_ {0, 0, 0, 0, 0}  {

          string root_dir = "c:/code/dataset/bbc-fulltext/bbc/";
          dataset_[BUS]   = root_dir + "/business/stem/";
          dataset_[ENT]   = root_dir + "/entertainment/stem/";
          dataset_[POL]   = root_dir + "/politics/stem/";
          dataset_[SPO]   = root_dir + "/sport/stem/";
          dataset_[TEC]   = root_dir + "/tech/stem/";

          if (fname != "")  {
              dict_ = read_file (fname);
              //std::cout << "\nword_count:: " << dict_.size() << std::endl;
          }

        }

        void train(int num_train_samples = -1)    {
          for (auto i = 0u; i < yk_.size(); ++i) { train_yk (yk_[i], dataset_[i] + "/train", num_train_samples); }

          if (dict_.empty())    {
              std::for_each (std::begin(yk_), std::end(yk_), [&](bowY_t& y) { create_set (y.get_bow(), dict_); });
              std::cout << dict_.size() << std::endl;
              std::ofstream f ("dict");
              std::copy (std::begin(dict_), std::end(dict_), std::ostream_iterator<string>(f, "\n"));
          }
        }

        accuracy_t test(const int32_t feature_length = 10)   { 

            // auto test_file = *fs::directory_iterator(fs::path(dataset_[0] + "/test/"));

            auto err_count = 0, hit_count = 0;
            auto total_samples = 0;

            for (size_t didx = BUS; didx != TOTAL_YK; ++didx) {

                total_samples += get_regular_file_count (fs::path(dataset_[didx] + "/test/").string());

                for (auto itr = fs::directory_iterator(fs::path(dataset_[didx] + "/test/"));
                        itr != fs::directory_iterator(); ++itr)  {
                    
                    //auto itr = std::next(fs::directory_iterator(fs::path(dataset_[POL] + "/test/")), 2);

                    auto test_file = *itr;

                    if (fs::is_regular_file(test_file)) {
                        auto test_data = read_file (test_file.path().string());
                        // std::cout << test_data.size() << std::endl;

                        auto yi = max_prob_yk (test_data, feature_length);
                        assert (yi < TOTAL_YK);

                        // std::cout TOTAL_YK< yk_[yi].get_id() << " " << yk_[yi].get_name() << std::endl;

                        if ( yk_[yi].get_id()!= didx) ++err_count;
                        else ++hit_count;
                    }
                }
            }

            // std::cout << "\nTotal Samples: " << total_samples << ", Errors: " << err_count << ", Correct: " << (hit_count) <<  std::endl;

            //return (1 - (err_count / total_samples)) * 100;
            return static_cast<double>(hit_count) / total_samples;
        }

        string classify(const string& test_data_path, const int32_t feature_length = 10)   { 

            auto test_data = read_file (test_data_path);

            calc_prob_per_category(test_data, feature_length);

            auto yi = max_prob_yk (test_data, feature_length);
            assert (yi < TOTAL_YK);

            // std::cout TOTAL_YK< yk_[yi].get_id() << " " << yk_[yi].get_name() << std::endl;

            return yk_[yi].get_name();
        }

        std::vector<string> get_dict() const  { return dict_; }

        private:

        void calc_prob_per_category (const std::vector<string>& test_data, const int32_t feature_length) {

            double py  = 1.0;
            
            std::transform (std::begin(yk_), std::end(yk_), std::begin(prob_per_yk_),
                [&](bowY_t& yk) {
                
                const size_t J = yk.get_sample_size();
                py  = 1.0;
                
                auto first  = std::begin(test_data);
                auto last   = (feature_length == -1 ) ? std::end(test_data) 
                : std::next(std::begin(test_data), feature_length);
                
                std::for_each (first, last, [&](const string& word) {
                    //py *= std::log(p (yk.get_word_count(word), *this, J, 1.0));// std::cout << py << endl;
                    py *= (p (yk.get_word_count(word), *this, J, 1.0));// std::cout << py << endl;
                    //TODO: Handle tiny values

                });

                assert (py != 0);

                return py;
            });
        }

        const size_t max_prob_yk (const std::vector<string>& test_data, const int32_t feature_length)    {
            calc_prob_per_category (test_data, feature_length);

            auto max_itr = ml::max (std::begin(prob_per_yk_), std::end(prob_per_yk_));
            auto yi = std::distance (std::begin(prob_per_yk_), max_itr);

            return yi;
            
        }

        std::array<bowY_t, TOTAL_YK> yk_;
        std::array<string, TOTAL_YK> dataset_;
        std::array<double, TOTAL_YK> prob_per_yk_;
        std::vector<string> dict_;
    };

    // Probability
    double p (double event, const bow_classifier_t& bc, size_t samples, double smooth)   { 
        const size_t N = bc.get_dict().size();
        auto pr = (event + smooth) / (N + (smooth * samples)); // std::cout << pr << endl;
        assert (pr != 0.0);
        return pr;
    }
}
