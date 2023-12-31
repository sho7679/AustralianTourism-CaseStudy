---
  title: "Austr"
output: html_document
---
  ```{r}
library(tidyverse)
library(dplyr)
library(plotly)
```

```{r}
df_Aus<- read_csv("ausActiv.csv")
df_AusDesc <- read_csv("ausActivDesc.csv")

ausActiv <- df_Aus %>% 
  mutate(id = row_number())

ausActivDesc <- df_AusDesc %>% 
  mutate(id = row_number())

ausActiv

#merge them 
combdf <- merge(ausActiv,ausActivDesc)
combdf
```

```{r}
risk <- read_csv("risk.csv")
risk 

```
#get averages of each - assuming that the numbers are ranked from care most about (5) to least care about (1)
```{r}
recreational <-mean(risk$Recreational) #2.190053
health <-mean(risk$Health) #2.396092
career <-mean(risk$Career) #2.007105
financial <-mean(risk$Financial) #2.026643
safety <-mean(risk$Safety) #2.26643
social<- mean(risk$Social) #2.017762

#Health > Safety > Recreational > Financial > Social > Career 
```

# find percentages of each rating for each section 
```{r}
nrow(risk) #total is 563
a1<-((nrow(filter(risk, Recreational ==1)))/563)*100 
b1<-((nrow(filter(risk, Recreational ==2)))/563)*100 
c1<-((nrow(filter(risk, Recreational ==3)))/563)*100 
d1<-((nrow(filter(risk, Recreational ==4)))/563)*100 
e1<-((nrow(filter(risk, Recreational ==5)))/563)*100 

a2<-((nrow(filter(risk, Health ==1)))/563)*100 
b2<-((nrow(filter(risk, Health ==2)))/563)*100 
c2<-((nrow(filter(risk, Health ==3)))/563)*100 
d2<-((nrow(filter(risk, Health ==4)))/563)*100 
e2<-((nrow(filter(risk, Health ==5)))/563)*100 

a3<-((nrow(filter(risk, Career ==1)))/563)*100 
b3<-((nrow(filter(risk, Career ==2)))/563)*100 
c3<-((nrow(filter(risk, Career ==3)))/563)*100 
d3<-((nrow(filter(risk, Career ==4)))/563)*100 
e3<-((nrow(filter(risk, Career ==5)))/563)*100 


a4<-((nrow(filter(risk, Financial ==1)))/563)*100 
b4<-((nrow(filter(risk, Financial ==2)))/563)*100 
c4<-((nrow(filter(risk, Financial ==3)))/563)*100 
d4<-((nrow(filter(risk, Financial ==4)))/563)*100 
e4<-((nrow(filter(risk, Financial ==5)))/563)*100 

a5<-((nrow(filter(risk, Safety ==1)))/563)*100 
b5<-((nrow(filter(risk, Safety ==2)))/563)*100 
c5<-((nrow(filter(risk, Safety ==3)))/563)*100 
d5<-((nrow(filter(risk, Safety ==4)))/563)*100 
e5<-((nrow(filter(risk, Safety ==5)))/563)*100 

a6<-((nrow(filter(risk, Social ==1)))/563)*100 
b6<-((nrow(filter(risk, Social ==2)))/563)*100 
c6<-((nrow(filter(risk, Social ==3)))/563)*100 
d6<-((nrow(filter(risk, Social ==4)))/563)*100 
e6<-((nrow(filter(risk, Social ==5)))/563)*100 

#round to the lowest integer 
x5 <- c(e1, e2, e3, e4, e5, e6)

x4 <- c(d1,d2,d3,d4,d5,d6)

x3 <- c(c1,c2,c3,c4,c5,c6)

x2 <- c(b1,b2,b3,b4,b5,b6)

x1 <- c(a1,a2,a3,a4,a5,a6)
x1<-x1 %>%
  floor()
x2<-x2 %>%
  floor()
x3<-x3 %>%
  floor()
x4<-x4 %>%
  floor()
x5<-x5 %>%
  floor()
#top<-c(a6,b6,c6,d6,e6)

```

