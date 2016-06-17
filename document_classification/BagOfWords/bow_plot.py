import matplotlib
matplotlib.use('pdf')
import matplotlib.pyplot as plt

import pylab as pl

def get_plot_data (fname):
    with open (fname) as f:
        lines = [l.strip() for l in f.readlines() if l != '\n']

        samples = []
        features = []
        accuracy = []

        for l in lines:
            beg = 0
            end = 0
            beg = l.find (":", beg)
            end = l.find (",", beg)
            # print (beg, end, l[beg + 2: end])
            samples.append (int(l[beg + 2: end]))
            beg += 1

            beg = l.find (":", beg)
            end = l.find (",", beg)
            features.append (int(l[beg + 2: end]))
            beg += 1

            beg = l.find (":", beg)
            end = l.find (",", beg)
            accuracy.append (float(l[beg + 2: end]))

        samples = [s if s != -1 else 400 for s in samples]  #Replace -1 with some big number
        return (samples, features, accuracy)

def plot_bow(pname = 'bow'):
    s,f,a = get_plot_data(pname)
    #print (s, '\n', f, '\n', a)
    pl.title ("Document Classifier based on Naive Bayes MLE")

    col_str = ['b', 'g', 'r', 'y', 'm', 'c']
    feature_str = ['5', '10', '15', '20', '25', '30']

    for c in range(6):
        pl.plot ([s[i+c] for i in range(len(s)-1) if (i%6 == 0)], [a[j+c] for j in range(len(a)-1) if (j%6 == 0)], col_str[c], label='#Features='+feature_str[c]+', Acc='+str(a[c+54]))
    
    pl.xlabel ('#Training samples from each category')
    pl.ylabel ('Accuracy of classification\n(452 test samples, 5 categories)')

    pl.grid()

    pl.legend(loc='lower right')
    
    pl.show()
    pl.savefig (pname + '.png')

if __name__ == "__main__":
    plot_bow ("bow_results.txt.v0")
