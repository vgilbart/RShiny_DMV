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
        if (file_extension == "csv"){
            separator = ';'
        } else if (file_extension == "tsv"){
            separator = '\t'
        } # else { RAISE ERROR }
        
        df = read.table(file$datapath, header = T, sep = separator)
        return(df)
    })

    
    output$gene_table <- renderDataTable({
        dfGeneFile()
    })
    

    
    #-- WHOLE DATA INSPECTION TAB
    
    
    plotVolcano <- reactive({
        df=dfGeneFile()
        p=ggplot(data=df, aes(x=log2FC, y=pval)) + geom_point()
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