#here i go with plotly 
```{r}
y <- c('Recreational',
       'Health',
       'Career',
       'Financial',
       'Safety',
       'Social')

data <- data.frame(y, x1, x2, x3, x4, x5)
top_labels <- c('Very<br>important', 'Somewhat<br>important', 'Neutral', 'Somewhat<br>unimportant', 'Very<br>unimportant')
fig <- plot_ly(data, x = ~x1, y = ~y, type = 'bar', orientation = 'h',
               marker = list(color = 'rgba(38, 24, 74, 0.8)',
                             line = list(color = 'rgb(248, 248, 249)', width = 1))) 
fig <- fig %>% add_trace(x = ~x2, marker = list(color = 'rgba(71, 58, 131, 0.8)')) 
fig <- fig %>% add_trace(x = ~x3, marker = list(color = 'rgba(122, 120, 168, 0.8)')) 
fig <- fig %>% add_trace(x = ~x4, marker = list(color = 'rgba(164, 163, 204, 0.85)')) 
fig <- fig %>% add_trace(x = ~x5, marker = list(color = 'rgba(190, 192, 213, 1)')) 
fig <- fig %>% layout(xaxis = list(title = "",
                                   showgrid = FALSE,
                                   showline = FALSE,
                                   showticklabels = FALSE,
                                   zeroline = FALSE,
                                   domain = c(0.15, 1)),
                      yaxis = list(title = "",
                                   showgrid = FALSE,
                                   showline = FALSE,
                                   showticklabels = FALSE,
                                   zeroline = FALSE),
                      barmode = 'stack',
                      paper_bgcolor = 'rgb(248, 248, 255)', plot_bgcolor = 'rgb(248, 248, 255)',
                      margin = list(l = 120, r = 10, t = 140, b = 80),
                      showlegend = FALSE)

# labeling the y-axis
fig <- fig %>% add_annotations(xref = 'paper', yref = 'y', x = 0.14, y = y,
                               xanchor = 'right',
                               text = y,
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(67, 67, 67)'),
                               showarrow = FALSE, align = 'right') 
# labeling the percentages of each bar (x_axis)
fig <- fig %>% add_annotations(xref = 'x', yref = 'y',
                               x = x1 / 2, y = y,
                               text = paste(data[,"x1"], '%'),
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(248, 248, 255)'),
                               showarrow = FALSE) 
fig <- fig %>% add_annotations(xref = 'x', yref = 'y',
                               x = x1 + x2 / 2, y = y,
                               text = paste(data[,"x2"], '%'),
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(248, 248, 255)'),
                               showarrow = FALSE) 
fig <- fig %>% add_annotations(xref = 'x', yref = 'y',
                               x = x1 + x2 + x3 / 2, y = y,
                               text = paste(data[,"x3"], '%'),
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(248, 248, 255)'),
                               showarrow = FALSE) 
fig <- fig %>% add_annotations(xref = 'x', yref = 'y',
                               x = x1 + x2 + x3 + x4 / 2, y = y,
                               text = paste(data[,"x4"], '%'),
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(248, 248, 255)'),
                               showarrow = FALSE) 
fig <- fig %>% add_annotations(xref = 'x', yref = 'y',
                               x = x1 + x2 + x3 + x4 + x5 / 2, y = y,
                               text = paste(data[,"x5"], '%'),
                               font = list(family = 'Arial', size = 12,
                                           color = 'rgb(248, 248, 255)'),
                               showarrow = FALSE) 

# labeling the first Likert scale (on the top)
fig <- fig %>% add_annotations(xref = 'x', yref = 'paper',
                               x = c(18, 54,75 , 87, 100),
                               y = 1.15,
                               text = top_labels,
                               font = list(family = 'Arial', size = 11,
                                           color = 'rgb(67, 67, 67)'),
                               showarrow = FALSE)
fig

```

# Overall averages 
```{r}
averages <- c(2.01, 2.02, 2.03, 2.19, 2.27, 2.40)
Sector <- c("Career", "Social", "Financial", "Recreational", "Safety", "Health")
df <- data.frame(averages, Sector)


```

```{r}
df %>%
  mutate(Sector = fct_reorder(Sector, averages)) %>%
  ggplot(aes(x = Sector,y = averages)) + 
  geom_bar(stat = "identity", fill = "blue4", color = "black")+
  scale_fill_hue(c = 40) +
  ylab("Average Rating")+
  ggtitle("Average Importance Ratings")+
  theme_classic()+ 
  theme(axis.title = element_text(size = 13), 
        plot.title = element_text(size = 18, hjust=0.5))+
  geom_text(aes(label = averages), vjust=2, color = "white")


```

```{r}
winter <- read_csv("winterActiv.csv")
colnames(winter)
```
