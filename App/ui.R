#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(clusterProfiler)
library(ggplot2)
library(ggpubr)

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
                          value = c(-1,1),
                          step = 0.01),
          ),
          
          # Plots
          
          mainPanel(
              tabsetPanel(type = "tabs",
                          tabPanel("volcano plot", plotOutput("plot_Volcano")),
                          tabPanel("MA plot", plotOutput("plot_MA"))
              ),
              dataTableOutput("diff_expression_table")

          )
          
      ) # End of sidebarLayout
            
   ), # End of tabPanel
   
   tabPanel("GO Terms enrichment", 
      sidebarLayout(
        
        # Parameters
          sidebarPanel(
              h3("Parameters"), 
              # Level of GO term
              selectInput("level_GO", label = h4("Level of GO Terms"), 
                          choices = list("Biological process" = "BP", "Cellular componant" = "CC", "Molecular fonction" = "MF"), 
                          selected = "BP"),
              
              # Choice of method (SEA or GSEA)
              radioButtons("method_GO", label = h4("Enrichment method"),
                           choices = list("SEA" = 1, "GSEA" = 2), 
                           selected = 1), 
              
              # Choice of pvalue
              radioButtons("proba_GO", label = h4("Probability method"),
                           choices = list("p-value" = "pvalue", "p-adj" = "p.adjust"), 
                           selected = "p.adjust"),
        ),
      
        # Show bar plot, arborescence and datatable
        mainPanel(
           tabsetPanel(type = "tabs",
                       tabPanel("Dotplot", plotOutput("dotplot_GO")),
                       #tabPanel("Enrichment map", plotOutput("enrichM_GO")),
                       tabPanel("Table", dataTableOutput("table_GO"))
           )
          
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

