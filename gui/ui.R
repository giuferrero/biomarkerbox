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

ui <- dashboardPage(
  ## Header content
  dashboardHeader(title = "BiomarkeRbox",
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                 text = "5 new users today",
                                 icon("users")
                               )
                  ),
                  dropdownMenu(type = "tasks", badgeStatus = "success",
                               taskItem(value = 90, color = "green",
                                        "Documentation"
                               )
                  )),

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
      menuItem("PCA analysis", tabName = "attr", icon = icon("th")),
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
        # Input data ta
        tabItem(tabName = "input",
                fluidRow(
                  box(h3("Input data"),
                  h5("In this section you can insert the two main files required for the analysis."), status = "info", width = 12),
                  
                  box(p(strong("Please select a sample data file")),
                    shinyFilesButton("sdata", label="Sample data", title="Please select a sample data file", multiple = F), width = 12),
                
                  box(DT::dataTableOutput("sdatat"), width = 12),
                  
                  box(p(strong("Please select the file reporting the classes of the sample variables")),
                    shinyFilesButton("sdata_class", "Sample data type", "Please select a file reporting the types of the sample data variables", multiple = F), width = 12),
                  
                  box(selectInput("ref", "Please select the reference covariate", choices = "Pending Upload"), width = 12),
                  
                  box(p(strong("Please select the file reporting the count data file")),
                    shinyFilesButton("cdata", "Count data", "Please select a count data file", multiple = F), width = 12),
                  
                  box(DT::dataTableOutput("cdatat"), width = 12)
        )),
        
        # QC tab
        tabItem(tabName = "qc",
                box(h3("Datasets quality control and preprocessing"), width = 12),
                box(includeMarkdown("./text/1_QC.md"), status = "info", width = 12),
                box(actionButton("start_QC", "Run the analysis"))
        ),
        
        # Pre-proccesing analysis tabe
        tabItem(tabName = "pre",
                box(h3("Pre-processing analysis of the data"), width = 12),
                box(includeMarkdown("./text/2_Preprocessing.md"), status = "info", width = 12),
                box(actionButton("start_Pre", "Run the analysis"))
        ),        
      
        # Attribute analysis tab
        tabItem(tabName = "attr",
                box(h3("Analysis of the sample attributes"), width = 12),
                box(includeMarkdown("./text/3_Attribute_analysis.md"), status = "info", width = 12),
                box(actionButton("start_Attr", "Run the analysis"))
        ),

        # Correlation analysis tab
        tabItem(tabName = "PCA",
                box(h3("PCA analysis of the sample attributes"), width = 12),
                box(includeMarkdown("./text/7_PCA_analysis.md"), status = "info", width = 12),
                box(actionButton("start_PCA", "Run the analysis"))
        ),
        
        # Correlation analysis tab
        tabItem(tabName = "corr",
                box(h3("Analysis of the correlation between sample attributes"), width = 12),
                box(includeMarkdown("./text/4_Correlation_analysis.md"), status = "info", width = 12),
                box(actionButton("start_Corr", "Run the analysis"))
        ),

        # Differential analysis tab
        tabItem(tabName = "diff",
                box(h3("Differential analysis of the analysed features"), width = 12),
                box(includeMarkdown("./text/5_Differential_analysis.md"), status = "info", width = 12),
                box(actionButton("start_Diff", "Run the analysis"))
        ),
        
        # Prediction analysis tab
        tabItem(tabName = "pred",
                box(h3("Machine learning analysis of the data"), width = 12),
                box(h5("In this section, the integrated machine learning analysis of the sample attributes can be run."), status = "info", width = 12)
        ),
        
        # Survival analysis tab
        tabItem(tabName = "surv",
                box(h3("Survival analysis"), width = 12),
                box(h5("In this section, the survival analysis can be run."), status = "info", width = 12)
        )
        
      )))

source("server.R")

shinyApp(ui, server, options = list(height = 1080))

