#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(session, input, output) {

    #-- INPUT TAB
    
    # Retrieve dataframe from file
    dfGeneFile = reactive({
        validate( need(input$gene_file, "Please upload a file") )
        file = input$gene_file
        print(file)
        df = read.table(file$datapath, header = T)
    })
    
    
    output$gene_table <- renderDataTable({
        dfGeneFile()
    })
    
    
    
    #-- WHOLE DATA INSPECTION TAB
    
    
    #-- GO TERMS ENRICHMENT TAB
    
    
    #-- PATHWAY ENRICHMENT TAB
    
    
    #-- PROTEIN DOMAIN ENRICHMENT TAB
    

})
