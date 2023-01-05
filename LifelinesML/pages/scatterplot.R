scatterplot_page <- tabPanel(
    title = "Scatterplot",
    h1("Scatterplot"),
    p("Here you may select variables to plot against each other to gain new insights."),
    selectInput(inputId = "scatter_x",
                label = "x variable",
                choices = colnames(dataset),
                multiple = FALSE),
    selectInput(inputId = "scatter_y",
                label = "y variable",
                choices = colnames(dataset),
                multiple = FALSE),
    selectInput(inputId = "scatter_col",
                label = "colour by",
                choices = colnames(dataset),
                multiple = FALSE),
    HTML("<br><br><br>"), # Add whitespace
    plotOutput("scatterplot")
)