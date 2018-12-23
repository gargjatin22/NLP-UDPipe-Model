#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(stringr)


shinyServer(function(input, output) {
   
  Dataset <- reactive({
    
    if (is.null(input$file1)) {   # locate 'file1' from ui.R
      
      Data <- readLines(file('D:/personal/ISB/pgdba/CBA/offer/CBA/Course/term 1/TA/Assignment/UDpipe/UDPipe/data/input/manual/test.txt',"r"))
      return(Data)
      #return(NULL)
      } else{
        Data =  readLines(input$file1$datapath)
        return(Data)
        
      }
  })
  checkbox_filter <- reactive({
    return(input$checkGroup)
  })

  Model <- reactive({
    
    if (is.null(input$file2)) {# locate 'file2' from ui.R
      
      modelname=input$file3
      model_location = paste0("./data/input/manual/",modelname)
      model = udpipe_load_model(model_location)

      }
    else{
      model = udpipe_load_model(input$file2$datapath)
        
    }
    x <- udpipe_annotate(model, x = Dataset()) #%>% as.data.frame() %>% head()
    x <- as.data.frame(x)
    return(x)
  })

  terms <- reactive({
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(as.data.frame(Dataset()))
      })
    })
  })
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                   max.words=100,
                  colors=brewer.pal(8, "Dark2"))
    

  })
  
  output$clust_data <- renderTable({
    data = (Model())
    df = as.data.frame(data)
    head(df,100) 
    
  })
  output$clust_summary <- renderPlot({
    data = (Model())
    df = as.data.frame(data)
    df_upos =data.frame(xpos=c("JJ", "NN", "NNP", "RB", "VB"),upos=c("ADJ","NOUN","NOUN","ADV","VERB"),stringsAsFactors = F)
    checkbox_upos= df_upos$upos[df_upos$xpos %in% c(checkbox_filter())]
    
    if (!all(is.na(df$xpos))) {
      df_cooc <- cooccurrence(     # try `?cooccurrence` for parm options
        x = subset(df, xpos %in% c(checkbox_filter())), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  
      
      wordnetwork <- head(df_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      plot= ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences of Xpos")
    }
    else {
      plot = NULL
    }

    df_cooc_pos <- cooccurrence(     # try `?cooccurrence` for parm options
      x = subset(df, upos %in% c(checkbox_upos)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id")) 

    df_gen <- cooccurrence(x = df$lemma, 
                                   relevant = df$xpos %in% c(checkbox_filter()))
                                   #c("NOUN", "ADJ")) # 0.00 secs

    
   

#Upos
    wordnetwork_upos <- head(df_cooc_pos, 50)
    wordnetwork_upos <- igraph::graph_from_data_frame(wordnetwork_upos) # needs edgelist in first 2 colms.
    
    plot_upos = ggraph(wordnetwork_upos, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences of Upos")
    cooc_plots = list(plot,plot_upos)
    to_delete <- !sapply(cooc_plots,is.null)
    cooc_plots <- cooc_plots[to_delete] 
    grid.arrange(grobs=cooc_plots,ncol=length(cooc_plots))
  })

  
})
