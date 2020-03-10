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
  
###### Input operations
  
  output$sdatat <- DT::renderDataTable({
    if(is.null(sdat())){
    return(NULL)}
    DT::datatable(read.delim(sdat(), check.names = F), filter = 'top', options = list(scrollX=T, autoWidth = TRUE))
    contents_sdata <- read.delim(sdat(), check.names = F)
    updateSelectInput(session, "ref", choices = names(contents_sdata))
    })
  
  output$cdatat <- DT::renderDataTable({
    if(is.null(cdat())){return(NULL)}
    DT::datatable(read.delim(cdat(), check.names = F), filter = 'top', options = list(scrollX=T, autoWidth = TRUE))})
  
###### QC operations
  
  observeEvent(input$start_QC, {
    
    valsQC <- reactiveValues()
    valsQC$QC_out <- system(paste("Rscript RunBiomarkerBox.R QC ~/Desktop/", sdat(), cdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })

###### Attribute analysis operations

###### Correlation analysis operations 

###### Differential analysis operations   
  
###### Machine Learning analysis operations
  
}