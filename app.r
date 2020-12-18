library(shiny)
library(ggplot2)

# Get our initial data
moneyball <- read.csv("data/MoneyBallData 2013-2019.csv", as.is = TRUE)
moneyball2 <- read.csv("data/Final Moneyball Dataset (1962-2012).csv", as.is = TRUE)
moneyball2 <- moneyball2[-c(26:28)]

# Rename
names(moneyball2)[1] <- "franchID"
names(moneyball2)[17] <- "Payroll.in_millions_of_dollars."

# merge the two and rename Payroll
fullmoneyball <- rbind(moneyball, moneyball2)
fullmoneyball$Payroll <- gsub("[^0-9.-]", "", fullmoneyball$Payroll)
fullmoneyball$Payroll.in_millions_of_dollars. <- gsub("[^0-9.-]", "", fullmoneyball$Payroll.in_millions_of_dollars.)
fullmoneyball$Payroll <- as.numeric(fullmoneyball$Payroll)
fullmoneyball$Payroll.in_millions_of_dollars. <- as.numeric(fullmoneyball$Payroll.in_millions_of_dollars.)

# Subset for year >= 1988, year >= 1999, respectively.
moneyball1988 <- subset(fullmoneyball, Year >= 1988)
moneyball1999 <- subset(fullmoneyball, Year >= 1999)

# Aggregate average payroll, and other stats.
lgavg_payroll <- aggregate(moneyball1988$Payroll, by=list(Year=moneyball1988$Year), FUN=mean)
lgavg_OBP <- aggregate(fullmoneyball$OBP, by=list(Year=fullmoneyball$Year), FUN=mean)
lgavg_SLG <- aggregate(fullmoneyball$SLG, by=list(Year=fullmoneyball$Year), FUN=mean)
lgavg_OOBP <- aggregate(moneyball1999$OOBP, by=list(Year=moneyball1999$Year), FUN=mean)
lgavg_OSLG <- aggregate(moneyball1999$OSLG, by=list(Year=moneyball1999$Year), FUN=mean)

# Assign league averages to a key value pair between
# the statistic and its vector; this is used so that we can
# determine which aggregate to render from the graphchoice input.
lgavg <- list()
lgavg$OBP <- lgavg_OBP
lgavg$SLG <- lgavg_SLG
lgavg$OOBP <- lgavg_OOBP
lgavg$OSLG <- lgavg_OSLG

ui <- fluidPage(
  # Select the franchise
  selectInput(inputId = "franchise", label = "Choose a team:",
              choices = c("Arizona" = "ARI", "Atlanta" = "ATL", "Baltimore" = "BAL", "Boston" = "BOS", "Chicago Cubs" = "CHC",
                          "Chicago White Sox" = "CHW", "Cincinnati" = "CIN", "Colorado" = "COL", "Detroit" = "DET", "Houston" = "HOU",
                          "Kansas City" = "KCR", "LA Angels" = "ANA", "LA Dodgers" = "LAD", "Miami" = "FLA", "Milwaukee" = "MIL",
                          "Minnesota" = "MIN", "New York Mets" = "NYM", "New York Yankees" = "NYY", "Oakland" = "OAK",
                          "Philadelphia" = "PHI", "Pittsburgh" = "PIT", "San Diego" = "SDP", "San Francisco" = "SFG",
                          "Seattle" = "SEA", "St. Louis" = "STL", "Tampa Bay" = "TBD", "Texas" = "TEX", "Toronto" = "TOR",
                          "Washington" = "WSN")),
  # Select which graph to display
  selectInput(inputId = "graphchoice", label = "Choose a graph:", choices = c("OBP", "SLG", "OOBP", "OSLG"), selected = "OBP"),
  # Plot the payroll, w, and chosenGraph ggplots.
  plotOutput(outputId = "payroll"),
  plotOutput(outputId = "w"),
  plotOutput(outputId = "chosenGraph")
)
server <- function(input, output, session){
  output$payroll <- renderPlot(
    {
      franchise <- input$franchise
      ggplot() + geom_line(data = subset(fullmoneyball, Year >= 1988 & franchID == franchise),
                           aes(x=Year, y=Payroll, color = "Selected Team")) +
        geom_line(data = lgavg_payroll, aes(x=Year, y=x, color = "Average")) +
        scale_color_manual("", breaks = c("Selected Team", "Average"), values = c("blue", "black")) +
        xlim(1962, 2019)
    }
  )
  
  output$w <- renderPlot(
    {
      franchise <- input$franchise
      ggplot() + geom_line(data = subset(fullmoneyball, franchID == franchise),
                           aes(x=Year, y=W, color = "Selected Team")) +
        scale_color_manual("", breaks = "Selected Team", values = "blue") + xlim(1962, 2019)
    }
  )
  
  output$chosenGraph <- renderPlot(
    {
      gc <- input$graphchoice
      franchise <- input$franchise
      df <- subset(fullmoneyball, franchID == franchise)
      df$yy <- df[[gc]]
      avgDf <- lgavg[[gc]]
      ggplot() + geom_line(data = df, aes(x=Year, y=yy, color = "Selected Team")) +
        geom_line(data = avgDf, aes(x=Year, y=x, color = "Average")) + 
        scale_color_manual("", breaks = c("Selected Team", "Average"), values = c("blue", "black")) +
        xlim(1962, 2019) +
        ylab(gc)
    }
  )
}
shinyApp(ui = ui, server = server)
