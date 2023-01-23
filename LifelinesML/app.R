# Run app using command below:
# R -e "shiny::runApp('test')"

### GLOBAL ###
library(shiny)
library(shinythemes)
library(ggplot2)
library(corrplot)

# Load dataset
dataset <- read.csv(file = "Participants_Aggregated_Age.csv",
                    header = TRUE, sep = ",", dec = ",")
dataset$GENDER <- as.factor(dataset$GENDER)
dataset$GROUP_SIZE_CAT <- as.factor(dataset$GROUP_SIZE_CAT)

rv <- reactiveValues(dataset = dataset)

# Import all files from pages folder
files.sources = paste0("pages/", list.files("pages/"))
sapply(files.sources, source)


### UI ###
ui <- fluidPage(
    style = "padding: 0px;", # no gap in navbar
    actionButton(inputId = "reset", label = "Reset data",
                 style = "position: absolute; top: 2px; right: 5px; z-index:10000;"),
    
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
            normal_standard_page,
            transformation_page,
            correlation_page,
            imbalance_page
        )
    )
)

### SERVER ###
server <- function(input, output) {
    gen_statlist_item <- function() {
        # Calculate NA values
        stat_list <- list("total_NA" = sum(sapply(rv$dataset, function(x) sum(is.na(x)))),
                          "cols" = ncol(rv$dataset), 
                          "rows" = nrow(rv$dataset),
                          "datapoints" = nrow(rv$dataset) * ncol(rv$dataset))
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
            choices = colnames(rv$dataset),
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
        renderDataTable(rv$dataset[input$dataset_table_selection])

    # Missing data table
    output$NA_table <- renderDataTable(data.frame(variable = colnames(rv$dataset), NA_Values = sapply(rv$dataset, function(x) sum(is.na(x)))))
    
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
            colnames(rv$dataset[input$plots_y]),
            "as a function of",
            colnames(rv$dataset[input$plots_x])
        )))
    
    output$boxplot <- renderPlot(
        ggplot(rv$dataset, aes_string(
            x = input$plots_x,
            group = input$plots_x,
            y = input$plots_y,
            fill = input$plots_x
        )) +
            geom_boxplot()
    )
    
    output$barplot <- renderPlot(
        ggplot(rv$dataset, aes_string(
            x = input$plots_x,
            fill = input$plots_cols
        )) +
            geom_bar()
    )

    output$correlationplot <- renderPlot(
      corrplot(cor(sapply(rv$dataset[input$cor_var], as.integer)),
               type = "lower",
               tl.col = "black",
               tl.cex = 0.85,
               tl.offset = 1,
               title = "Correlation matrix",
               outline = TRUE,
               mar = c(0, 0, 1, 0),
               cl.cex = 0.75))
    ### OBSERVE EVENTS ###

    # Missing data button
    observeEvent(input$md_submit, {
        # Calculate median totChol
        med <- median(unlist(na.omit(rv$dataset[input$md_var])))
        print(med)
        # Change missing totChol values to median
        rv$dataset[which(is.na(rv$dataset[input$md_var])), input$md_var] <- med
    })

    # Delete row button
    observeEvent(input$del, {
        rv$dataset <- subset(rv$dataset, select = -which(colnames(rv$dataset) == input$del_var))
    })

    # Reset dataset button
    observeEvent(input$reset, {
        rv$dataset <- dataset
    })
    
}

# Run the application
shinyApp(ui = ui, server = server)
