transformation_page <- tabPanel(
    title = "Transformation",
    h1("Data Transformation"),
    p("Skewness of a given set of data can introduce a lot of problems when trying to work on a dataset. This issue can be resolved by transforming the data. Below you will find a selection of options for transforming this dataset."),
    
    hr(),
    h3("Transform variable"),
    uiOutput("select_trans_var"),
    selectInput(inputId = "trans_method",
                label = "Transformation method",
                choices = c("log10", "log2", "ln", "square root", "cube root"),
                multiple = FALSE),
    actionButton("trans_submit", "Transform"),
    span(textOutput("trans_success"), style="color:green"),

    hr(),
    h3("Histogram"),
    plotOutput("histogram"),

    hr(),
    h3("QQ plot"),
    plotOutput("qqplot")


)