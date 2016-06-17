#include "bow.h" 

#include <cassert>
#include <vector>

using namespace std;
using namespace ml;

void test_files ()  {
    bowY_t y{0, "business"};
    string dir = "c:/code/dataset/bbc-fulltext/bbc/business/stem";
    train_yk (y, dir);
    cout << y.get_bag_size() << " " << y.get_word_count ("detail") << endl;
    cout << get_regular_file_count (dir);
}

void demo_bow() {
    bow_classifier_t bc ("dict");

    ofstream fout ("bow_results.txt");

    vector<int32_t> train_samples_count {/*0, 1, 10, 50, 100, 150, 200, 250, 300,*/ -1};

    vector<int32_t> feature_length {/*5, 10, /*/15/*, 20 25, 30*/, /*-1*/}; // -1 causes probablity to reach 0 as it becomes very very small

    for (auto& i : train_samples_count)   {

        bc.train (i);
        
        for (auto& j : feature_length)    {
            
            auto acc = bc.test(j);

            fout << "\n#Train: " << i << ", Feature size: " << j << ", Accuracy: " << acc << endl;
        
        }
    }

    fout.close();

    // bc.train();
    // cout << "Accuracy: " << bc.test() << "%\n";
}

void random_classify()  {
    bow_classifier_t bc ("dict");
    
    bc.train();

    auto p = "c:/code/dataset/bbc-fulltext/bbc/business/stem/test/401.txt_stem";
    cout << boolalpha << "Classification result: " << (string ("business") == bc.classify (p)) << endl;

    p = "c:/code/dataset/bbc-fulltext/bbc/sport/stem/test/410.txt_stem";
    cout << boolalpha << "Classification result: " << (string ("sport") == bc.classify (p)) << endl;

    p = "./test_bus.txt";
    cout << bc.classify(p, 30) << endl;
}

int main()  {
    
    // test_files(0);
    // demo_bow();
    random_classify();


    return 0;
}

