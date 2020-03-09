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
  
  shinyFileChoose(input, "cdata", roots = volumes, session = session)
  
  cdat <- reactive({
    req(input$cdata)
    if (is.null(input$cdata))
      return(NULL)    
    return(parseFilePaths(volumes, input$cdata)$datapath)
  })
  
  #### Input operations
  output$sdatat <- DT::renderDataTable({
    if(is.null(sdat())){return(NULL)}
    DT::datatable(read.delim(sdat()), filter = 'top', options = list(scrollX=T, autoWidth = TRUE))})
  
  output$cdatat <- DT::renderDataTable({
    
    cdata <- input$cdata
    if(is.null(cdat())){return(NULL)}
    DT::datatable(read.delim(cdat()), filter = 'top', options = list(scrollX=T, autoWidth = TRUE))})
  
  #### QC operations
  
  observeEvent(input$start_QC, {
    
    vals <- reactiveValues()
    vals$QC_out <- system(paste("Rscript RunBiomarkerBox.R QC ~/Desktop/", sdat(), cdat(), "~/Desktop/Sample_Data_cov_class.txt", "Diet"))
    
    showModal(modalDialog("The analysis is completed"))
    
  })
  
  output$plot1 <- renderPlot({
    histdata <- rnorm(500)
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  #### ML operations
  
}