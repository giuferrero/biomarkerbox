This section will perform a differential level analysis of the count data providing:

* The DESeq2-normalized level of the input data
* The median and average level of the data for each sample class
* The results of a pairwise differential analysis between pairs of sample classes
* The overlap between the results
* The graphical representation of the analysis results

The following report files will be generated:

* 3a_DESeq2.html
* 3a_DESeq2.pdf
* 3a_DESeq2.tex

All the report files will be generated in the folder **0_Analysis_Reports**

The following output files will be generated:

* DESeq_Table_Normalized_count_table.txt
* DESeq_Table_Median_average_normalized_counts.txt
* DESeq_Table_DE_results_class1_vs_class2.txt - class1, class2 = sample classes compared
* DESeq_Table_DE_results_class1_vs_class2_significant.txt - class1, class2 = sample classes compared
* DESeq_Table_Merged_DESeq2_results.txt
* DESeq_Table_Overlapped_Results.txt
* DESeq_Plot_Volcano_plot_class1_vs_class2.pdf - class1, class2 = sample classes compared
* DESeq_Plot_analysis_boxplot_attribute.pdf - attribute = specific attribute plotted
* DESeq_Plot_Upset_DE_result_overlap.pdf

All the output files will be generated in the folder **03_Count_Data_Analysis**