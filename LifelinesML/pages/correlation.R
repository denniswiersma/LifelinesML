correlation_page <- tabPanel(
    title = "Correlations",
    h1("Correlations"),
    p("page explanation"),
    uiOutput("select_del_var"),
    actionButton("del", "Delete variable")
)