welcome_page <- tabPanel(
       title = "Home",
       h1("Welcome"),
       p("Welcome to this R shiny application. This application may be used to explore and analyse the Lifelines dataset."),
       p("This shiny application is completely open source and licenced under AGPL. You can find all code related to this project on it's",
        style = "display:inline"),
       a("Github page.", href = "https://github.com/denniswiersma/LifelinesML", target = "_blank"),

       hr(),
       h2("Dataset overview"),
       p("Number of rows:"), textOutput("rows"),
       p("Number of columns:"), textOutput("cols"),
       p("Number of datapoints:"), textOutput("datapoints"),
       p("Number of NA values:"), textOutput("total_NA")
)
