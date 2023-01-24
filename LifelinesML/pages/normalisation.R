normalisation_page <- tabPanel(
    title = "Normalisation",
    h1("Normalisation"),
    p("The data that you're working with may be in completely different ballparks when it comes to ranges. For example, an age variable will usually range between 0 and 100, while something like caloric intake in kcal may range in the thousands. To remedy this difference in range, one may opt to normalise the dataset."),
    p("Standard score normalisation: Converts the given values to a normal distribution with a mean of 0 and a standard deviation of 1."),
    p("Min-Max normalisation: Converts the given values to a range between 0 and 1."),

    uiOutput("select_std_var"),
    selectInput(inputId = "std_method",
                label = "Standardisation method",
                choices = c("Standard score", "Min-Max"),
                multiple = FALSE),
    actionButton("std_submit", "Submit"),
    HTML("<br><br><br>"), # Add whitespace
)