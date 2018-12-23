#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
options(shiny.maxRequestSize=60*1024^2)
shinyUI(fluidPage(
  
  # Application title
  theme = shinytheme("flatly"),
  titlePanel("NLP UDPipe"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1","Upload text file",
                accept = c(
                  "text/plain")),
      tags$hr(),
      fileInput("file2", "Upload UDPipe Model"),
      paste("Or choose from below list"),
      br(),
      br(),
      selectInput("file3", "Choose UPpipe Model:", 
                  choices = c("english-ud-2.0-170801.udpipe", "hindi-ud-2.0-170801.udpipe", "spanish-ud-2.0-170801.udpipe","Upload_UDPipe_Model"),selected = "english-ud-2.0-170801.udpipe"),
      
      tags$hr(),
      tags$hr(),
      checkboxGroupInput(
      inputId = "checkGroup",
      label = "Part-Of-Speech Tags",
      #direction = "vertical",
      choices = list("1.Adjective (JJ)"="JJ", "2.Noun(NN)"="NN", "3.Proper noun (NNP)"="NNP", "4.Adverb (RB)"="RB", "5.Verb (VB)"="VB" ),
      selected = c("JJ","NN","NNP")
      #checkIcon = list(yes = icon("ok", 
       #                           lib = "glyphicon")),
      #justified = TRUE
    )
    #setBackgroundImage(src = "https://blog.algorithmia.com/wp-content/uploads/2016/04/natural-language-processing-algorithms-fb-1.png")
    #setBackgroundImage(src = "https://blog.algorithmia.com/wp-content/uploads/2016/04/natural-language-processing-algorithms-fb-1.png")
    
    ),
     
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Overview",
                           
                           h4(p("Data input")),
                           p("This app supports only text file as input. You Can also upload the UDPipe model of any language or choose from the given list",align="justify"),
                           p("Please refer to the link below for sample text file."),
                           a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                             ,"Sample data input file"),   
                           
                           br(),
                           tags$hr(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload data (text file)")),
                             'and uppload the text file then either click on ',
                             span(strong("Upload UPpipe model")),
                             'and upload a UPpipe Model or choose UDPipe from given options and then Select list of part-of-speech tags (XPOS)')),
                           
                           
                  tabPanel("Word Cloud", 
                           addSpinner(plotOutput('plot1'), spin = "circle")),
                  
                  tabPanel("Cooccurrences Plot",
                           column(2,addSpinner(plotOutput(outputId="clust_summary", width="800px",height="600px"), spin = "circle"))),
                  tabPanel("Data",
                           tableOutput("clust_data"))
                  #(plotOutput("clust_summary"))
                  #column(6,plotOutput(outputId="plotgraph", width="500px",height="400px"))
      ) # end of tabsetPanel
    )
  )
))

