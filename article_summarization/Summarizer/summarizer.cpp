#include <iostream>
#include <fstream>

#include "numbers.h"
#include "strings.h"

using namespace std;
using namespace ml;

template <typename T>
void print_map(const T& m, ostream& os)  {
    for (auto& e : m) os << "[" << e.first << "]: " << e.second << endl;
}

void discount_articles(word_count_t& wc)    {
    vector<string> articles = {"a", "an", "the", "A", "An", "The"};
    for_each(begin(articles), end(articles),
            [&wc](const string& a)  { wc[a] = 0; });
}


void summarize(string fname)    {
    const size_t MAX_SUMMARY = 5;

    auto fstr = read_file_as_string(fname);

    //auto sentences = read_sentences_from_string(fstr);
    auto sentences = read_sentences_from_file(fname);
    auto original = read_sentences_from_file(fname);
    assert(sentences.size() == original.size());

    vector<int32_t> sentence_ranks(sentences.size(), -1);
    
    auto wmap = split_count(fstr);
    discount_articles(wmap);
    // print_map(wmap, cout);

    transform(begin(sentences), end(sentences), begin(sentence_ranks),
            [&wmap](const string& s)    {
            if (s.size() > 1)   {
                auto words = split(s);
                auto rank = accumulate(begin(words), end(words), 0,
                        [&wmap](int rank, const string& w) {
                            return rank + wmap[w];
                        });
                return rank;
            }
            return 0;
            });

    //auto summary = decltype(sentences);
    vector<string> summary(MAX_SUMMARY);
    vector<int32_t> top_ranks(MAX_SUMMARY);

    for (auto i = 0u; i < MAX_SUMMARY; ++i)  {
        uint32_t d = distance(begin(sentence_ranks), 
                ml::max(begin(sentence_ranks), end(sentence_ranks)));
        assert(d < sentences.size());
        top_ranks[i] = d;
        sentence_ranks[d] = -1;
    }

    sort(begin(top_ranks), end(top_ranks));
    for (auto i = 0u; i < top_ranks.size(); ++i) { summary[i] = original[top_ranks[i]]; }
    
    ofstream outf("summary");
    copy(begin(summary), end(summary), ostream_iterator<string>(outf, "\n\n"));
    outf.close();
}

int main()  {
    summarize("article_2");
    return 0;
}
