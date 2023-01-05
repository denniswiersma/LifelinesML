# Run app using command below:
# R -e "shiny::runApp('test')"

### LIBRARIES ###
library(shiny)

### IMPORTS ###
# Import all files from pages folder
files.sources = paste0("pages/", list.files("pages/"))
sapply(files.sources, source)

ui <- fluidPage(
  # Navigation bar
  navbarPage(
    title = "LifelinesML",
    welcome_page,
    # Insight sub menu
    navbarMenu(
        title = "Insight",
        variable_definitions_page,
        dataset_page
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    # Variable definition page
    output$variable_definition_table <- renderDataTable(variable_definitions)
    
    # Dataset table page
    output$dataset_table <- renderDataTable(dataset[input$dataset_table_selection])
}

# Run the application 
shinyApp(ui = ui, server = server)
