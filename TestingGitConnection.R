# install.packages('shiny')
library(shiny)

baseUI <- fluidPage(titlePanel(h2('My Shiny Demo App')),
                    sidebarLayout(sidebarPanel(
                      ## common control demo:
                      # textInput('myNameInput', 'Please input your name here'),
                      # actionButton('actbtn1','Show the plot'),
                      # submitButton('submitBtn1',"Finish Settings"),
                      # checkboxInput('isShowTableCbx', 'Show background data'),
                      # dateInput('startDateDi', 'Start Date'),
                      # dateRangeInput('checkDateRangeDri', 'Application Date Range:'),
                      # fileInput('file1','Select a data file for plotting'),
                      # radioButtons('rdb1',"Country", c('Australia'='Au', 'Bangkok'='Bk','Cananda'='Ca'), 'Au', FALSE,60)
                      width = 4, 
                      h4('Dateset and title'), 
                      fileInput('dataFileUploader', 'Choose a file to upload:', accept = c('text/csv','csv')),
                      textInput(inputId = 'plotTitle', label = 'Choose a title for the plot:', value = 'plot'),
                      h4('Choose plot type:'),
                      selectInput(inputId = 'plotSelector', label = 'Your plot choice:', 
                                  list('Histogram','Scatterplot', 'Boxplot'), selected = 'Histogram', multiple = F),
                      h4('Choose corresponding variables'),
                      uiOutput('x'),
                      uiOutput('y'),
                      h4('size of plot:'),
                      numericInput(inputId = 'plotHeight', label = 'Height', value = 700, min = 500, max = 2000),
                      numericInput(inputId = 'plotWidth', label = 'Width', value = 900, min = 500, max = 2000)
                      
                    ),
                    mainPanel(
                      width = 8,
                      strong(h4(textOutput('plotTitleOutput'))),
                      plotOutput(outputId = 'plotHolder', height = 'auto', width = 'auto')
                    )))


baseServer <- shinyServer(function(input, output) {
  output$plotTitleOutput  <- renderText({
    paste(input$plotTitle)
  })
})


shinyApp(ui = baseUI, server = baseServer)
