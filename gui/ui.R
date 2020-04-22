#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source("../utils.R")
library("markdown")
library("shinyFiles")
library("shiny")
library("fs")
library("ggplot2")
library("ggthemes")
library("plotly")
library("reshape")
library("viridis")
library("ggfortify")
library("corrplot")
library("Hmisc")
library("dplyr")

ui <- dashboardPage(
  ## Header content
  dashboardHeader(title = "BiomarkeRbox"),

  ## Sidebar content
  dashboardSidebar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$script(src = "custom.js")
    ),
    sidebarMenu(
      menuItem("Input", tabName = "input", icon = icon("table")),
      menuItem("QC", tabName = "qc", icon = icon("tasks")),
      menuItem("Pre-processing analysis", tabName = "pre", icon = icon("th")),
      menuItem("Attribute analysis", tabName = "attr", icon = icon("th")),
      menuItem("PCA analysis", tabName = "PCA", icon = icon("th")),
      menuItem("Correlation analysis", tabName = "corr", icon = icon("th")),
      menuItem("Differential analysis", tabName = "diff", icon = icon("th")),
      menuItem("Prediction analysis", tabName = "pred", icon = icon("th")),
      menuItem("Feature selection analysis", tabName = "fs", icon = icon("th")),
      menuItem("Survival analysis", tabName = "surv", icon = icon("th"))
    )
  ),

## Body content
  dashboardBody(
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"),
      tabItems(
        # Input data
        tabItem(tabName = "input",
                fluidRow(
                  box(h3("Input data"),
                  h5("In this section you can insert the two main files required for the analysis."), status = "info", width = 12),
                  
                  box(p(strong("Please select a sample data file")),
                    shinyFilesButton("sdata", label="Sample data", title="Please select a sample data file", multiple = F, icon=icon("exclamation-circle")),
                    DT::dataTableOutput("sdatat"), width = 12),
                  
                  box(selectInput("ref", "Please select the reference covariate", choices = "Pending Upload"), width = 12),
                  
                  box(p(strong("Please select the file reporting the count data file")),
                    shinyFilesButton("cdata", "Count data", "Please select a count data file", multiple = F, icon=icon("exclamation-circle")), 
                    DT::dataTableOutput("cdatat"), width = 12),
                  
                  box(p(strong("Please select the output folder")),
                    shinyDirButton("outf", "Output folder", "Please select the output folder", icon=icon("exclamation-circle")), width = 12)
                  
        )),
        
        # QC tab
        tabItem(tabName = "qc",
                fluidRow(
                box(h3("Datasets quality control"), width = 12),
                box(includeMarkdown("./text/1_QC.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    actionButton("start_QC", "Waiting for input data", icon=icon("exclamation-circle")))
        )),
        
        # Pre-proccesing analysis tabe
        tabItem(tabName = "pre",
                fluidRow(
                box(h3("Pre-processing analysis of the data"), width = 12),
                box(includeMarkdown("./text/2_Preprocessing.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    actionButton("start_Pre", "Waiting for input data", icon=icon("exclamation-circle")))
        )),   
      
        # Attribute analysis tab
        tabItem(tabName = "attr",
                fluidRow(
                box(h3("Analysis of the sample attributes"), width = 12),
                box(includeMarkdown("./text/3_Attribute_analysis.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    actionButton("start_Attr", "Waiting for input data", icon=icon("exclamation-circle")),
                    width = 12),
                box(selectInput("attrvar1", "Please select a covariate", choices = "Pending Upload"), 
                    p(strong("P-value from Kruskal-Wallis test")), textOutput("attrout1"), width=4),
                box(plotlyOutput("attrplot1"), width=8))),
  
        # Correlation analysis tab
        tabItem(tabName = "PCA",
                fluidRow(
                box(h3("PCA analysis of the sample attributes"), width = 12),
                box(includeMarkdown("./text/7_PCA_analysis.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    actionButton("start_PCA", "Waiting for input data", icon=icon("exclamation-circle")),
                    width = 12),
                box(selectInput("pcavar1", "Please select a covariate", choices = "Pending Upload"), 
                    p(strong("Explained variance")), textOutput("pcaout1"), width=4),
                box(plotlyOutput("pcaplot1"), width=8)
        )),
        
        # Correlation analysis tab
        tabItem(tabName = "corr",
                fluidRow(
                box(h3("Analysis of the correlation between sample attributes"), width = 12),
                box(includeMarkdown("./text/4_Correlation_analysis.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    numericInput("rcor", "Correlation threshold", value = 0.6), 
                    numericInput("pcor", "Significance threshold", value = 0.05),
                    actionButton("start_Corr", "Waiting for input data", icon=icon("exclamation-circle")),
                    width = 12),
                box(selectInput("corvar1", "Please select a covariate", choices = "Pending Upload"), 
                    selectInput("corvar2", "Please select a covariate", choices = "Pending Upload"), 
                    p(strong("Results from Pearson correlation test")),
                    textOutput("corrout1"),
                    p(" "),
                    p(strong("Results from Spearman correlation test")),
                    textOutput("corrout2"),
                    width=4),
                box(plotlyOutput("corplot1"), width=8)
        )),

        # Differential analysis tab
        tabItem(tabName = "diff",
                fluidRow(
                box(h3("Differential analysis of the analysed features"), width = 12),
                box(includeMarkdown("./text/5_Differential_analysis.md"), status = "info", width = 12),
                box(p(strong("Run the automatic analysis")),
                    numericInput("ldiff", "log2FC threshold", value = 1), 
                    numericInput("pdiff", "Significance threshold", value = 0.05),
                    selectInput("ref2", "Please select the covariates to include in the model",
                                    choices = "Pending Upload", multiple = T),
                    actionButton("start_Diff", "Waiting for input data", icon=icon("exclamation-circle")),
                    width = 12)
        )),
        
        # Prediction analysis tab
        tabItem(tabName = "pred",
                fluidRow(
                box(h3("Machine learning analysis of the data"), width = 12),
                box(h5("In this section, the integrated machine learning analysis of the sample attributes can be run."), status = "info", width = 12)
        )),
        
        # Survival analysis tab
        tabItem(tabName = "surv",
                fluidRow(
                box(h3("Survival analysis"), width = 12),
                box(h5("In this section, the survival analysis can be run."), status = "info", width = 12)
        ))
      ))
)

source("server.R")

shinyApp(ui, server, options = list(height = 1080))

