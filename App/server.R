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
library(ggpubr)

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
    observeEvent(input$method_choice, {
        if (input$method_choice == 2){
                updateSliderInput(session, "pvalue", "Padj",
                                min = 0, max = 1,
                                value = 0.5)
        }
        else if (input$method_choice == 1){
            updateSliderInput(session, "pvalue",  "Pvalue",
                              min = 0, max = 1,
                              value = 0.5)
        }
    })
    
    # volcano plot
    plotVolcano <- reactive({
        df=dfGeneFile()
        if (input$method_choice == 2){
            pvalue_choice <- df$padj
            pval_for_plot <- "padj"
        }
        else if (input$method_choice == 1){
            pvalue_choice <- df$pval
            pval_for_plot <- "pval"
        }
        
        # print(input$method_choice)
        # print(df$pvalue_choice)
        # print(df$pval)
        df$diffexpressed <- "NO regulated"
        df$diffexpressed[df$log2FC > input$fold_change[2] & pvalue_choice < -log10(input$pvalue)] <- "UP regulated"
        df$diffexpressed[df$log2FC < input$fold_change[1] & pvalue_choice < -log10(input$pvalue)] <- "DOWN regulated"
        mycolors <- c("blue", "gray", "red")
        
        p = ggplot(data=df, aes(x=log2FC, y=-log10(get(pval_for_plot)), col=diffexpressed)) + 
            geom_point() + 
            theme_minimal() + 
            ggtitle("Volcano Plot") + 
            geom_vline(xintercept=c(input$fold_change[1], input$fold_change[2]), col="red") +
            geom_hline(yintercept=-log10(input$pvalue), col="red") +
            theme(plot.title = element_text(color="black", size=20, face="bold.italic", hjust = 0.5)) +
            scale_colour_manual(values = mycolors)
        return(p)
    })  
    
    # Construction of MA plot
    plot_MA <- reactive({
        df=dfGeneFile()
        log2FoldChange=dfGeneFile$lof2FC
        #http://rpkgs.datanovia.com/ggpubr/reference/ggmaplot.html
        p = ggmaplot(
            data=df, fdr = 0.05, 
            fc = 1.5, #change barres horizontales
            genenames = as.vector(dfGeneFile$name),
            alpha = 1,
            font.label = c(12, "plain", "black"),
            label.rectangle = FALSE,
            palette = c("#B31B21", "#1465AC", "darkgray"),
            top = 15,
            select.top.method = c("padj", "fc"),
            label.select = NULL,
            main = "MAPlot",
            xlab = "Log2 mean expression",
            ylab = "Log2 fold change")
            ggtheme = ggplot2::theme_minimal()
            #theme(plot.title = element_text(color="black", size=20, face="bold.italic", hjust = 0.5))
    })
    
    #variables
    output$plot_Volcano <- renderPlot(
        plotVolcano()
    )
    
    output$plot_MA <- renderPlot(
        plot_MA()
    )


    #-- GO TERMS ENRICHMENT TAB
    
    
    #-- PATHWAY ENRICHMENT TAB
    
    
    #-- PROTEIN DOMAIN ENRICHMENT TAB
    

})

