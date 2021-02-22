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
        validate( need(input$gene_file, "Please upload a csv or tsv file") )
        file = input$gene_file
        print(file)
        
        # Check if csv of tsv
        file_extension = strsplit(file$datapath, split="\\.")[[1]][-1]
        validate(need(file_extension == "csv" || file_extension == "tsv" , "Please upload a .csv or .tsv only") )
        
        if (file_extension == "csv"){
            separator = ','
        } else if (file_extension == "tsv"){
            separator = '\t'
        } 
        
        df = read.table(file$datapath, header = T, sep = separator)
        
        return(df)
    })

    
    output$gene_table <- renderDataTable({
        dfGeneFile()
    })
    

    
    #-- WHOLE DATA INSPECTION TAB
    
    plotVolcano <- reactive({
        df=dfGeneFile()
        df$diffexpressed <- "NO regulated"
        df$diffexpressed[df$log2FC > 0.6 & df$pval < 0.05] <- "UP regulated"
        df$diffexpressed[df$log2FC < -0.6 & df$pval < 0.05] <- "DOWN regulated"
        mycolors <- c("blue", "gray", "red")
        
        p = ggplot(data=df, aes(x=log2FC, y=-log10(pval), col=diffexpressed)) + 
            geom_point() + 
            theme_minimal() + 
            ggtitle("Volcano Plot") + 
            geom_vline(xintercept=c(-0.6, 0.6), col="red") +
            geom_hline(yintercept=-log10(0.05), col="red") +
            theme(plot.title = element_text(color="black", size=20, face="bold.italic", hjust = 0.5)) +
            scale_colour_manual(values = mycolors)
        
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

