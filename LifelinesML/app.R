# Run app using command below:
# R -e "shiny::runApp('test')"

### LIBRARIES ###
library(shiny)

### IMPORTS ###
# Import all files from pages folder
files.sources = paste0("pages/", list.files("pages/"))
sapply(files.sources, source)

ui <- fluidPage(
  navbarPage(
    title = "LifelinesML",
    welcome_page,
    navbarMenu(
        title = "Insight",
        variable_definitions_page
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$variable_definition_table <- renderDataTable(variable_definitions)
}

# Run the application 
shinyApp(ui = ui, server = server)
