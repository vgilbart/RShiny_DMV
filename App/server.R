#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

shinyServer(function(session, input, output) {

    output$value <- renderPrint({ input$gene_origin_bank })


    #-- INPUT TAB
    
    # Retrieve dataframe from file
    dfGeneFile = reactive({
        # Get name of exemple or loaded file
        if(input$load_exemple == TRUE) {
            file = paste(dirname(getwd()), "exemple/exemple.csv", sep ="/")
        } else { 
            shiny::validate( need(input$gene_file, "Please upload a csv or tsv file") )
            file = input$gene_file$datapath
        }
        print(file)

        # Check if file is csv of tsv
        file_extension = strsplit(file, split="\\.")[[1]][-1]
        shiny::validate(need(file_extension == "csv" || file_extension == "tsv" , "Please upload a .csv or .tsv file only") )
        if (file_extension == "csv"){
            separator = ','
        } else if (file_extension == "tsv"){
            separator = '\t'
        } 
        df = read.table(file, header = T, sep = separator)
    
        # Check if file has the expected columns
        shiny::validate(
            # max 6 columns 
            need(ncol(df) <= 6, "Please, check the needed format with the exemple file. \nYour data has too many columns."),
            # baseMean column is optional
            need(all(c("GeneName", "ID", "log2FC", "pval", "padj") %in% colnames(df)), 
                 "Please, check the needed format with the exemple file. \nYou do not have the expected data columns.")
        )
        
        return(df)
    })

    
    output$gene_table <- renderDataTable(
        dfGeneFile(), 
        options = list(pageLength = 10, # Number of rows of datatable 
                      lengthMenu = c(5, 10, 25, 50) # Choice of number of rows
                      )
    )
    

    
    
    #-- WHOLE DATA INSPECTION TAB
    
    # Side bar p-value
    observeEvent(input$pvalue_method_choice, {
    if (input$pvalue_method_choice == 2){
    updateSliderInput(session, "pvalue", "Padj",
                min = 0, max = 1,
                value = 0.5)
    }
    else if (input$pvalue_method_choice == 1){
            updateSliderInput(session, "pvalue",  "Pvalue",
                              min = 0, max = 1,
                              value = 0.5)
        }
        
    })
    
    plotVolcano <- reactive({
        df=dfGeneFile()
        df$diffexpressed <- "NO regulated"
        df$diffexpressed[df$log2FC > input$Fold_change[2] & df$pval < input$p_value] <- "UP regulated"
        df$diffexpressed[df$log2FC < input$Fold_change[2] & df$pval < input$p_value] <- "DOWN regulated"
        mycolors <- c("blue", "gray", "red")
        
        p = ggplot(data=df, aes(x=log2FC, y=-log10(pval), col=diffexpressed)) + 
            geom_point() + 
            theme_minimal() + 
            ggtitle("Volcano Plot") + 
            geom_vline(xintercept=c(input$Fold_change[1], input$Fold_change[2]), col="red") +
            geom_hline(yintercept=-log10(input$p_value), col="red") +
            theme(plot.title = element_text(color="black", size=20, face="bold.italic", hjust = 0.5)) +
            scale_colour_manual(values = mycolors)
        print(input$pvalue)
        print()
        return(p)
    })  
    
    #variable
    output$plot_Volcano <- renderPlot(
        plotVolcano()
    )


    #-- GO TERMS ENRICHMENT TAB
    
    
    #-- PATHWAY ENRICHMENT TAB
    
    
    #-- PROTEIN DOMAIN ENRICHMENT TAB
    

})

