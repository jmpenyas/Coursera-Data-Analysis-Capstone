#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
source("./model.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        reactiveInput1 <- reactive({
                resultados <- nextWord(input$input)
                if (resultados[1] != "No result found")
                        resultados <- paste(resultados[1:3], " - ")
                resultados                        
        })
        
        output$output <- renderText(reactiveInput1())
})
