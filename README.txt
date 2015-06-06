#****************************************************************************************************************
#
#		                            FPKM Threshold Finder 1.0
#
# Establish the minimum reliable FPKM value for an RNA-Seq quantification dataset at a given false positive rate.
#
# Author: Marc Ferrell
# 
# Please cite as : Ferrell, Marc. FPKM Threshold Finder. Version 1.0, Github: 5 June 2015
#
# Correspondence: Marc Ferrell: mferrell167@ufl.edu
#
#****************************************************************************************************************

##
#
# Description
#
##

	RNA sequencing for determination of differential expression necessitates the establishment of a threshold
value. Some reads will always map incorrectly by chance, leading to a number of genes in a sample detected 
erroneously. These false positives mostly have low F(R)PKM values, but can immensely skew downstream analysis. A 
statistically robust method has been employed to control the false positive rate by several authors (listed below). 
This method uses FPKM confidence intervals to infer false positives. Any element whose CI lower bound is zero and whose mean 
is greater than zero is considered a false positive. The false positive rate can then be estimated for any FPKM 
value used as a threshold. The FPKM Threshold Finder estimates the false positive rate for many potential 
threshold values, and returns the minimum value with the desired false positive rate. It then applies this value
to filter genes or isoforms below the threshold and creates a cleaned .fpkm_tracking or .xprs file that is 
ready for downstream analysis with Cuffdiff other other differential expression software. 

##
#
# Publications using this method of threshold establishment.
#
##

	* Zhang Y, et al., (2014) An RNA-sequencing transcriptome and splicing database of glia, neurons, and 
	      vascular cells of the cerebral cortex. Journal of Neuroscience 34(36): 11929-11947

	* Chen K, Deng S, Lu H, Zheng Y, Yang G, Kim D, Cao Q, Wu JQ (2013) RNA-seq characterization of spinal cord 
	      injury transcriptome in acute/subacute phases: a resource for understanding the pathology at the systems 
	      level. PLoS One 8:e72567.

	* Lerch JK, Kuo F, Motti D, Morris R, Bixby JL, Lemmon VP (2012) Isoform diversity and regulation in 
	      peripheral and central neurons revealed through RNA-Seq. PLoS One 7:e30417.

	* Ramskold D, Wang ET, Burge CB, Sandberg R (2009) An abundance of ubiquitously expressed genes revealed by
              tissue transcriptome sequence data. PLOS Comput Biol 12:e1000598

##
#
# Installation
#
##

1. Install dependencies

FPKM Threshold Finder has the following dependencies:
	
	* Bash (standard on any Mac or Linux machine)
	* Python 2.7 or later (https://www.python.org/downloads/  , also standard on Mac OS X 10.8 or later)
	    - package Tkinter (standard on current Python downloads but available here: http://tkinter.unpythonic.net/wiki/How_to_install_Tkinter)
	* Python Launcher (https://www.python.org/downloads/  , also standard on Mac OS X 10.8 or later)
	* R 3.1 or later (http://www.r-project.org/)
	    - package ggplot2 (install by entering ‘install.packages("ggplot2”)’ on the R console)
 

2. Download FPKM Threshold Finder

3. (May not always be necessary) Make scripts executable by opening a terminal window, typing “chmod +x “, dragging
   the FPKM Threshold Finder folder to the Terminal window, and typing “*”. Press enter and the scripts will become
   executable.   



##
#
# Usage
# 
##

1. Move all .fpkm_tracking and/or .xprs files to a folder.

2. Locate gui_threshold.pyw and double click on the file or right click and "Open With" Python Launcher.

3. The window may open behind by a terminal window. Follow the instructions on the window to select the FPKM Threshold Finder
   downloaded previously. Also select the folder containing your data, enter your desired alpha (false positive rate) 
   value, and click "Execute".

4. Do not alter the FPKM Threshold Finder folder or your data folder until the "Done" message is displayed. Runtime can be
   up to 3 minutes per .fpkm_tracking/.xprs file.

##
#
# Troubleshooting
#
##

		* This application may not work properly if there spaces in the files and folders used in the analysis.
		
		* Hashbangs may be incorrect for your computer. To find the correct hashbang for threshold.sh, use the 
		  command “which bash”, and for gui_threshold.pyw, use “which python”. 

		* If some high-expression genes or isoforms are not in the cleaned file, it is because the program
		  initially filters out all elements that do not have a RefSeq identifier. If this is a major 
		  problem, let me know and I will include an option to disable this function in future versions.

##
#
# Input
#
##

	Input files must all be in either .fpkm_tracking (http://cole-trapnell-lab.github.io/cufflinks/file_formats/)
format produced by Cufflinks or .xprs (http://bio.math.berkeley.edu/eXpress/manual.html) format, produced by eXpress. 
All input files should be in a single folder. 


##
#
# Output
#
##

	FPKM Threshold Finder creates an output folder for each input file with the “_output” tag within the indicated
data folder. The software also creates a summary file, “thresholds.txt”, listing each input file and its calculated 
FPKM threshold. All genes or isoforms with an FPKM below this threshold should be considered zero. A threshold of “-Inf”
means that there is no need for a threshold value. 

	Within the new folder “cleaned”:

		* For each .fpkm_tracking or .xprs file, a new “clean” file is placed in the folder “cleaned”. These 
		  quantification files have the desired false positive rate.  

	Within each new output folder:

		* Threshold.txt : Text file with the threshold for the input file.
		
		* included.txt : List of genes/isoforms to be included in downstream analysis.

		* excluded.txt : List of genes/isoforms to be excluded from downstream analysis.

		* <input>.pdf : Plot of the false positive rate as a function of FPKM threshold. Horizontal line
				indicates the specified alpha value. 

##
#
# Example
#
##

	Example data were produced from poly-A RNA sequencing data analyzed with an augmented Tuxedo pipeline. This
pipeline produced .fpkm_tracking and .xprs quantification files, and will be described in greater detail at the time 
of publication. To establish thresholds and clean both of these files, please follow these instructions:

	1. Open the FPKM Threshold Finder by double-clicking on gui_threshold.pyw or “Open With” the Python Launcher.

	2. Click “Select Threshold Finder Location” and select the folder “FPKM_Threshold_Finder”.
	
	3. Click “Select Data Folder” and select the folder “example”.

	4. Enter the alpha level “0.05”.

	5. Click “Execute”. (Program will run for 2-3 minutes)

	6. The “example” folder should now match the “example_results” folder. 
