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
  
  output$sdatatext <- renderText({sdat()})
  output$cdatatext <- renderText({cdat()})
  output$outftext <- renderText({outf()})
  output$test <- renderText({refpos()})
  
  output$ibox <- renderInfoBox({
    infoBox(
      "Reference covariate:",
      input$ref,
      icon = icon("credit-card")
    )
  })
  
  ### Input check for running the analysis
  observe({
    req(input$sdata)
    updateActionButton(session, "sdata",
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
    req(input$ref)
    req(input$outf)
    updateActionButton(session, "start_Attr",
                       label = "Run the analysis",
                       icon = icon("play-circle"))
    req(input$cdata)
    updateActionButton(session, "start_QC",
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
    updateSelectInput(session, "ref", choices = names(read.delim(sdat(), row.names=1, check.names=F)))
    updateSelectInput(session, "ref2", choices = names(read.delim(sdat(), row.names=1, check.names=F)))
    updateSelectInput(session, "attrvar1", choices = names(
      Filter(is.numeric, read.delim(sdat(), row.names=1, check.names=F))))
    updateSelectInput(session, "corvar1", choices = names(
      Filter(is.numeric, read.delim(sdat(), row.names=1, check.names=F))))
    updateSelectInput(session, "corvar2", choices = names(
      Filter(is.numeric, read.delim(sdat(), row.names=1, check.names=F))))
    updateSelectInput(session, "pcavar1", choices = names(read.delim(sdat(), row.names=1, check.names=F)))
    return(DT::datatable(read.delim(sdat(), row.names=1), filter = 'none', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5)))
    })
  
  output$cdatat <- DT::renderDataTable({
    if(is.null(cdat())){return(NULL)}
    DT::datatable(read.delim(cdat(), row.names=1, check.names=F), filter = 'none', options = list(scrollX=T, autoWidth = TRUE, pageLength = 5))})
  
##### Load input data
sdata <- reactive({
  req(input$sdata)
  sdata <- read.delim(sdat(), row.names=1, check.names=F)
})

refpos <- reactive({
  req(input$sdata)
  req(input$ref)
  refpos <- match(input$ref, names(sdata()))
})

ref2pos <- reactive({
  req(input$sdata)
  req(input$ref2)
  refpos <- match(input$ref2, names(sdata()))
})

cdata <- reactive({
  req(input$cdata)
  sdata <- read.delim(cdat(), row.names=1, check.names=F)
})

cdata.pca <- reactive({
  req(input$cdata)
  req(input$sdata)
  cdata <- cdata()[, row.names(sdata())]
  cdata.pca <- prcomp(log(t(cdata)+1,2), center=T, scale=T)
  cdata.pca <- cbind(cdata.pca$x, sdata())
})

###### QC operations
  
  observeEvent(input$start_QC, {
    
    req(input$sdata)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsQC <- reactiveValues()
    valsQC$QC_out <- system(paste("Rscript RunBiomarkerBox.R QC", outf(), sdat(), cdat(), refpos()))
    
    showModal(modalDialog("The QC analysis is completed", footer = modalButton("OK")))
  })
  
  QCvar1 <- reactive(input$QCvar1)
  
  output$attrplot1 <- renderPlotly({
    print(ggplotly(
      plot_intro(QCvar1())  + 
        theme_bw()
    ))})
  
###### Attribute analysis operations
    observeEvent(input$start_Attr, {
      
      req(input$sdata)
      req(input$ref)
      req(input$outf)
      
    valsAttr <- reactiveValues()
    valsAttr$Attr_out <- system(paste("Rscript RunBiomarkerBox.R Attribute", outf(), sdat(), refpos()))
    showModal(modalDialog("The attribute analysis is completed", footer = modalButton("OK")))    })
    
  attrvar1 <- reactive(input$attrvar1)
   
  output$attrplot1 <- renderPlotly({
    print(ggplotly(
        ggplot(data = sdata(), aes_string(x = input$ref, y = paste0("`",input$attrvar1,"`"), fill = input$ref)) + 
    geom_violin(trim=FALSE, alpha=0.5) + 
    geom_jitter(position = position_jitter(0.2), alpha=0.5) + 
    geom_boxplot(width = 0.05, fill="white", outlier.alpha = 0) +
    labs(x=input$ref, fill=input$ref)  + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=0.5)) +
    scale_fill_viridis(discrete=T)
    ))})
  
  output$attrout1 <- renderText(
    if(is.null(sdat())){return("Please insert the input data")}
    else if(class(sdata()[,input$attrvar1]) == "numeric"){
       return(kruskal.test(sdata()[,input$attrvar1]~sdata()[,input$ref])$p.value)
      }
    else{
    return("Please select a numeric covariate")
    }  
    )
  
