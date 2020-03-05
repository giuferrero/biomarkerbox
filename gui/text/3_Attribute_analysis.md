This section will perform a quality control analysis on the input data verifying:

* The consistency of the sample IDs
* The presence of NA values
* The presence of non numeric values in the count table

The following report files will be generated:

* 2a_Attribute_analysis.html
* 2a_Attribute_analysis.pdf
* 2a_Attribute_analysis.tex

All the report files will be generated in the folder **0_Analysis_Reports**

The following output files will be generated:

* Attribute_analysis_Table_Differential_attributes_among_groups.tsv
* Attribute_analysis_Table_Differential_attributes_(class1)_vs_(class2).tsv (class1, class2 = classes compared)
* Attribute_analysis_Plot_Stacked_barplot_(attribute_id).pdf (attribute_id = attribute plotted)
* Attribute_analysis_Plot_Grouped_barplot_(attribute_id).pdf (attribute_id = attribute plotted)
* Attribute_analysis_Plot_Boxplot_(attribute_id).pdf (attribute_id = attribute plotted)

All the output files were generated in the folder **02_Sample_Data_Analysis**