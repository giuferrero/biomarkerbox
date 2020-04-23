args <- commandArgs(TRUE)

library('rmarkdown')
library('filesstrings')

## Main arguments
modality <- args[1] ## Analysis mode
of <- args[2] ## Output folder
sf = "./functions/" # folder containing the functions within docker

## Creation of a report folder
report = paste0(of, "/0_Analysis_Reports/")
dir.create(report)

## A function to move the output reports to ther report folder
moveout <- function(rmd){
  file.move(paste0(sf, paste0(rmd,".pdf")), report, overwrite = TRUE)
  file.move(paste0(sf, paste0(rmd,".html")), report, overwrite = TRUE)
  file.move(paste0(sf, paste0(rmd,".tex")), report, overwrite = TRUE)}

#### Analysis modes ####

if(modality == "QC"){
  
  # Execution of the data quality analysis
  rmarkdown::render(paste0(sf,"1a_Data_QC.Rmd"), params = list(outfolder=of, pdata = args[3], cdata = args[4], refcov = args[5]), output_format="all")
  moveout("1a_Data_QC")
  
}else if(modality == "Attribute"){
  
  # Execution of the attribute analysis
  rmarkdown::render(paste0(sf,"2a_Attribute_analysis.Rmd"), params = list(outfolder=of, pdata = args[3], refcov = args[4]), output_format="all")
 moveout("2a_Attribute_analysis")
  
}else if(modality == "Correlation"){
  
  # Execution of the correlation analysis
  rmarkdown::render(paste0(sf,"2b_Correlation_plot.Rmd"), params = list(outfolder=of, pdata = args[3], rthreshold=args[4], pvalthreshold=args[5]), output_format="all")
  moveout("2b_Correlation_plot")
  
}else if(modality == "DESeq2"){
  
  # Execution of the DESeq2 analysis
  rmarkdown::render(paste0(sf,"3a_DESeq2.Rmd"), params = list(outfolder=of, pdata = args[2], cdata = args[3], refcov = args[4], covtomodel=args[5], logfcthreshold=args[6], pvalthreshold=args[7]), output_format="all")
  moveout("3a_DESeq2")
  
}else if(modality == "PCA"){
  
  # Execution of the PCA analysis
  rmarkdown::render(paste0(sf,"3b_PCA_by_covariates.Rmd"), params = list(outfolder=of, pdata = args[3], cdata=args[4], refcov = args[5]), output_format="all")
  moveout("3b_PCA_by_covariates")
  
}