# Run app using command below:
# R -e "shiny::runApp('test')"

### GLOBAL ###
library(shiny)
library(shinythemes)
library(shinyjs)
library(ggplot2)
library(corrplot)



# Import all files from pages folder
files.sources = paste0("pages/", list.files("pages/"))
sapply(files.sources, source)


### UI ###
ui <- fluidPage(
    style = "padding: 0px;", # no gap in navbar
    actionButton(inputId = "reset", label = "Reset data",
                 style = "position: absolute; top: 2px; right: 5px; z-index:10000;"),
    useShinyjs(),
    
    navbarPage(
        title = "LifelinesML",
        theme = shinytheme("simplex"),
        welcome_page,
        # Insight sub menu
        navbarMenu(
            title = "Insight",
            variable_definitions_page,
            dataset_page,
            plots_page
        ),
        navbarMenu(
            title = "EDA",
            missing_data_page,
            normalisation_page,
            transformation_page,
            correlation_page
        )
    )
)

### SERVER ###
server <- function(input, output, session) {

    # Load dataset
    dataset <- read.csv(file = "Participants_Aggregated_Age.csv",
                        header = TRUE, sep = ",", dec = ",")
    dataset$GENDER <- as.factor(dataset$GENDER)
    dataset$GROUP_SIZE_CAT <- as.factor(dataset$GROUP_SIZE_CAT)

    session$userData$rv <- reactiveValues(dataset = dataset)

    gen_statlist_item <- function() {
        # Calculate NA values
        stat_list <- list("total_NA" = sum(sapply(session$userData$rv$dataset, function(x) sum(is.na(x)))),
                          "cols" = ncol(session$userData$rv$dataset),
                          "rows" = nrow(session$userData$rv$dataset),
                          "datapoints" = nrow(session$userData$rv$dataset) * ncol(session$userData$rv$dataset))
        stat_list
    }
    
    output$total_NA <- renderText(gen_statlist_item()$total_NA)
    output$cols <- renderText(gen_statlist_item()$cols)
    output$rows <- renderText(gen_statlist_item()$rows)
    output$datapoints <- renderText(gen_statlist_item()$datapoints)
    
    ### GENERATE INPUTS ###
    gen_selectInput_rv_colnames <- function(inputID, label, multiple) {
        selectInput(
            inputId = inputID,
            label = label,
            choices = colnames(session$userData$rv$dataset),
            multiple = multiple
        )
    }
    
    # Generate input selection for datatable
    output$datatable_input <- renderUI(
        gen_selectInput_rv_colnames("dataset_table_selection", "Variable:", TRUE)
    )
    
    # Generate input selection for plots
    output$select_plot_x <- renderUI(
        gen_selectInput_rv_colnames("plots_x", "x variable", FALSE)
    )
    output$select_plot_y <- renderUI(
        gen_selectInput_rv_colnames("plots_y", "y variable", FALSE)
    )
    output$select_plot_col <- renderUI(
        gen_selectInput_rv_colnames("plots_col", "colour by", FALSE)
    )
    
    # Generate input selection for missing data
    output$select_md_var <- renderUI(
        gen_selectInput_rv_colnames("md_var", "Variable", FALSE)
    )

    # Generate input selection for normalisation variable
    output$select_std_var <- renderUI(
        gen_selectInput_rv_colnames("std_var", "Variable", FALSE)
    )

    # Generate input selection for transformation variable
    output$select_trans_var <- renderUI(
        gen_selectInput_rv_colnames("trans_var", "Variable", FALSE)
    )

    # Generate input selection for correlation variables
    output$select_cor_var <- renderUI(
      gen_selectInput_rv_colnames("cor_var", "Corralation variables", TRUE)
    )

    # Generate input selection for column deletion
    output$select_del_var <- renderUI(
        gen_selectInput_rv_colnames("del_var", "Variable to delete", FALSE)
    )
    
    ### GENERATE TABLES ###
    
    # Variable definition table
    output$variable_definition_table <-
        renderDataTable(variable_definitions)
    
    # Dataset table
    output$dataset_table <-
        renderDataTable(session$userData$rv$dataset[input$dataset_table_selection])

    # Missing data table
    output$NA_table <- renderDataTable(data.frame(variable = colnames(session$userData$rv$dataset), NA_Values = sapply(session$userData$rv$dataset, function(x) sum(is.na(x)))))
    
    ### GENERATE PLOTS ###
    
    # Scatterplot page
    output$scatterplot <- renderPlot(ggplot(
        dataset,
        aes_string(
            x = input$plots_x,
            y = input$plots_y,
            color = input$plots_col
        )
    ) +
        geom_point() +
        labs(title = paste(
            colnames(session$userData$rv$dataset[input$plots_y]),
            "as a function of",
            colnames(session$userData$rv$dataset[input$plots_x])
        )))
    
    output$boxplot <- renderPlot(
        ggplot(session$userData$rv$dataset, aes_string(
            x = input$plots_x,
            group = input$plots_x,
            y = input$plots_y,
            fill = input$plots_x
        )) +
            geom_boxplot()
    )
    
    output$barplot <- renderPlot(
        ggplot(session$userData$rv$dataset, aes_string(
            x = input$plots_x,
            fill = input$plots_cols
        )) +
            geom_bar()
    )

    output$histogram <- renderPlot(
      ggplot(session$userData$rv$dataset, aes_string(
        x = input$trans_var
      )) + geom_bar(fill = "#D9230D")
    )

    output$qqplot <- renderPlot(
      ggplot(session$userData$rv$dataset, aes_string(
        sample = input$trans_var
      )) + stat_qq() + stat_qq_line(col = "red")
    )

    output$correlationplot <- renderPlot(
      corrplot(cor(sapply(session$userData$rv$dataset[input$cor_var], as.integer)),
               title = "Correlation matrix",
               type = "lower",
               tl.col = "black",
               tl.cex = 0.85,
               tl.offset = 1,
               outline = TRUE,
               cl.cex = 0.75))
    ### OBSERVE EVENTS ###

    # Missing data button
    observeEvent(input$md_submit, {
        new_values <- switch(
          input$md_method,
          "Impute by mean" = session$userData$rv$dataset[which(is.na(session$userData$rv$dataset[input$md_var])), input$md_var] <- mean(unlist(na.omit(session$userData$rv$dataset[input$md_var]))),
          "Impute by median" = session$userData$rv$dataset[which(is.na(session$userData$rv$dataset[input$md_var])), input$md_var] <- median(unlist(na.omit(session$userData$rv$dataset[input$md_var]))),
          "Delete NA rows" = session$userData$rv$dataset <- session$userData$rv$dataset[complete.cases(session$userData$rv$dataset[input$md_var]),]
        )
        new_values

        # Display confirmation message
        output$md_success <- renderText("Successfully altered missing data!")
        # Remove confirmation message after 1.1 seconds
        delay(ms = 1100, output$md_success <- renderText(""))
    })

    # Standardisation button
    observeEvent(input$std_submit, {
        min_max <- function(x) {
            (x - min(x)) / (max(x) - min(x))
        }

        new_values <- switch(
          input$std_method,
          "Standard score" = session$userData$rv$dataset[input$std_var] <- scale(session$userData$rv$dataset[input$std_var]),
          "Min-Max" = session$userData$rv$dataset[input$std_var] <- min_max(session$userData$rv$dataset[input$std_var]),
        )
        new_values

        # Display confirmation message
        output$std_success <- renderText("Successfully normalised data!")
        # Remove confirmation message after 1.1 seconds
        delay(ms = 1100, output$std_success <- renderText(""))
    })

    # Transformation button
    observeEvent(input$trans_submit, {
        new_values <- switch(
          input$trans_method,
          "log10" = session$userData$rv$dataset[input$trans_var] <- log10(session$userData$rv$dataset[input$trans_var]),
          "log2" = session$userData$rv$dataset[input$trans_var] <- log2(session$userData$rv$dataset[input$trans_var]),
          "ln" = session$userData$rv$dataset[input$trans_var] <- log(session$userData$rv$dataset[input$trans_var]),
          "square root"= session$userData$rv$dataset[input$trans_var] <- sqrt(session$userData$rv$dataset[input$trans_var]),
          "cube root" = session$userData$rv$dataset[input$trans_var] <- session$userData$rv$dataset[input$trans_var]^(1/3)
        )
        new_values

        # Display confirmation message
        output$trans_success <- renderText("Successfully transformed data!")
        # Remove confirmation message after 1.1 seconds
        delay(ms = 1100, output$trans_success <- renderText(""))
    })

    # Delete row button
    observeEvent(input$del, {
        session$userData$rv$dataset <- subset(session$userData$rv$dataset, select = -which(colnames(session$userData$rv$dataset) == input$del_var))
        # Display confirmation message
        output$del_success <- renderText("Successfully deleted data!")
        # Remove confirmation message after 1.1 seconds
        delay(ms = 1100, output$del_success <- renderText(""))
    })

    # Reset dataset button
    observeEvent(input$reset, {
        session$userData$rv$dataset <- dataset
    })
    
}

# Run the application
shinyApp(ui = ui, server = server)
