#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

tryObserve <- function(x) {
  x <- substitute(x)
  env <- parent.frame()
  observe({
    tryCatch(
      eval(x, env),
      error = function(e) {
        showNotification(paste("Error: ", e$message), type = "error")
      }
    )
  })
}

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
    sidebarMenu(
      menuItem("Input", tabName = "input", icon = icon("table")),
      menuItem("QC", tabName = "qc", icon = icon("tasks")),
      menuItem("Attribute analysis", tabName = "attr", icon = icon("th")),
      menuItem("Correlation analysis", tabName = "corr", icon = icon("th")),
      menuItem("Differential analysis", tabName = "diff", icon = icon("th")),
      menuItem("Prediction analysis", tabName = "pred", icon = icon("th")),
      menuItem("Feature selection analysis", tabName = "fs", icon = icon("th")),
      menuItem("Survival analysis", tabName = "surv", icon = icon("th")),
      menuItem("prova analysis", tabName = "surv", icon = icon("th")) 
    )
  ),

## Body content
  dashboardBody(
      tabItems(
        # Input data ta
        tabItem(tabName = "input",
                fluidRow(
                  box(h3("Input data"),
                  h5("In this section you can insert the two main files required for the analysis."), status = "info", width = 12),
                  
                  box(fileInput("sdata", "Sample data")),
                
                  box(fileInput("cdata", "Count data")),
                  
                  box(tableOutput("sdatat")),
                  
                  box(plotOutput("plot1")),
                  
                  box(
                    title = "Controls",
                    sliderInput("slider", "Number of observations:", 1, 100, 50)
                    ))
        ),
        
        # QC tab
        tabItem(tabName = "qc",
                h1("Datasets quality control and preprocessing")
        ),
      
        # Attribute analysis tab
        tabItem(tabName = "attr",
                h1("Datasets quality control and preprocessing")
        ),

        # Correlation analysis tab
        tabItem(tabName = "corr",
                h1("Datasets quality control and preprocessing")
        ),

        # Differential analysis tab
        tabItem(tabName = "diff",
                h1("Datasets quality control and preprocessing")
        ),
        
        # Prediction analysis tab
        tabItem(tabName = "pred",
                h1("Datasets quality control and preprocessing")
        ),
        
        # Feature selection analysis tab
        tabItem(tabName = "fs",
                h1("Datasets quality control and preprocessing")
        ),
        
        # Survival analysis tab
        tabItem(tabName = "surv",
                h1("Datasets quality control and preprocessing")
        )
        
      )))

###### Server
server <- function(input, output) {

  #### Input operations
  output$sdatat <- renderDataTable({sdata <- input$sdata
                                     if (is.null(sdata)){return(NULL)}
                                     read.delim(sdata$datapath)})
  #### QC operations
  
  output$plot1 <- renderPlot({
    histdata <- rnorm(500)
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  #### ML operations
  
}

shinyApp(ui, server)
