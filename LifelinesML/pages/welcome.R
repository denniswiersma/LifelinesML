NA_per_col <- sapply(dataset, function(x) sum(is.na(x)))

stat_list <- list("total_NA" = sum(NA_per_col), 
                  "cols" = ncol(dataset), 
                  "rows" = nrow(dataset),
                  "datapoints" = nrow(dataset) * ncol(dataset))

welcome_page <- tabPanel(
       title = "Home",
       h1("Welcome"),
       p("Welcome to this R shiny application. This application may be used to explore, analyse, and train on the Lifelines dataset."),
       hr(),
       h2("Dataset overview"),
       p(paste("Number of rows:", stat_list$rows)),
       p(paste("Number of columns:", stat_list$cols)),
       p(paste("Number of datapoints:", stat_list$datapoints)),
       p(paste("Number of NA values:", stat_list$total_NA))
)
