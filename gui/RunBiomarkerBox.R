args <- commandArgs(TRUE)

library('rmarkdown')
library('filesstrings')

## Main arguments
modality <- args[1] ## Analysis mode
of <- args[2] ## Output folder
sf = "../functions/" # folder containing the functions within docker

## Creation of a report folder
report = paste0(of, "0_Analysis_Reports/")
dir.create(report)

## A function to move the output reports to ther report folder
moveout <- function(rmd){
  file.move(paste0(sf, paste0(rmd,".pdf")), report, overwrite = TRUE)
  file.move(paste0(sf, paste0(rmd,".html")), report, overwrite = TRUE)
  file.move(paste0(sf, paste0(rmd,".tex")), report, overwrite = TRUE)}

#### Analysis modes ####

if(modality == "QC"){
  
  # Execution of the data quality analysis
  rmarkdown::render(paste0(sf,"1a_Data_QC.Rmd"), params = list(outfolder=of, pdata = args[3], cdata = args[4], covclass = args[5], refcov = args[6]), output_format="all")
  moveout("1a_Data_QC")
  
}else if(modality == "Preprocessing"){

  # Execution of the data preprocessing analysis
  rmarkdown::render(paste0(sf,"1b_Preprocessing.Rmd"), params = list(outfolder=of, pdata = args[3], cdata = args[4], covclass = args[5], refcov = args[6]), output_format="all")
  moveout("1b_Preprocessing")

}else if(modality == "Attribute"){
  
  # Execution of the attribute analysis
  rmarkdown::render(paste0(sf,"2a_Attribute_analysis.Rmd"),params = list(outfolder=of, pdata = args[3], covclass = args[4], refcov = args[5], covord = args[6]), output_format="all")
 moveout("2a_Attribute_analysis")
  
}else if(modality == "Correlation"){
  
  # Execution of the correlation analysis
  rmarkdown::render(paste0(sf,"2b_Correlation_plot.Rmd"), params = list(outfolder=of, pdata = args[2], covclass = args[3], rthreshold=args[4], pvalthreshold=args[5]), output_format="all")
  moveout("2b_Correlation_plot")
  
}else if(modality == "DESeq2"){
  
  # Execution of the DESeq2 analysis
  rmarkdown::render(paste0(sf,"3a_DESeq2.Rmd"), params = list(outfolder=of, pdata = args[2], cdata = args[3], covclass= args[4], refcov = args[5], covord=args[5], covtomodel=args[7], logfcthreshold=args[8], pvalthreshold=args[9]), output_format="all")
  moveout("3a_DESeq2")
  
}else if(modality == "PCA"){
  
  # Execution of the PCA analysis
  rmarkdown::render(paste0(sf,"3b_PCA_by_covariates.Rmd"), params = list(outfolder=of, pdata = args[3], cdata=args[4], covclass = args[5], refcov = args[6], covord = args[7]), output_format="all")
  moveout("3b_PCA_by_covariates")
  
}

# #### Running examples #### 
# 
# sf = "/Users/giulioferrero/Desktop/Project/CRC/1_BiomarkerBox/0_Script/"
# of = "/Users/giulioferrero/Desktop/Project/CRC/1_BiomarkerBox/0_Script/"
# 
# rmarkdown::render(paste0(sf,"1a_Data_QC.Rmd"), params = list(outfolder=sf, pdata = pdata, cdata = cdata, covclass = covclass, refcov=refcov), output_format="all")
# 
# rmarkdown::render(paste0(sf,"1b_Preprocessing.Rmd"), params = list(outfolder=sf, pdata = pdata, cdata = cdata, covclass = covclass, refcov = refcov), output_format="all")
# 
# rmarkdown::render(paste0(sf,"2a_Attribute_analysis.Rmd"), params = list(outfolder=sf, pdata = pdata, covclass = covclass, refcov = refcov, covord = covord), output_format="all")
# 
# rmarkdown::render(paste0(sf,"2b_Correlation_plot.Rmd"), params = list(outfolder=of, pdata = pdata, covclass = covclass, rthreshold=0.5, pvalthreshold=0.00001), output_format="all")
# 
# rmarkdown::render(paste0(sf,"3a_DESeq2.Rmd"), params = list(outfolder=sf, pdata = pdata, cdata = cdata, covclass=covclass, refcov = refcov, covord=covord, covtomodel=covtomodel, logfcthreshold=1, pvalthreshold=0.05), output_format="all")
# 
# rmarkdown::render(paste0(sf,"3b_PCA_by_covariates.Rmd"), params = list(outfolder=sf, pdata = pdata, cdata = cdata, covclass = covclass, refcov = refcov, covord = covord), output_format="all")