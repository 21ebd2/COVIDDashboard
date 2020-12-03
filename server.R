#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(readr)
library(tidyverse)


mypath <- "https://covidtracking.com/data/download/all-states-history.csv"
data <- read_csv(mypath)
statelabels <- data$state


shinyServer(function(input, output, session) {
    
    coviddata <- reactiveFileReader(
        intervalMillis = 2000000, 
        session = session,
        filePath = mypath,
        readFunc = read_csv)
    
    updateSelectInput(session, "state", choices = c("Choose a State"="", statelabels))
    
    observeEvent(input$daterange,{
        currentmax <- max(coviddata()$date)
        updateDateRangeInput(session, "daterange", max = currentmax, end = currentmax)
    },
    once=TRUE)
    
    outputdata <- reactive({
        data <- coviddata() %>% filter(date > input$daterange[1]) %>% 
            filter(date <= input$daterange[2]) %>% 
            filter(state %in% input$state)
        
        return(data)
    })
    
    output$n1 <- renderValueBox({
        casecounts <- outputdata() %>% 
            summarize(sum = sum(positiveIncrease))
        
        valueBox(
            value =  casecounts,
            subtitle = "Number of New Infections over Selected Range",
            icon = icon("table")
        )
    })
    
    output$n2 <- renderValueBox({
        
        hopsitalcounts <- outputdata()  %>% 
            summarize(sum = sum(hospitalizedIncrease))
        
        valueBox(
            value =  hopsitalcounts,
            subtitle = "Number Hosptilized over Selected Range",
            icon = icon("table")
        )
    })
})




