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
  
  ### Input check for running the analysis
  observe({
    req(input$sdata)
    updateActionButton(session, "sdata",
                       icon = icon("check-circle"))  
  })
  
  observe({
    req(input$sdata_class)
    updateActionButton(session, "sdata_class",
                       icon = icon("check-circle"))  
  })
  
  observe({
    req(input$cdata)
    updateActionButton(session, "cdata",
                       icon = icon("check-circle"))  
  })
  
  observe({
    req(input$outf)
    updateActionButton(session, "outf",
                       icon = icon("check-circle"))  
  })

  ### Input check for running the analysis
  observe({
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    updateActionButton(session, "start_Attr",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    req(input$cdata)
    updateActionButton(session, "start_QC",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    
    updateActionButton(session, "start_Pre",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    
    updateActionButton(session, "start_PCA",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    
    updateActionButton(session, "start_Corr",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    
    updateActionButton(session, "start_Diff",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    })
  
###### Input operations
  
  output$sdatat <- DT::renderDataTable({
    if(is.null(sdat())){
    return(NULL)}
    updateSelectInput(session, "ref", choices = names(read.delim(sdat(), check.names = F, row.names=1)))
    updateSelectInput(session, "ref2", choices = names(read.delim(sdat(), check.names = F, row.names=1)))
    updateSelectInput(session, "var1", choices = names(read.delim(sdat(), check.names = F, row.names=1)))
    return(DT::datatable(read.delim(sdat(), check.names = F, row.names=1), filter = 'top', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5)))
    })
  
  output$cdatat <- DT::renderDataTable({
    if(is.null(cdat())){return(NULL)}
    DT::datatable(read.delim(cdat(), check.names = F, row.names=1), filter = 'top', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5))})
  
##### Load input data
sdata <- reactive({
req(input$sdata)
req(input$sdata)
req(input$ref)

sdata <- read.delim(sdat(), check.names=F, row.names=1)

})
  
###### QC operations
  
  observeEvent(input$start_QC, {
    
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsQC <- reactiveValues()
    valsQC$QC_out <- system(paste("Rscript RunBiomarkerBox.R QC", outf(), sdat(), cdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })

###### Pre-processing analysis operations

  observeEvent(input$start_Pre, {
    
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsPre <- reactiveValues()
    valsPre$Pre_out <- system(paste("Rscript RunBiomarkerBox.R Preprocessing", outf(), sdat(), cdat(), sdat_class(), input$ref))
    showModal(modalDialog("The analysis is completed"))
    
  })
  
###### Attribute analysis operations
    observeEvent(input$start_Attr, {
      
      req(input$sdata)
      req(input$sdata_class)
      req(input$ref)
      req(input$outf)
      
    valsAttr <- reactiveValues()
    valsAttr$Attr_out <- system(paste("Rscript RunBiomarkerBox.R Attribute", outf(), sdat(), sdat_class(), input$ref))
    showModal(modalDialog("The analysis is completed"))
    })
    
   var1 <- reactive(input$var1)
   
  output$test <- renderPlotly({
    print(ggplotly(
        ggplot(data = sdata(), aes_string(x = input$ref, y = paste0("`",input$var1,"`"), fill = input$ref)) + 
    geom_violin(trim=FALSE, alpha=0.5) + 
    geom_jitter(position = position_jitter(0.2), alpha=0.5) + 
    geom_boxplot(width = 0.05, fill="white", outlier.alpha = 0) +
    labs(x=input$ref, fill=input$ref)  + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=0.5)) +
    scale_fill_viridis(discrete=T)
    #stat_compare_means(comparisons = totest_p, label = "p.signif", method = "wilcox.test", hide.ns=F)
    ))})
  
###### PCA analysis operations   

  observeEvent(input$start_PCA, {
    
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsPCA <- reactiveValues()
    valsPCA$PCA_out <- system(paste("Rscript RunBiomarkerBox.R PCA", outf(), sdat(), sdat_class(), input$ref))
    
    showModal(modalDialog("The analysis is completed"))
    
  })    

###### Correlation analysis operations 
  
  observeEvent(input$start_Corr, {
    
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsCorr <- reactiveValues()
    valsCorr$Corr_out <- system(paste("Rscript RunBiomarkerBox.R Correlation", outf(), sdat(), sdat_class(), input$rcor, input$pcor))
    
    showModal(modalDialog("The analysis is completed"))
    
  })  
  
###### Differential analysis operations   
  
  observeEvent(input$start_Diff, {
    
    req(input$sdata)
    req(input$sdata_class)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsDiff <- reactiveValues()
    valsDiff$Diff_out <- system(paste("Rscript RunBiomarkerBox.R DESeq2", outf(), sdat(), sdat_class(), input$ref, input$ldiff, input$pdiff, input$ref2))
    
    showModal(modalDialog("The analysis is completed"))
    
  })
  
###### Machine Learning analysis operations

###### Survival analysis operations  
  
}