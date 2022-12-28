# Run app using command below:
# R -e "shiny::runApp('test')"

### LIBRARIES ###
library(shiny)

### IMPORTS ###
source("pages/welcome.R")

ui <- fluidPage(
  navbarPage(
    title = "LifelinesML",
    welcome_page
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
