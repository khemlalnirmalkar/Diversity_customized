#!/bin/bash

##stratifications
humann2_split_stratified_table --input humann2_genefam_all79_SEN_uni90_to_KO_names_relab.tsv --output stratified/

regrouping and renaming pathways

humann2_regroup_table --input humann2_geneFam_all79Joint_SEN.tsv --groups uniref90_ko --output humann2_genefam_all79_SEN_uni90_to_KO.tsv

#uniref90 to E.C.
humann2_regroup_table --input raw_UniRef90_onlyJoint/humann2_geneFam_all79Joint_SEN.tsv --groups uniref90_level4ec --output EC_level4/humann2_SEN_uni90_to_EC.tsv 


humann2_rename_table --input humann2_genefam_all79_SEN_uni90_to_KO.tsv --output humann2_genefam_all79_SEN_uni90_to_KO_names.tsv --names kegg-orthology



##diversity calculations

#first biom conversation
biom convert -i table.txt -o table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5

# example
biom convert -i humann2_genefam_all79_SEN_KO_name_edt_unstratified.tsv -o humann2_genefam_all79_SEN_KO_name_edt_unstratified_hdf5.biom --table-type="OTU table" --to-hdf5



qiime tools import \
  --input-path humann2_SEN_KOstrati_txt_hdf5.biom \
  --output-path humann2_SEN_KO_strati_hdf5.qza \
  --type "FeatureTable[Frequency]"

#check the depth
biom summarize-table -i humann2_genefam_all79_SEN_KO_name_edt_unstratified_hdf5.biom > unstrati_KO_depth.tsv

###unstratufied KO's

  qiime diversity core-metrics \
  --i-table humann2_SEN_KO_unstrati.qza \
  --p-sampling-depth 496516 \
  --m-metadata-file metadata_qiim2.tsv \
  --output-dir core-metrics-dep496K_results


  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_results/evenness_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_results/evenness-group-significance.qzv


  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_results/shannon_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_results/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_results/observed_features_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_results/observed_features_vector.qzv

##stratified KO's

qiime diversity core-metrics \
  --i-table humann2_SEN_KO_strati_hdf5.qza \
  --p-sampling-depth 496516 \
  --m-metadata-file metadata_qiim2.tsv \
  --output-dir core-metrics-dep496K_strati-results

  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_strati-results/evenness_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_strati-results/evenness-group-significance.qzv


  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_strati-results/shannon_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_strati-results/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-dep496K_strati-results/observed_features_vector.qza \
  --m-metadata-file metadata_qiim2.tsv \
  --o-visualization core-metrics-dep496K_strati-results/observed_features_vector.qzv