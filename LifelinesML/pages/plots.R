plots_page <- tabPanel(
    title = "Plots",
    h1("Plot"),
    p("Here you may select variables to plot against each other to gain new insights."),
    selectInput(inputId = "plots_x",
                label = "x variable",
                choices = colnames(dataset),
                multiple = FALSE),
    selectInput(inputId = "plots_y",
                label = "y variable",
                choices = colnames(dataset),
                multiple = FALSE),
    selectInput(inputId = "plots_col",
                label = "colour by",
                choices = colnames(dataset),
                multiple = FALSE),
    #HTML("<br><br><br>"), # Add whitespace
    # scatterplot
    hr(),
    h3("Scatterplot"),
    p("Scatterplots are great for exploring possible correlations!"),
    plotOutput("scatterplot"),
    
    # boxplot
    hr(),
    h3("Boxplot"),
    p("Boxplots are great for exploring means, quartile distances, and outliers!"),
    p("Please note that choosing a categorical variable like \"GENDER\" would be best for creating a good looking boxplot."),
    plotOutput("boxplot"),
    
    # barplot
    hr(),
    h3("Barplot"),
    p("Bar plots are great for exploring distributions, and checking frequencies!"),
    plotOutput("barplot")
    
)