correlation_page <- tabPanel(
    title = "Correlations",
    h1("Correlations"),
    p("Here you may select variables and examine their correlation. You may decide a certain variable is redundant, in which case you may opt to remove it from the dataset using the button below."),
    p("In the plot you find below the size of the circle indicates the strength of the correlation, while the shade of colour indicates whether the correlation is positive (more blue) or negative (more red)."),

    hr(),
    h3("Delete a variable"),
    uiOutput("select_del_var"),
    actionButton("del", "Delete variable"),
    span(textOutput("del_success"), style="color:green"),

    hr(),
    h3("Correlation matrix"),
    p("Please note that the plot will display an error message until you select some variables to compare."),
    uiOutput("select_cor_var"),
    plotOutput("correlationplot"),

    HTML("<br><br><br>"), # Add whitespace
)