library(shiny)
library(shinyFiles)
library(fs)

###### Server
server <- function(input, output, session) {
  
  volumes <- c(Home = fs::path_home())
  
  shinyFileChoose(input, "sdata", roots = volumes, session = session)
  
  sdat <- reactive({
    req(input$sdata)
    if (is.null(input$sdata))
      return(NULL)    
    return(parseFilePaths(volumes, input$sdata)$datapath)
    })

  shinyFileChoose(input, "sdata_class", roots = volumes, session = session)
  
  sdat_class <- reactive({
    req(input$sdata_class)
    if (is.null(input$sdata_class))
      return(NULL)
    return(parseFilePaths(volumes, input$sdata_class)$datapath)
  })
  
  shinyFileChoose(input, "cdata", roots = volumes, session = session)
  
  cdat <- reactive({
    req(input$cdata)
    if (is.null(input$cdata))
      return(NULL)    
    return(parseFilePaths(volumes, input$cdata)$datapath)
  })
  
  ref <- reactive(input$ref)
  
  shinyDirChoose(
    input, 'outf', roots = volumes, session = session
  )
  
  outf <- reactive({
    req(input$outf)
    if (is.null(input$outf))
      return(NULL)    
    return(parseDirPath(volumes, input$outf))
  })
  
###### Input operations
  
  output$sdatat <- DT::renderDataTable({
    if(is.null(sdat())){
    return(NULL)}
    updateSelectInput(session, "ref", choices = names(read.delim(sdat(), check.names = F, row.names=1)))
    updateSelectInput(session, "ref2", choices = names(read.delim(sdat(), check.names = F, row.names=1)))
    return(DT::datatable(read.delim(sdat(), check.names = F, row.names=1), filter = 'top', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5)))
    })
  
  output$cdatat <- DT::renderDataTable({
    if(is.null(cdat())){return(NULL)}
    DT::datatable(read.delim(cdat(), check.names = F, row.names=1), filter = 'top', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5))})
  
###### QC operations
  
  observeEvent(input$start_QC, {
    
    valsQC <- reactiveValues()
    valsQC$QC_out <- system(paste("Rscript RunBiomarkerBox.R QC", outf(), sdat(), cdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })

###### Pre-processing analysis operations

  observeEvent(input$start_Pre, {
    
    valsPre <- reactiveValues()
    valsPre$Pre_out <- system(paste("Rscript RunBiomarkerBox.R Preprocessing", outf(), sdat(), cdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })
  
###### Attribute analysis operations

  observeEvent(input$start_Attr, {
    
    valsAttr <- reactiveValues()
    valsAttr$Attr_out <- system(paste("Rscript RunBiomarkerBox.R Attribute", outf(), sdat(), sdat_class(), ref()))
    
    showModal(modalDialog("The analysis is completed"))
    
  })  

###### PCA analysis operations   

  observeEvent(input$start_PCA, {
    
    valsPCA <- reactiveValues()
    valsPCA$PCA_out <- system(paste("Rscript RunBiomarkerBox.R PCA", outf(), sdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })    

###### Correlation analysis operations 
  
  observeEvent(input$start_Corr, {
    
    valsCorr <- reactiveValues()
    valsCorr$Corr_out <- system(paste("Rscript RunBiomarkerBox.R Attribute", outf(), sdat(), sdat_class(), input$rcor, input$pcor))
    
    showModal(modalDialog("The analysis is completed"))
    
  })  
  
###### Differential analysis operations   
  
  observeEvent(input$start_Diff, {
    
    valsDiff <- reactiveValues()
    valsDiff$Diff_out <- system(paste("Rscript RunBiomarkerBox.R DESeq2", outf(), sdat(), sdat_class(), input$ref, input$ldiff, input$pdiff, input$ref2))
    
    showModal(modalDialog("The analysis is completed"))
    
  })
  
###### Machine Learning analysis operations

###### Survival analysis operations  
  
}