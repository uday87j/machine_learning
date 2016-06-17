import os

def rename_file(old_name, new_name):
    """Rename files"""
    if os.path.exists(old_name):
        os.rename(old_name, new_name)
    else:
        print "\nError: File %s doesn't exist!" % old_name

def append_file_str(fname, fid):
    """Append a csv line
    fname,fid
    """
    return fname + "," + str(fid)

def assign_label_to_file(fname, fid):
    return append_file_str(fname, fid)

def assign_label_to_dir(dirname, dir_id, outfile = None, create_outfile=False):
    """Assign dir_id to all files in dirname directory"""
    
    files = os.listdir(dirname)
    label_str = ""

    for f in files:
        label_str += append_file_str(f, dir_id) + "\n"

    if outfile != None:
        if create_outfile == True:
            of = open(outfile, 'w')
        else:
            of = open(outfile, 'a')
        if of != None:
            of.write(label_str)
        else:
            print "\nError opening ", outfile

    return label_str


        
if __name__ == "__main__":
    
#Set2
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set2/cat", 1, "truth_2.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set2/tree", 2, "truth_2.txt")

#Set3
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BarackObama", 1, "truth_3_1.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BenStiller", 2, "truth_3_1.txt")
    #delete_files_from_truth("./truth_3.txt", "./err_file_names_3.txt")

#Set4    
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BarackObama", 1, "truth_4.txt", True)
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BenStiller", 2, "truth_4.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JuliaRoberts", 3, "truth_4.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JuliaStiles", 4, "truth_4.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/MarkRuffalo", 5, "truth_4.txt")

#Set4   5
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JuliaStiles", 1, "truth_5.txt", True)
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/MarkRuffalo", 2, "truth_5.txt")
    #assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JuliaRoberts", 3, "truth_5.txt")

#Set4   5
    assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JS", 1, "truth_6.txt", True)
    assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/MR", 2, "truth_6.txt")
    assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/JR", 3, "truth_6.txt")
    assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BO", 4, "truth_6.txt")
    assign_label_to_dir("/work/scratch/machine_learning/test_images/set3/public_faces/BS", 5, "truth_6.txt")
