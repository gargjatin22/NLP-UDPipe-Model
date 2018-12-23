#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/

#  Jeetender Kumar      PGID 11810041
#  Taruna Gupta         PGID 11810032
#  Suneet Singh Bhatia  PGID 11810012

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
                  #choices = c("english-ud-2.0-170801.udpipe", "hindi-ud-2.0-170801.udpipe", "spanish-ud-2.0-170801.udpipe","Upload_UDPipe_Model"),selected = "english-ud-2.0-170801.udpipe"),
      choices = c("english", "hindi", "spanish","afrikaans", "ancient_greek-proiel", "ancient_greek", "arabic", "basque", "belarusian", "bulgarian", "catalan", "chinese", "coptic", "croatian", "czech-cac", "czech-cltt", "czech", "danish", "dutch-lassysmall", "dutch", "english-lines", "english-partut", "estonian", "finnish-ftb", "finnish", "french-partut", "french-sequoia", "french", "galician-treegal", "galician", "german", "gothic", "greek", "hebrew", "hungarian", "indonesian", "irish", "italian", "japanese", "kazakh", "korean", "latin-ittb", "latin-proiel", "latin", "latvian", "lithuanian", "norwegian-bokmaal", "norwegian-nynorsk", "old_church_slavonic", "persian", "polish", "portuguese-br", "portuguese", "romanian", "russian-syntagrus", "russian", "sanskrit", "serbian", "slovak", "slovenian-sst", "slovenian", "spanish-ancora", "swedish-lines", "swedish", "tamil", "turkish", "ukrainian", "urdu", "uyghur", "vietnamese"),selected = "english"),
    
      tags$hr(),
      tags$hr(),
      checkboxGroupInput(
      inputId = "checkGroup",
      label = "Part-Of-Speech Tags",
      #direction = "vertical",
      choices = list("Adjective (JJ)"="JJ", "Noun(NN)"="NN", "Proper noun (NNP)"="NNP", "Adverb (RB)"="RB", "Verb (VB)"="VB" ),
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
                           a(href="https://raw.githubusercontent.com/gargjatin22/NLP-UDPipe-Model/master/test.txt"
                             ,"Sample data input file"),   
                           
                           br(),
                           tags$hr(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload data (text file)")),
                             'and upload the text file then either click on ',
                             span(strong("Upload UPpipe model")),
                             'and upload a UPpipe Model or choose UDPipe from given options and then Select list of part-of-speech tags (XPOS)')),
                          #tags$ol(
                           # tags$li("click on Upload text file"), 
                          #  tags$li("Upload the text file"), 
                          #  tags$li("click on Upload UPpipe model or choose UDPipe from given options"),
                          #  tags$li("Select list of part-of-speech tags (XPOS)")
                          #  ),
                           
                  tabPanel("Word Cloud", 
                           addSpinner(plotOutput('plot1'), spin = "circle")),
                  tabPanel("Cooccurrences Word", 
                           fluidRow(p("Xpos"),dataTableOutput("iStatePlot"),
                                    wellPanel(p("Upos"),
                                      dataTableOutput("selectState")))),
                           #column(2,addSpinner(dataTableOutput('word1'), spin = "circle"))),
                  
                  tabPanel("Cooccurrences Plot",
                           column(2,addSpinner(plotOutput(outputId="clust_summary", width="900px",height="700px"), spin = "circle"))),
                  tabPanel("Data",
                           tableOutput("clust_data"))
                  #(plotOutput("clust_summary"))
                  #column(6,plotOutput(outputId="plotgraph", width="500px",height="400px"))
      ) # end of tabsetPanel
    )
  )
))

