correlation_page <- tabPanel(
    title = "Correlations",
    h1("Correlations"),
    p("Here you may select variables and examine their correlation. You may decide a certain variable is redundant, in which case you may opt to remove it from the dataset using the button below."),
    p("Please note that the plot will display an error message until you select some variables to compare."),
    uiOutput("select_cor_var"),
    plotOutput("correlationplot"),
    uiOutput("select_del_var"),
    actionButton("del", "Delete variable")
)