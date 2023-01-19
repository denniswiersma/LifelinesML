welcome_page <- tabPanel(
       title = "Home",
       h1("Welcome"),
       p("Welcome to this R shiny application. This application may be used to explore, analyse, and train on the Lifelines dataset."),
       hr(),
       h2("Dataset overview"),
       p("Number of rows:"), textOutput("rows"),
       p("Number of columns:"), textOutput("cols"),
       p("Number of datapoints:"), textOutput("datapoints"),
       p("Number of NA values:"), textOutput("total_NA")
)
