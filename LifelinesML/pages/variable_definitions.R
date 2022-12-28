variable_definitions <- read.csv("variable_definitions.csv")

variable_definition_table <- renderDataTable(variable_definitions)

variable_definitions_page <- tabPanel(
    title = "Variable Definitions",
    h1("Variable Definitions"),
    p("Here you may find definitions for all variables in the dataset. For more information, please visit the",
        style = "display:inline"),
    a("Lifelines wiki.", href = "http://wiki.lifelines.nl/doku.php", target = "_blank"),
    dataTableOutput("variable_definition_table")
    
)
