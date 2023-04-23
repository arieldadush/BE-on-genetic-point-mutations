# directory of flags - enable to run the script in parallel
dir_flags="/private6/Projects/dadush/SIFT_try2/sift6.2.1/tmp/flags/"
# directory of all queries in fasta format
dir_query="/private6/Projects/dadush/SIFT_try2/sift6.2.1/tmp/refseq_id_with_fasta_format/"
#directory of all SIFT subtitions format
dir_subt="/private6/Projects/dadush/SIFT_try2/sift6.2.1/tmp/subtitions_sift_format/"
# directory of complete database
#db_prot_file="/private6/Projects/dadush/SIFT_try2/sift6.2.1/test/uniref90_db/uniref90.fa"
# directory of human database
db_prot_file="/private6/Projects/dadush/SIFT_try2/sift6.2.1/test/test_hg38_prot_db/GRCh38_latest_protein_shortHeders.faa"
sift_command="/private6/Projects/dadush/SIFT_try2/sift6.2.1/bin/SIFT_for_submitting_fasta_seq.csh"
# loop run on all queries in directory
for NP_name in $(ls $dir_query |sed 's/.fa//' |sort |uniq); do
        NP_flg=${dir_flags}"/"${NP_name}".flg"
        NP_query=${dir_query}"/"${NP_name}".fa"
        NP_subt=${dir_subt}"/"${NP_name}"_subt"
        if [[ -f $NP_flg ]]; then continue; fi
        #flag not exists - create a flag
        touch $NP_flg
        # write the analyze of specific query start
        echo "Start analyze, query: " $NP_query " subt: " $dir_subt
        # run the command of running SIFT and all comments are written to the flags
        $sift_command $NP_query $db_prot_file $NP_subt > $NP_flg
        # write the analyze finished
        echo "Finished analyze " $NP_name
        done