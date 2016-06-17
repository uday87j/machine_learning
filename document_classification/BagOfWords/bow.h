#include "prior.h"

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
          bowY_t{POL, "politics"}, bowY_t{SPO, "sport"}, bowY_t{TEC, "tech"}}  {

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

        accuracy_t test(int32_t feature_length = 10)   { 
            // auto test_file = *fs::directory_iterator(fs::path(dataset_[0] + "/test/"));
            double py = 1.0, max_py = std::numeric_limits<double>::max() * -1.0;
            string cat  = "";
            auto cat_id = -1u;
            //auto accuracy = 0.0;
            auto err_count = 0, hit_count = 0;
            auto total_samples = 0;

            std::uint32_t didx   = BUS;

            for (didx = BUS; didx != TOTAL_YK; ++didx) {
            total_samples += get_regular_file_count (fs::path(dataset_[didx] + "/test/").string());

            for (auto itr = fs::directory_iterator(fs::path(dataset_[didx] + "/test/"));
                    itr != fs::directory_iterator()/*err_count != 1*/; ++itr)  {
                
                //auto itr = std::next(fs::directory_iterator(fs::path(dataset_[POL] + "/test/")), 2);
                auto test_file = *itr;
                //py  = 1.0;
                max_py = std::numeric_limits<double>::max() * -1.0;

                if (fs::is_regular_file(test_file)) {
                    auto test_data = read_file (test_file.path().string());
                    // std::cout << test_data.size() << std::endl;

                    // Check for each Yk category
                    std::for_each (std::begin(yk_), std::end(yk_), [&](bowY_t& yk) {
                        const size_t J = yk.get_sample_size(); // std::cout << J << std::endl;
                        py  = 1.0;
                        auto first  = std::begin(test_data);
                        auto last   = (feature_length == -1 ) ? std::end(test_data) : std::next(std::begin(test_data), feature_length);
                        std::for_each (first, last, [&](const string& word) {
                            //py *= std::log(p (yk.get_word_count(word), *this, J, 1.0));// std::cout << py << endl;
                            py *= (p (yk.get_word_count(word), *this, J, 1.0));// std::cout << py << endl;
                            //TODO: Handle tiny values
                        });
                        
                        // std::cout << yk.get_name() << " : " << py << std::endl;
                        assert (py != 0);

                        if (py > max_py)    {
                            max_py = py;
                            cat = yk.get_name();
                            cat_id = yk.get_id();
                        }
                    });
                    // std::cout << max_py << " " << cat << " " << cat_id << std::endl;
                    if (cat_id != didx) ++err_count;
                    else ++hit_count;
                }
            }
            }

            // std::cout << "\nTotal Samples: " << total_samples << ", Errors: " << err_count << ", Correct: " << (hit_count) <<  std::endl;

            //return (1 - (err_count / total_samples)) * 100;
            return static_cast<double>(hit_count) / total_samples;
        }

        string classify(const string& test_data_path, int32_t feature_length = 10)   { 

            auto test_data = read_file (test_data_path);

            double py = 1.0, max_py = std::numeric_limits<double>::max() * -1.0;
            string cat  = "";
            auto cat_id = -1;
            
            // Check for each Yk category
            std::for_each (std::begin(yk_), std::end(yk_), [&](bowY_t& yk) {
                const size_t J = yk.get_sample_size(); // std::cout << J << std::endl;
                py  = 1.0;
                auto first  = std::begin(test_data);
                auto last   = (feature_length == -1 ) ? std::end(test_data) : std::next(std::begin(test_data), feature_length);
                std::for_each (first, last, [&](const string& word) {
                    py *= (p (yk.get_word_count(word), *this, J, 3.0));// std::cout << py << endl;
                });
                std::cout << yk.get_name() << " : " << py << std::endl;
                if (py > max_py)    {
                    max_py = py;
                    cat = yk.get_name();
                    cat_id = yk.get_id();
                }
            });
             std::cout << max_py << " " << cat << " " << cat_id << std::endl;
            return cat;
        }

        std::vector<string> get_dict() const  { return dict_; }

        private:

        std::array<bowY_t, 5> yk_;
        std::array<string, 5> dataset_;
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
