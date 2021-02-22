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
                     
                     textInput("species", "Choice of species", value = "", width = '400px'),
                     
                     
                     # Choice of species
                     
                     
                     # Button to upload an exemple file
                     # actionButton("load_exemple", "Run the app with an exemple file")
                     
                 ),
                 
                 # Show data table uploaded
                 mainPanel(
                     dataTableOutput("gene_table")
                 )
             
             ) # End of sidebarLayout
             ), # End of tabPanel
             
    tabPanel("Whole data inspection", 
             sidebarLayout(
                 
                 # Input
                 sidebarPanel(
                     # Choice of method
                     radioButtons("method_choice", label = h3("Method"),
                                  choices = list("SEA" = 1, "GSEA" = 2), 
                                  selected = 1),
                     
                     # Choice of pvalue
                     radioButtons("pvalue_method_choice", label = h3("Statistics method"),
                                  choices = list("p-value" = 1, "p-adj" = 2), 
                                  selected = 1),
                     
                     # Side bar
                     sliderInput("p-value", "P-value :",
                                 min = 0, max = 1,
                                 value = 0.5),
                 ),
                 
                 mainPanel(
                 )
                 
             ) # End of sidebarLayout
             
             ), # End of tabPanel
    
    tabPanel("GO Terms enrichment", 
             
             
            ), # End of tabPanel
    
    tabPanel("Pathway enrichment", 
             
             
            ), # End of tabPanel
    
    tabPanel("Protein Domain enrichment", 
             
             
            ) # End of tabPanel
    
    


))

