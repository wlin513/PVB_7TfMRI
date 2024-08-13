#! /bin/bash

# script to generate physiological regressors


echo 'Enter Subject Number'
read subject
echo 'Enter blockname'
read blkname


base_dir=/media/sf_2023_Peking_DRL
physio_dir="${base_dir}/physio/"

epidir="${base_dir}/funcimgs/${subject}/${blkname}/task_func/"

epi_image=`ls ${epidir}*.nii.gz`

infile=${physio_dir}${subject}/${blkname}/${subject}_${blkname}_physio.txt
outfile=${physio_dir}${subject}/${blkname}/${subject}_${blkname}_pnm
outdir=${physio_dir}${subject}/${blkname}/
file=${subject}_${blkname}_pnm

pnm_stage1 -i ${infile} -o ${outfile} -s 400 --tr=1.375 --resp=2 --cardiac=3 --trigger=1 --rvt

#make a matlab ready file

 sed -e s'@\\n.* @@'  -e s'@\"@@' -e '/function/d' -e '/return/d' -e s'@}.*@@' -e s'@\\n.*@@' <${outfile}_pnm.js >${outfile}_matlab.txt

# put in the extra lines into stage 2 needed to run later analyses

echo "${outfile}_pnm_stage3" >> "${outfile}_pnm_stage2"

# create stage 3

echo '#!/bin/sh' >"${outfile}_pnm_stage3"


echo "${FSLDIR}/bin/pnm_evs -i ${epi_image} -o ${outfile} --tr=1.375 -c ${outfile}_card.txt -r ${outfile}_resp.txt --oc=4 --or=4 --multc=2 --multr=2 --rvt=${outfile}_rvt.txt  --slicedir=y --slicetiming=${physio_dir}slice_timing.txt" >> "${outfile}_pnm_stage3"
echo "cd ${outdir}">> "${outfile}_pnm_stage3"
echo 'find '"${outdir}${file}"'ev0*  > '"${outfile}"'_evlist.txt' >> "${outfile}_pnm_stage3"
echo "cd ${wd}">> "${outfile}_pnm_stage3"
chmod a+x "${outfile}_pnm_stage3"


