library(shiny)
library(pheatmap)
library(dplyr)
library(tibble)
library(viridis)
library(tidyr)
library(stringr)
library(RColorBrewer)
library(shinyWidgets)

moduleTraitCor <- read.csv("C:/Users/grrompala/Desktop/Eigengene/Results_Correlations.csv",header=T,row.names=1)
COLORS <- rownames(brewer.pal.info)

options(shiny.maxRequestSize = 30 * 1024 ^ 2)  # max-csv upload set to 30 MB

ui <- fluidPage(
  h1(style="font-family:impact;font-size:300%","Heatmap Helper"),
  
  
  sidebarLayout(
    sidebarPanel(
      wellPanel(style = "background:lightgreen;font-size:9px;border-width:thick;border-color:black",
      # Checkbox for rownames
      splitLayout(
        checkboxInput(inputId = 'Rows',
                      label="Row Names?",
                      value = F, 
                      width =10),
        # Checkbox for colnames
        checkboxInput(inputId="Col",
                      label="Column Names?",
                      value=F,
                      width=10)),
      splitLayout(
        # Checkboxes for clustering rows/columns			
        
        checkboxInput(inputId="Cluster.rows",
                      label="Cluster rows?",
                      value=TRUE,
                      width=25),
        
        checkboxInput(inputId="Cluster.cols",
                      label="Cluster columns?",
                      value=TRUE,
                      width=25)
      ),
      selectInput(inputId="Color",
                  label="Choose color palette",
                  choices=c("Default",COLORS),
                  selected = "Default"
      ),
      
      sliderInput(inputId="Breaks",
                  label="Choose Color Palette to Adjust Color Breaks",
                  min=2,max=12,value=4
      ),
      wellPanel(downloadButton("downloadData2", "Download Ungrouped Heatmap",
                     style='padding:16px; font-size:100%')
      )
      )
    ),
      mainPanel(
        tabPanel(
          "Heatmaps",
          h2("Network-Trait Relationships"),
          wellPanel(style = "background:white;border-width:thick;border-color:black", 
                    plotOutput("pheatmap.full")
                    )
          )
      )
  )
)

server <- function(input, output, session) {
          
  # For colors
  col.pal <- reactive({
    if(input$Color=="Default")
      {colorRampPalette(rev(brewer.pal(n = input$Breaks, name ="RdYlBu")))(100)}
    else{colorRampPalette(rev(brewer.pal(n=input$Breaks
                                                                                                                                          ,name= input$Color)))(100)}
  })
  
  # The Heatmap
  output$pheatmap.full = 
    renderPlot({
              pheatmap(
              moduleTraitCor,
              cluster_rows = input$Cluster.rows,
              #scale = "row",
              annotation_col= if(is.null(input$mydropdown)){NA}else{metaA()},
              show_rownames=input$Rows,
              show_colnames = input$Col,
              color = col.pal(),
              cluster_cols = input$Cluster.cols
              )
            }) #,
          #width=function(){input$groupWidth},
          #height=function(){input$Height})
}

  plotInput.full <- function() {
    pheatmap(
     moduleTraitCor,
      cluster_rows = input$Cluster.rows,
      scale = "row",
      annotation_col=if(is.null(input$mydropdown)){NA}else{metaA()},
      show_rownames =input$Rows, 
      show_colnames = input$Col,
      color=col.pal(),
      cluster_cols = input$Cluster.cols
  )
}

shinyApp(ui, server)

