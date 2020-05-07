This section will perform a quality control analysis and preprocessing of the input data verifying:

* The consistency of the sample IDs
* The presence of NA values
* The presence of non numeric values in the count table
* The normality of the data distribution
* The presence of outlier values

The following report files will be generated:

* 1a_Data_QC.html
* 1a_Data_QC.pdf
* 1a_Data_QC.tex

All the report files will be generated in the folder **0_Analysis_Reports**

The following output files will be generated:

* QC_Summary_phenoData.pdf
* QC_Summary_countData.pdf
* Preprocessing_Table_Normal_distribution_analysis.txt
* Preprocessing_Table_Outlier_analysis.txt
* Preprocessing_Plot_Outlier_analysis_boxplot_attribute.pdf - attribute is the id of the attribute considered

All the output files will be generated in the folder **01_QC_and_Data_Preprocessing**