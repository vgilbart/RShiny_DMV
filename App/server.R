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
            validate( need(input$gene_file, "Please upload a csv or tsv file") )
            file = input$gene_file$datapath
        }
        print(file)

        # Check if file is csv of tsv
        file_extension = strsplit(file, split="\\.")[[1]][-1]
        validate(need(file_extension == "csv" || file_extension == "tsv" , "Please upload a .csv or .tsv file only") )
        if (file_extension == "csv"){
            separator = ','
        } else if (file_extension == "tsv"){
            separator = '\t'
        } 
        
        df = read.table(file, header = T, sep = separator)
        
        return(df)
    })

    
    output$gene_table <- renderDataTable(
        dfGeneFile(), 
        options = list(pageLength = 10, # Number of rows of datatable 
                      lengthMenu = c(5, 10, 25, 50) # Choice of number of rows
                      )
    )
    

    
    
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

