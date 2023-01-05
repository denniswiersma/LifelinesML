# Run app using command below:
# R -e "shiny::runApp('test')"

### LIBRARIES ###
library(shiny)
library(ggplot2)

### IMPORTS ###
# Import all files from pages folder
files.sources = paste0("pages/", list.files("pages/"))
sapply(files.sources, source)

ui <- fluidPage(# Navigation bar
    navbarPage(
        title = "LifelinesML",
        welcome_page,
        # Insight sub menu
        navbarMenu(
            title = "Insight",
            variable_definitions_page,
            dataset_page,
            scatterplot_page
        )
    ))

# Define server logic required to draw a histogram
server <- function(input, output) {
    # Variable definition page
    output$variable_definition_table <-
        renderDataTable(variable_definitions)
    
    # Dataset table page
    output$dataset_table <-
        renderDataTable(dataset[input$dataset_table_selection])
    
    # Scatterplot page
    output$scatterplot <- renderPlot(ggplot(
        dataset,
        aes_string(
            x = input$scatter_x,
            y = input$scatter_y,
            color = input$scatter_col
        )
    ) +
        geom_point() +
        labs(title = paste(
            colnames(dataset[input$scatter_y]),
            "as a function of",
            colnames(dataset[input$scatter_x])
        )))
}

# Run the application
shinyApp(ui = ui, server = server)
