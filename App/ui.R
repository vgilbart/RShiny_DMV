#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Shiny DMV", 
    
    tabPanel("Input", 
             sidebarLayout(
                
                 sidebarPanel(
                     
                     # Download file (GeneName, GeneID, baseMean, log2FC, pval, adj) in TSV or CSV
                     
                     
                     # Gene origin (NCBI or Ensembl)
                     
                     
                     # Choice of species
                     
                     
                     # Button to upload an exemple file
                     
                     
                     # Un exemple à enlever ASAP
                     sliderInput("bins",
                                 "Number of bins:",
                                 min = 1,
                                 max = 50,
                                 value = 30)
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                     # Un exemple à enlever ASAP
                     plotOutput("distPlot")
                 )
             
             ) # End of sidebarLayout
             ), # End of tabPanel
             
    tabPanel("Whole data inspection", 
            
             
             ), # End of sidebarLayout
    
    tabPanel("GO Terms enrichment", 
             
             
    ), # End of sidebarLayout
    
    tabPanel("Pathway enrichment", 
             
             
    ), # End of sidebarLayout
    
    tabPanel("Protein Domain enrichment", 
             
             
    ) # End of sidebarLayout
    
    


))
