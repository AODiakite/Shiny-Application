#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# library(casabourse)
# 
# #atw data
# atw <- daily.data('atw',from = '01-01-2017', to = '21-02-2022')
# atw$Date <- lubridate::dmy(rownames(atw))
# atw <- atw[-1,] %>%  dplyr::relocate(Date, .before = Value)
# #bcp data
# bcp <- daily.data('bcp',from = '01-01-2017', to = '21-02-2022')
# bcp$Date <- lubridate::dmy(rownames(bcp))
# bcp <- bcp[-1,] %>%  dplyr::relocate(Date, .before = Value)

ui <- fluidPage(
  titlePanel(
    {h1("Shiny Application")
      }
  ),
  titlePanel(
    {h4("by Abdoul Oudouss Diakité")
    }
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput('ticker','Entreprise',choices = c('atw','bcp')),
      selectInput('x','X',choices = names(atw)),
      selectInput('y','Y',choices = names(bcp),selected = names(bcp)[2]),
      actionButton('action','Plot')
      ),
    
    mainPanel(
      tabsetPanel(
        tabPanel('Plot',plotlyOutput('plot') ),
        tabPanel('Data',dataTableOutput('Data'))
      ),
      titlePanel(h2('Summary')),
      verbatimTextOutput('summary')
      # ,
      # plotlyOutput('plot'),
      # dataTableOutput('Data')
      )
    )
  )
server <- function(input, output, session) {
  output$Data <- renderDataTable( get(input$ticker))
  X <- eventReactive(input$action,{
    input$x
  })
  Y <- eventReactive(input$action,{
    input$y
    })
  output$plot <-  renderPlotly(
    {
      tick <- get(input$ticker)
    plot_ly(x=tick[,X()],y=tick[,Y()],type = 'scatter', mode = 'lines+markers') %>% 
      layout(title = paste0())

     # plot(tick[,X()],tick[,Y()])
    }
    )
  output$summary <- renderPrint(summary(get(input$ticker)))

}

shinyApp(ui, server)
