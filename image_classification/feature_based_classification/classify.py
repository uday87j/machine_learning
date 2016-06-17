import os 
import re 
import cv2
import numpy as np

def get_surf_descriptors(img, hessian_limit = 400):
    """Read the image & return SURF descriptors

    img: Type numpy.ndarray
    
    Returns:
    kp: Key-Points
    des: Descriptors
    """

    surf = cv2.xfeatures2d.SURF_create()
    surf.setExtended(True)  #Get 128-bit desc
    surf.setHessianThreshold(hessian_limit)   # Let's try different values: 400, 800, 1000

    kp, des = surf.detectAndCompute(img, None)

    return kp, des

def flatten_descriptors(desc):
    """Convert desc to 1 X n array
    
    desc: numpy array m X n
    
    Returns: numpy array of shape 1 X n    
    """
    return desc.reshape(1, -1)

def get_flattened_surf_descriptors(img):
    """Read the image & return SURF descriptors

    img: Type numpy.ndarray
    
    Returns:
    kp: Key-Points
    des: Descriptors
    """

    kp, des = get_surf_descriptors(img)
    des = flatten_descriptors(des)
    return kp, des

def append_descriptors(desc1, desc2):
    """Append desc1 to desc2 array
    
    desc1: numpy array m X d
    desc2: numpy array n X d

    Return:
    desc3: (m + n) X d
    """
    return np.vstack((desc1, desc2))

def create_surf_descreptors(dirname, resize_img = True, new_size = (50, 50), ext = 'jpeg,jpg,png'):
    """Create SURF desc for images in dirname with extension

    dirname: String
    ext: Comma separated Strings
    
    Return:
    m X n numpy.array where
    m is no. of files inside dirname
    n is no. dimensions in feature vector

    err_files which couldn't be processed

    >>>> create_surf_descreptors('../test_images/set2', 'jpeg, jpg, png')
    """

    elist = ext.split(",")
    desc_all_imgs = np.zeros(128)
    desc_sizes = []
    file_names = []
    err_files = []

    for f in os.listdir(dirname):
        for e in elist:
            if e in f:
                # print f
                file_names.append(f)
                img = cv2.imread(dirname + os.path.sep + f, 0)   #0: Read as GrayScale
                if img != None:
                    if resize_img:
                        img = cv2.resize(img, new_size)

                    kp, des = get_surf_descriptors(img, 400)
                    
                    if des != None:
                        desc_all_imgs = append_descriptors(desc_all_imgs, des)
                        desc_sizes.append(len(kp))
                    else:
                        print "\nError: get_surf_descriptors() returned None!"
                else:
                    err_files.append(f)
                    print "\nError: img is None for file %s" % f

    np.delete(desc_all_imgs, 0, 0)  # Delete 1st row as it is dummy

    return file_names, desc_all_imgs, desc_sizes, err_files

def gen_image_descriptors(dirname, uid):
    """Test image in dirname

    uid is used as unique id to create output files

    Output:
    desc_uid.txt : SURF descriptors
    desc_sizes_uid.txt : Respective sizes of SURF descriptors
    file_names_uid.txt : File names of successfully read images
    err_files_uid.txt: File names of images that could not be read
    """
    fnames, desc, desc_sizes, err_files = create_surf_descreptors(dirname, True, (200, 200))
    print "\nTotal no. files: ", len(fnames)
    print "\nTotal no. error files: ", len(err_files)

    np.savetxt('desc_' + str(uid) + '.txt', desc)

    desc_size_f = file('desc_sizes_' + str(uid) + '.txt', 'w')
    desc_size_f.writelines(["%s\n" % it for it in desc_sizes])

    fnames_f = file('file_names_' + str(uid) + '.txt', 'w')
    fnames_f.writelines(["%s\n" % it for it in fnames if it not in err_files])

    err_f = file('err_file_names_' + str(uid) + '.txt', 'w')
    err_f.writelines(["%s\n" % it for it in err_files])

