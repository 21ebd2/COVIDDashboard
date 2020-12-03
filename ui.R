#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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

dashboardPage(
    dashboardHeader(title = "COVID Dashboard"),
    dashboardSidebar(
        dateRangeInput("daterange", "Select Date Range: ", format = "yyyy-mm-dd", min = "2020-03-12",
                       start = "2020-03-12", weekstart = 0),
        selectInput("state", "Select States:", choices = c("Choose a State"=""), multiple = TRUE)
    ),
    dashboardBody(
        fluidRow(
            valueBoxOutput("n1", width = 4),
            valueBoxOutput("n2", width = 4)
        )  
    )
)
