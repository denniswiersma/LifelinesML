# number of NA per variable

missing_data_page <- tabPanel(
    title = "Missing Data",
    h1("Missing data"),
    p("Missing values in a dataset (otherwise known as NA values) may lead to countless problems down the road. It is best to deal with them ASAP!"),

    hr(),
    h3("Dealing with missing data"),
    uiOutput("select_md_var"),
    selectInput(inputId = "md_method",
                label = "Method",
                choices = c("Impute by mean", "Impute by median", "Delete NA rows"),
                multiple = FALSE),
    actionButton("md_submit", "Submit"),
    HTML("<br><br><br>"), # Add whitespace

    hr(),
    h3("Viewing missing data"),
    HTML("<br><br><br>"), # Add whitespace
    dataTableOutput("NA_table"),
)