#ifndef BOW_PRIOR_H_
#define BOW_PRIOR_H_

#include "strings.h"

#define BOOST_FILESYSTEM_VERSION 3

#include "boost/filesystem/operations.hpp"
#include "boost/filesystem/path.hpp"
#include "boost/progress.hpp"
#include <iostream>

using std::string;
using std::cout;
using std::endl;

namespace fs = boost::filesystem;

namespace ml    {

    struct bowY_t   {
        bowY_t (const size_t id = -1, const string y_k = "") : id_(id), name_ (y_k), sample_size_ (0) {}

        void set_name(const string nm) { name_ = nm; }
        string get_name() { return name_; }

        void set_id (const size_t s)    { id_ = s; }
        const size_t get_id()   { return id_; }

        void create_bag_of_words (const string train_data)  {
            word_count_ = split_count (train_data);
            // print_map (word_count_);
        }

        void set_sample_size(const size_t n)    { sample_size_ = n; }
        const size_t get_sample_size()  { return sample_size_; }

        const size_t get_word_count (const string word)    { return word_count_[word]; }

        const size_t get_bag_size() { return word_count_.size(); }

        word_count_t& get_bow ()    { return word_count_; }

        private:
        size_t id_;
        word_count_t word_count_;
        string name_;
        size_t sample_size_;
    };

    void train_yk (bowY_t& y, const string directory_name, const int num_train_samples = -1 /*Use all available samples*/)  {
        fs::path p (directory_name);

        if (fs::exists(p))  {
            if (fs::is_directory(p))    {
                string fstr = "";
                auto samples = 0;
                auto first = fs::directory_iterator(p);
                auto last = fs::directory_iterator();
                //if (num_train_samples != -1) last = first;//std::next(first, num_train_samples);
                //std::advance(last, num_train_samples);
                assert (first != last);
                for (auto itr = first; (itr != last) && (samples != num_train_samples); ++itr)  {
                    if (fs::is_regular_file (*itr))   {
                        fstr += read_file_as_string ((*itr).path().string());
                        ++samples;
                    }
                }
                y.create_bag_of_words (fstr);// cout << fstr << endl;
                y.set_sample_size (samples); // cout << "\n#Samples: " << samples << endl;
            }
            else cout << p << " is not a directory\n";
        }
        else cout << p << " doesn't exist!\n";
    }
}

#endif
