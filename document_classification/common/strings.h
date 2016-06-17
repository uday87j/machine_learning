#ifndef ML_STRINGS_H_
#define ML_STRINGS_H_

#include <string>
#include <iterator>
#include <algorithm>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <fstream>
#include <iostream>

#define BOOST_FILESYSTEM_VERSION 3

#include "boost/filesystem/operations.hpp"
#include "boost/filesystem/path.hpp"
#include "boost/progress.hpp"

namespace fs = boost::filesystem;

using std::string;
using std::cout;
using std::endl;

namespace ml    {

    // Splits a sentance into words by assuming "whitespace" as delimiter
    std::vector<std::string> split (const std::string& sentance)  {
        std::istringstream iss (sentance);
        std::vector<std::string> words;
        std::copy (std::istream_iterator<std::string>(iss),
                std::istream_iterator<std::string>(),
                std::back_inserter(words));
        return words;        
    }

    // Assume: dst is writeable up to number of words in sentance
    template <typename FwdItr>
    FwdItr split (const std::string& sentance, FwdItr dst)  {
        std::istringstream iss (sentance);
        std::vector<std::string> words;
        return std::copy (std::istream_iterator<std::string>(iss),
                std::istream_iterator<std::string>(),
                dst);
    }

    // Splits a sentance into words by assuming "whitespace" as delimiter
    // Creates a map<word, count>
    std::unordered_map<std::string, size_t> split_count (const std::string& sentance)  {
        std::istringstream iss (sentance);
        std::unordered_map<std::string, size_t> word_count_map;
        std::for_each (std::istream_iterator<std::string>(iss),
                std::istream_iterator<std::string>(),
                [&] (const std::string& s)  { word_count_map[s] += 1; });
        return word_count_map;        
    }


    template <typename in_itr_t, typename map_t>
        void create_set (const in_itr_t first, const in_itr_t last, map_t& dst) {
            std::for_each (first, last, [&] (const typename in_itr_t::value_type& val)   { dst[val] += 1; });
        }

    template <typename map_itr_t, typename vec_itr_t>
        std::vector<typename vec_itr_t::value_type> create_set (const map_itr_t& first, const map_itr_t& last, vec_itr_t& dfirst, vec_itr_t& dlast) {
            std::vector<typename vec_itr_t::value_type> res;
            std::for_each (first, last, [&] (const typename map_itr_t::value_type& val) { if (dlast != std::find (dfirst, dlast, val.first)) res.push_back(val.first); });
            return res;
        }

    // Assume: vec_t supports push_back()
    template <typename map_t, typename vec_t>
        void create_set (const map_t& m, vec_t& v)  {
            std::for_each (begin(m), end(m), [&] (const typename map_t::value_type& val) 
                    { if (end(v) == std::find (begin(v), end(v), val.first)) v.push_back(val.first); });
        }

    std::vector<std::string> read_file (const std::string& fname)    {
        std::ifstream f (fname);
        std::vector<std::string> vec;
        std::string word ("");
        while (f >> word)   { vec.push_back(word); }
        f.close();
        return vec;
    }

    std::string read_file_as_string (const std::string& fname)  {
        std::ifstream f (fname);
        std::string fstr ("");
        std::string word ("");
        while (f >> word)   { fstr += word + " "; }
        f.close();
        return fstr;
    }

    template <typename map_t>
    void print_map (const map_t& map_inst)   {
        for (auto& w : map_inst) std::cout << "(" << w.first << ", " << w.second << ")" << std::endl;
    }

    const size_t get_regular_file_count (const std::string& dirname)    {
        auto count = 0;
        fs::path p (dirname);

        if (fs::exists(p))  {
            if (fs::is_directory(p))    {
                // cout << p << " is a directory\n" ;
                // auto fname = *fs::directory_iterator(p);
                // cout  << std:: boolalpha << fs::is_regular_file (fname) << endl;
                for (auto itr = fs::directory_iterator(p); itr != fs::directory_iterator(); ++itr)  {
                    if (fs::is_regular_file(*itr))  { ++count; }
                }
            }
            else cout << p << " is not a directory\n";
        }
        else cout << p << " doesn't exist!\n";

        return count;
    }


    // Helpful typedef(s)
    typedef std::unordered_map<std::string, size_t> word_count_t;

}
#endif