def delete_files_from_truth(true_file, rem_file):
    """Dlete lines having specific files in Truth file
    as some might be erroneous
    """
    lines = []
    rem_lines = []
    f = open(true_file, 'r')
    if f != None:
        lines = f.readlines()
        # print len(lines)
        f.close()
    else:
        print "\nError opening %s" % true_file

    rf = open(rem_file, 'r')
    flist = rf.readlines()

    f = open(true_file, 'w')
    if f != None:
        for line in lines:
            for fl in flist:
                if fl.strip() in line and len(fl) == (len(line) - 2): #Dirty hack to match 1st char
                    if line not in rem_lines:
                        # print fl, line
                        rem_lines.append(line)

        # print len(rem_lines)
        for rl in rem_lines:
            if rl in lines:
                lines.remove(rl)
       # print len(lines)
        f.writelines(lines)
    else:
        print "\nError opening %s" % true_file

def search_replace(in_str, pat, rep):
    """In in_str, search for pat & replace with rep"""
    p = re.compile(pat)
    return p.sub(rep, in_str)

def correct_names_file(fname, delim = ",", rep = "_"):
    """Replace occurances of delim with rep"""
    f = open(fname)
    if f != None:
        lines = f.readlines()
        pat = re.compile(".*,.*\.jpg")
        #for line in lines:
        for idx in range(0, len(lines)):
            line = lines[idx]
            match_it = pat.finditer(line)
            for m in match_it:
                # print m.group(), m.span()
                # print "\nOrig: ", line
                s = search_replace(m.group(), ",", "_")
                line = pat.sub(s, line)
                # print "\nSub: ", line
                lines[idx] = line

        f.close()

        f = open(fname, 'w')
        if f != None:
            f.writelines(lines)
        else:
            print "\nError opening %s" % fname

    else:
        print "\nError opening %s" % fname

def run_set(dirname, set_id):
    """Run creation of necessary files for classification"""
    gen_image_descriptors(dirname, set_id)

if __name__ == '__main__':

# Test SURF on a single file
    # filename = '../test_images/set2/cat5.jpeg'
    # img = cv2.imread(filename, 0)   #0: Read as GrayScale
    # kp, des = get_flattened_surf_descriptors(img)
    # print type(kp), len(kp)
    # print type(des), des.shape

# Test SURF on a directory of files
    #run_set('/work/scratch/machine_learning/test_images/set2', 2)
    #run_set('/work/scratch/machine_learning/test_images/set3/public_faces/images_2', 3)
    #run_set('/work/scratch/machine_learning/test_images/set3/public_faces/images_5', 4) 
    run_set('/work/scratch/machine_learning/test_images/set3/public_faces/images_3', 5) 
    #run_set('/work/scratch/machine_learning/test_images/set3/public_faces/images_6', 6) 

#Set2
   #gen_image_descriptors('/work/scratch/machine_learning/test_images/set2', 2) 

#Set3
    #gen_image_descriptors('/work/scratch/machine_learning/test_images/set3/public_faces/images_2', 3) 
    #delete_files_from_truth("./truth_3.txt", "./err_file_names_3.txt")
    #correct_names_file("./truth_3.txt")

#Set4
    #gen_image_descriptors('/work/scratch/machine_learning/test_images/set3/public_faces/images_5', 4) 
    #delete_files_from_truth("./truth_4.txt", "./err_file_names_4.txt")
    #correct_names_file("./truth_4.txt")
    #correct_names_file("./file_names_4.txt")

#Set4
    #gen_image_descriptors('/work/scratch/machine_learning/test_images/set3/public_faces/images_3', 5) 
    #delete_files_from_truth("./truth_5.txt", "./err_file_names_5.txt")
    #correct_names_file("./truth_5.txt")
    #correct_names_file("./file_names_5.txt")

#Set4
    #gen_image_descriptors('/work/scratch/machine_learning/test_images/set3/public_faces/images_6', 6) 
    #delete_files_from_truth("./truth_6.txt", "./err_file_names_6.txt")
    #correct_names_file("./truth_6.txt")
    #correct_names_file("./file_names_6.txt")

