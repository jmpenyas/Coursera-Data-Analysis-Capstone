#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinydashboard)
# Define UI for application that forecasts the airpassengers.
# It uses dashboard elements from shinydashboard package not the default fluidpages from shiny
shinyUI(dashboardPage(
        dashboardHeader(title = "Predict Next Word"),
        dashboardSidebar(
                # Dashboard Items from the sidebar
                menuItem(
                        "Predict the next Word",
                        tabName = "dashboard",
                        icon = icon("cog", lib = "glyphicon")
                ),
               menuItem(
                        "How to use it?",
                        tabName = "education",
                        icon = icon("education", lib = "glyphicon")
                )
        ),
        dashboardBody(tabItems(
                # Tabs related to the menu items of the sidebar
                tabItem(tabName = "dashboard", textInput("input", "Write your text", value = ""),h3(textOutput("output"))),
                # Small guide with links to presentation and source code
                tabItem(
                        tabName = "education",
                        h2("How to use this application"),
                        br(),
                        h4(
                                "This application predicts the next word you type."
                        ),
                        p(
                                "Click on Predict the next word Menu and write the text you want."
                        ),
                                 
                        tags$a(href = "http://rpubs.com/jmpenyas/415567", "You can find the source here"),
                        br(),
                        tags$a(href = "https://github.com/jmpenyas/Developing-Data-Products-Project", "Here you can find the presentation of the application."),
                        class = "active"
                )
        ))
))