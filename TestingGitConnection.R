# install.packages('shiny')
library(shiny)

baseUI <- fluidPage(titlePanel('My Shiny Demo App'),
                    sidebarLayout(sidebarPanel(
                      textInput('myNameInput', 'Please input your name here')
                    ),
                    mainPanel(
                      paste('You claim your name is '),
                      textOutput('myNameOutput')
                    )))


baseServer <- shinyServer(function(input, output) {
  output$myNameOutput  <- renderText({
    paste(input$myNameInput)
  })
})


shinyApp(ui = baseUI, server = baseServer)
