#!/bin/bash

# Marc Ferrell
# Script to establish FPKM Threshold values for all eXpress results.xprs or Cufflinks isoforms.fpkm_tracking (single sample) files in directory 
# Performs script on all files in the indicated directory
# Usage: ./threshold.sh <scripts_dir> <dir> <alpha_level>

# Must be full directory
SCRIPTS=$1
DIR=$2
SCRIPT=${SCRIPTS}/find_false_positives.R
SCRIPT2=${SCRIPTS}/clean.R
SCRIPT3=${SCRIPTS}/clean_cufflinks_gtf.R
A=$3

cd $DIR



for file in $(ls ${DIR}); do

	mkdir ${DIR}/${file}_output

    FORMAT=$(echo ${file} | awk -F. '{print $NF}')

	if [ ${FORMAT} == 'fpkm_tracking' ]; then
        grep "_" ${DIR}/${file} | cut -f 1,10-12 > ${DIR}/${file}_output/${file}_fpkm

		cd ${DIR}/${file}_output

       Rscript ${SCRIPT} ${DIR}/${file}_output/${file}_fpkm ${A}

       rm ${file}_fpkm

       cd ..
	fi

	 if [ ${FORMAT} == 'xprs' ]; then
       grep "_" ${DIR}/${file} | cut -f 2,11-13 > ${DIR}/${file}_output/${file}_fpkm

       cd ${DIR}/${file}_output

       Rscript ${SCRIPT} ${DIR}/${file}_output/${file}_fpkm ${A}

       rm ${file}_fpkm

		cd ..
	fi

    if [ ${FORMAT} == 'gtf' ]; then
        echo -e "ID\tFPKM\tFPKMlo\tFPKMhi" > ${DIR}/${file}_output/${file}_fpkm

        cd ${DIR}/${file}_output

awk '$3 == "transcript" {print $0}' ${DIR}/${file} |  cut -f 9  | cut -d ";" -f 2,3,5,6 | awk -F \" '{OFS = "\t"}; {print $2,$4,$6,$8}' | awk '$2 > 0 {print $0}' >> ${DIR}/${file}_output/${file}_fpkm

        Rscript ${SCRIPT} ${DIR}/${file}_output/${file}_fpkm ${A}

        cd ..

    fi


done



>thresholds.txt
for dir in $(ls | grep "output$"); do

    cat ${dir}/Threshold.txt >> thresholds.txt

done

mkdir ${DIR}/cleaned

for f in $(ls | grep -e "fpkm_tracking$" -e "xprs$" -e "gtf$"); do

    cd ${DIR}/cleaned

    FORMAT=$(echo ${f} | awk -F. '{print $NF}')

    nfile=$(echo $f | awk -F/ '{print $NF}' | awk -F. '{print $1}')

    fname="${nfile}_clean.${FORMAT}"

    if [[ ${FORMAT} == 'xprs' || ${FORMAT} == 'fpkm_tracking' ]]; then

        Rscript $SCRIPT2 ${DIR}/${f} ${DIR}/${f}_output/${f}_fpkm_include.txt > ${fname}


    elif [ ${FORMAT} == 'gtf' ]; then

        Rscript $SCRIPT3 ${DIR}/${f} ${DIR}/${f}_output/${f}_fpkm_include.txt > ${fname}

    fi

    cd ..

done



