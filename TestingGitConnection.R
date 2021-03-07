options(shiny.maxRequestSize = 790 * 1024 ^ 2)

library(lattice)
library(shiny)

baseUI <- fluidPage(titlePanel(h2('My Shiny Demo App')),
                    sidebarLayout(
                      sidebarPanel(
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
                        fileInput(
                          'dataFileUploader',
                          'Choose a file to upload:',
                          accept = c('text/csv', 'csv')
                        ),
                        textInput(
                          inputId = 'plotTitle',
                          label = 'Choose a title for the plot:',
                          value = 'plot'
                        ),
                        h4('Choose plot type:'),
                        selectInput(
                          inputId = 'plotSelector',
                          label = 'Your plot choice:',
                          list('','Histogram', 'Scatterplot', 'Boxplot'),
                          # selected = 'Histogram',
                          multiple = F
                        ),
                        h4('Choose corresponding variables'),
                        uiOutput('x'),
                        uiOutput('y'),
                        h4('size of plot:'),
                        numericInput(
                          inputId = 'plotHeight',
                          label = 'Height',
                          value = 400,
                          min = 400,
                          max = 2000
                        ),
                        numericInput(
                          inputId = 'plotWidth',
                          label = 'Width',
                          value = 400,
                          min = 400,
                          max = 2000
                        )
                        
                      ),
                      mainPanel(
                        width = 8,
                        strong(h4(textOutput('plotTitleOutput'))),
                        plotOutput(
                          outputId = 'plotHolder',
                          height = 300,
                          width = 'auto'
                        )
                      )
                    ))


baseServer <- shinyServer(function(input, output) {
  output$plotTitleOutput  <- renderText({
    paste(input$plotTitle)
  })
  plotData <- reactive({
    if (is.null(input$dataFileUploader)) {
      return(NULL)
    }
    read.csv(input$dataFileUploader$datapath,
             header = T,
             sep = ',')
  })
  output$x <- renderUI({
    if (is.null(plotData)) {
      return()
    }
    tagList(
      selectInput(
        inputId = 'x',
        label = 'Choose a variable for the x-axis',
        choices = names(plotData()),
        multiple = F
      )
    )
  })
  output$y <- renderUI({
    if (is.null(plotData) || input$plotSelector == 'Histogram')
      return()
    tagList(
      selectInput(
        inputId = 'y',
        label = 'Choose a variable fro the y-axis',
        choices = names(plotData()),
        multiple = F
      )
    )
  })
  output$plotHolder <- renderPlot({
    if(is.null(plotData)){
      return()
    }

    ### Histogram ###
    # if(input$plotSelector == 'Histogram'){
    #   histogram( ~ plotData()[, which(names(plotData())==input$x)],
    #             data = plotData(), xlab = input$x) 
    # }

    #handling three types: 'Histogram', 'Scatterplot', 'Boxplot'
    if (input$plotSelector == "Histogram") {
      histogram( ~ plotData()[,which(names(plotData())==input$x)], data=plotData(), xlab=input$x)
    }
    
    else if (input$plotSelector == "Scatterplot") {
      xyplot(plotData()[,which(names(plotData())==input$y)]~
             plotData()[,which(names(plotData())==input$x)], data=plotData(),
             xlab=input$x, ylab=input$y)
    }

    else if (input$plotSelector == "Boxplot") {
      bwplot(plotData()[,which(names(plotData())==input$y)]~
             plotData()[,which(names(plotData())==input$x)], data=plotData(),
             xlab=input$x,ylab=input$y)
    }

    
  }, height = function(x) input$plotHeight, width = function(y) input$plotWidth)
})


shinyApp(ui = baseUI, server = baseServer)
