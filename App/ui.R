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
                
                 # Input
                 sidebarPanel(
                     
                     # Select file (GeneName, GeneID, baseMean, log2FC, pval, adj) in TSV or CSV
                     fileInput("gene_file", "Select a TSV or CSV File"),
                     # Without or without header
                     
                     # Gene origin (NCBI or Ensembl)
                     radioButtons("gene_origin_bank", label = h3("Gene origin"),
                                  choices = list("NCBI" = 1, "Ensembl" = 2), 
                                  selected = 1),
                     
                     textInput("gene_origin_id", "Gene Id", value = "", width = '400px'),
                     
                     
                     # Choice of species
                     
                     
                     # Button to upload an exemple file
                     # actionButton("load_exemple", "Run the app with an exemple file")
                     
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                     dataTableOutput("gene_table")
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
