# Load dataset
dataset <- read.csv(file = "Participants_Aggregated_Age.csv")

dataset_page <- tabPanel(
    title = "Dataset table",
    h1("Dataset table"),
    p("Here you may explore the dataset. Select variables to view using the field below."),
    p("The table will (should) update as you alter the data using this application."),
    selectInput(inputId = "dataset_table_selection",
                label = "Variable:",
                choices = colnames(dataset),
                multiple = TRUE),
    HTML("<br><br><br>"), # Add whitespace
    dataTableOutput("dataset_table")
)