###### PCA analysis operations   

  observeEvent(input$start_PCA, {
    
    req(input$sdata)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsPCA <- reactiveValues()
    valsPCA$PCA_out <- system(paste("Rscript RunBiomarkerBox.R PCA", outf(), sdat(), cdat(), refpos()))
    
    showModal(modalDialog("The PCA analysis is completed", footer = modalButton("OK")))  })  
  
  pcavar1 <- reactive(input$pcavar1)
  
  output$pcaplot1 <- renderPlotly({
    
    #p <- fviz_eig(cdata.pca, ggthem = theme_bw(), main=NULL)
    #cdata.pca <- cbind(cdata.pca$x, sdata()[,input$pcavar1])
    
    print(ggplotly(
      ggplot(cdata.pca(), aes_string(x="PC1", y="PC2", col=paste0("`",input$pcavar1,"`")))+
        geom_point(size=2, alpha=0.75)+
        theme_bw() + 
        theme(legend.position="top") + 
     #   labs(colour=covid2) +
        scale_fill_viridis(discrete=T)))
  })
  
  output$pcaout1 <- renderText(
    if(is.null(cdat())){return("Please insert the input data")}
    else if(class(sdata()[,input$corvar1]) == "numeric" & class(sdata()[,input$corvar2]) == "numeric"){
      res_p=cor.test(sdata()[,input$corvar1], sdata()[,input$corvar2], na.action="complete.case", method="pearson")
      return(paste0("Pearson's r = ", round(res_p$estimate,4), "\n\n", "p-value =", round(res_p$p.value,4)))
    }
    else{
      
      return("Please select two numeric covariates")
    })

###### Correlation analysis operations 
  
  observeEvent(input$start_Corr, {
    
    req(input$sdata)
    req(input$ref)
    req(input$outf)
    
    valsCorr <- reactiveValues()
    valsCorr$Corr_out <- system(paste("Rscript RunBiomarkerBox.R Correlation", outf(), sdat(), input$rcor, input$pcor))
    
    showModal(modalDialog("The correlation analysis is completed", footer = modalButton("OK")))    
  })
  
  corvar1 <- reactive(input$corvar1)
  corvar2 <- reactive(input$corvar2)
  
  output$corplot1 <- renderPlotly({
    print(ggplotly(
      ggplot(data = sdata(), aes_string(x = paste0("`",input$corvar1,"`"), y = paste0("`",input$corvar2,"`"), fill = input$ref)) + 
        geom_point(size=2, alpha=0.75) +
        labs(fill=input$ref)  + 
        theme_bw() + 
        theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=0.5)) +
        scale_fill_viridis(discrete=T)
    ))})

  output$corrout1 <- renderText(
    if(is.null(sdat())){return("Please insert the input data")}
    else if(class(sdata()[,input$corvar1]) == "numeric" & class(sdata()[,input$corvar2]) == "numeric"){
      res_p=cor.test(sdata()[,input$corvar1], sdata()[,input$corvar2], na.action="complete.case", method="pearson")
      return(paste0("Pearson's r = ", round(res_p$estimate,4), "\n\n", "p-value =", round(res_p$p.value,4)))
    }
    else{
      return("Please select two numeric covariates")
    })
  
  output$corrout2 <- renderText(
    if(is.null(sdat())){return("Please insert the input data")}
    else if(class(sdata()[,input$corvar1]) == "numeric" & class(sdata()[,input$corvar2]) == "numeric"){
      res_s=cor.test(sdata()[,input$corvar1], sdata()[,input$corvar2], na.action="complete.case", method="spearman")
      return(paste0("Spearman rho = ", round(res_s$estimate,4), "\n\n", "p-value =", round(res_s$p.value,4)))
    }
    else{
      return("Please select two numeric covariates")
    })
  
###### Differential analysis operations   
  
  observeEvent(input$start_Diff, {
    
    req(input$sdata)
    req(input$ref)
    req(input$outf)
    req(input$cdata)
    
    valsDiff <- reactiveValues()
    valsDiff$Diff_out <- system(paste("Rscript RunBiomarkerBox.R DESeq2", outf(), sdat(), cdat(), refpos(), ref2pos(), input$ldiff, input$pdiff))
    
    showModal(modalDialog("The DESeq2 analysis is completed", footer = modalButton("OK")))    
  })
  
###### Machine Learning analysis operations

###### Survival analysis operations  
  
}