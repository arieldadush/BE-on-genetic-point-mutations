#!/bin/bash
# Dictionary  of the opposite letter
reverse_letter(){
    nuleutide=$(echo $1 |awk '{print toupper($0)}');
	if [ $nuleutide == "A" ]; then echo "T"; fi;
	if [ $nuleutide == "T" ]; then echo "A"; fi;
	if [ $nuleutide == "G" ]; then echo "C"; fi;
	if [ $nuleutide == "C" ]; then echo "G"; fi;
}
# path to the genome refernce
genome="/private/dropbox/Genomes/Human/hg38/hg38.fa"
# path to create temp file of BED format for query 
out_temp="$PWD/TEMP.bed";
# create the temp file
touch $out_temp;
# loop that read the table line by line
# "/private5/Projects/dadush/clinvar_base_editing/Erez_15_03_23/Erez_with_nAn_values_15_3_23.tsv"
cat "/private5/Projects/dadush/clinvar_base_editing/Erez_15_03_23/Erez_with_nAn_values_15_3_23__ver2.tsv" | while read -r line; do 
	# select only the columns of the BED format
	reg_base=$(echo -e $line |cut -d ' ' -f1-3 | awk '{print $1 "\t" $2 "\t" $3}');
	# extract the original nucleotide
	base_original=$(echo -e $line |cut -d ' ' -f4 | cut -d ">" -f1 |awk '{print toupper($0)}');
	# extract the alternate nucleotide
	base_alt=$(echo -e $line |cut -d ' ' -f4 | cut -d ">" -f2 | awk '{print toupper($0)}'); 
	echo -e $reg_base | tr " " "\t" > $out_temp;
	# check that the base is only one letter
	if [ ${#base_original} -eq 1 -a ${#base_alt} -eq 1 ];  then 
		#echo "$reg_base";
		# run bedtools get fasta to find the base in the genome refernce
		base_place_0=$(bedtools getfasta -fi $genome -bed $out_temp| awk 'NR==2' | awk '{print toupper($0)}')
		#echo -e "${reg_base}\t${base_place_0}";
		# if the base in the table equal  to the base from the genome refernce that means it is + strand 
		if [[ $base_original == $base_place_0 ]]; then # + strand
			#echo -e "${reg_base}\t${base_original}\tpositive";
			# get base before the mutation
			region_before=$(echo -e $reg_base | awk '{print $1 "\t" $2 -1 "\t" $3 -1}')
			echo -e $region_before | tr " " "\t" > $out_temp;
			base_place_before_1=$(bedtools getfasta -fi $genome -bed $out_temp| awk 'NR==2' | awk '{print toupper($0)}')
			# get base after the mutation
			region_after=$(echo -e $reg_base | awk '{print $1 "\t" $2 +1 "\t" $3 +1}')
			echo -e $region_after | tr " " "\t" > $out_temp;
			base_place_after_1=$(bedtools getfasta -fi $genome -bed $out_temp| awk 'NR==2' | awk '{print toupper($0)}')
			#echo -e "${reg_base}\t${base_original}\tpositive\t${base_place_before_1}\t${base_place_after_1}";
			# add the line the base before, after and the strand
			echo -e "${line}\t${base_place_before_1}\t${base_place_after_1}\t+"
		#if the base in the table  not equal to the base from the genome refernce that maybe means it is - strand 
		else 
			#create the bed format for the base before 
			#echo -e "${reg_base}\t${base_original}\tnegative\t${base_place_0}";
			region_before=$(echo -e $reg_base | awk '{print $1 "\t" $2 +1 "\t" $3 + 1}')
			echo -e $region_before | tr " " "\t" > $out_temp;
			# get the base before by bedtools
			base_place_before_1=$(bedtools getfasta -fi $genome -bed $out_temp| awk 'NR==2' | awk '{print toupper($0)}')
			base_place_before_1=$(reverse_letter $base_place_before_1)
			# create the bed format for the base after
			region_after=$(echo -e $reg_base | awk '{print $1 "\t" $2 -1 "\t" $3 -1}');
			echo -e $region_after | tr " " "\t" > $out_temp;
			# get the base after by bedtools
			base_place_after_1=$(bedtools getfasta -fi $genome -bed $out_temp| awk 'NR==2' | awk '{print toupper($0)}')
			base_place_after_1=$(reverse_letter $base_place_after_1)
			# add to the line the base before and after and strand
			echo -e "${line}\t${base_place_before_1}\t${base_place_after_1}\t-"
		fi;
	# if it is not in the two strands then put NA 
	else 
		#echo -e "${reg_base}\t${base_original}\tNotSNV\tNA\tNA";
		echo -e "${line}\tNA\tNA\tNA"
	fi;
	#echo "-------------------------------"
done 