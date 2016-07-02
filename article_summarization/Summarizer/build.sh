g++ -pedantic -Wall -std=c++17 \
-I/cygdrive/c/code/ml/common \
-I/cygdrive/c/code/cpp/external/boost_1_61_0 \
summarizer.cpp \
-L/usr/local/lib -lboost_filesystem -lboost_system -llibboost_regex \
-o sum && ./sum
