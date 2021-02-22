#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Shiny DMV", 
   
   tabPanel("Input", 
      sidebarLayout(
          
          # Input
          sidebarPanel(
              
              # Select file (GeneName, GeneID, baseMean, log2FC, pval, padj) in TSV or CSV
              fileInput("gene_file", "Select a TSV or CSV File", 
                        accept = c("text/csv", 
                                   "text/comma-separated-values,text/plain",
                                   ".csv",
                                   ".tsv")),
              # Without or without header
              
              # Gene origin (NCBI or Ensembl)
              radioButtons("gene_origin_bank", label = h3("Gene origin"),
                           choices = list("NCBI" = 1, "Ensembl" = 2), 
                           selected = 1),
              
              # Choice of species
              textInput("species", "Choice of species", value = "", width = '400px'),
              
              # Button to upload an exemple file
              checkboxInput("load_exemple", label = "Run the app with an exemple file", value = FALSE),
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
              
              # Choice of pvalue
              radioButtons("method_choice", label = h3("Statistics method"),
                           choices = list("p-value" = 1, "p-adj" = 2), 
                           selected = 2),
              
              # Side bar p-value
              
              sliderInput("pvalue", "P_value :",
                          min = 0, max = 1,
                          value = 0.5),
              
              # Side bar fold change
              sliderInput("fold_change", "Fold Change :",
                          min = -5, max = 5,
                          value = c(-1,1)),
          ),
          
          # VolcanoPlot
          
          #
          
          mainPanel(
              plotOutput("plot_Volcano"),
          )
          
      ) # End of sidebarLayout
            
   ), # End of tabPanel
   
   tabPanel("GO Terms enrichment", 
    
      sidebarLayout(
        # Parameters
        sidebarPanel(
        
      
        ),
      
        # Show data table uploaded
        mainPanel(
        
        )
      
      ) # End of sidebarLayout
      
   ), # End of tabPanel
   
   tabPanel("Pathway enrichment", 
            # Choice of method
            radioButtons("method_choice", label = h3("Method"),
                         choices = list("SEA" = 1, "GSEA" = 2), 
                         selected = 1),
            
            
   ), # End of tabPanel
   
   tabPanel("Protein Domain enrichment", 
            
            
   ) # End of tabPanel
   
   
))

