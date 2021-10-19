rm(list=ls())


#load packages

library(tidyverse) # Modern data science library 
library(plm)       # Panel data analysis library
library(car)       # Companion to applied regression 
library(gplots)    # Various programing tools for plotting data
library(tseries)   # For timeseries analysis
library(lmtest)    # For hetoroskedasticity analysis
library(readxl)    # For get the data
library(sandwich)  # For sandwich


# Data import and tidying

setwd('C:/Users/vitor/Documents/Mestrado Econometria/2º Semestre/Microeconometria I/Trabalho 1')#substituir o diretório

df<- read_excel('Db.xls')
df


df <- pdata.frame(df,index="schid")

#Exploratory Data Analysis
scatterplot(df$math4 ~df$year|df$schid)
?scatterplot
coplot(df$math4 ~ df$year|df$schid, type="l") # Lines
coplot(df$math4 ~ df$year|df$schid, type="b") # Points and lines



# Panel Data modeling

#Basic OLS model
ols <- lm(df$math4 ~ df$lunch+df$exppp + df$lrexpp+ df$y95+ df$y96+
          df$y97+df$y98)
summary(ols)

coeftest(ols, vcov. = vcovHC, type = "HC1")# Robust t test

##Fixed Effects Model

fixed <- plm(math4 ~ lunch+exppp + lrexpp+ y95+ y96+
               y97+y98, data=df,index = c('df$schid', 'df$year'), model="within")
summary(fixed)
coeftest(fixed, vcov. = vcovHC, type = "HC1")

#time-fixed effects testing

fixed.time <- plm(math4 ~ lunch+exppp + lrexpp + factor(year), data=df, model="within")
summary(fixed.time)

# Testing time-fixed effects. The null is that no time-fixed effects are needed
pFtest(fixed.time, fixed)

#Fixed Effects vs OLS

pFtest(fixed, ols)

#Random Effects Model

random <- plm(math4 ~ lunch+exppp + lrexpp+ y95+ y96+
                y97+y98, data=df,index = c('df$schid', 'df$year'), model="within")
summary(random)

coeftest(random, vcov. = vcovHC, type = "HC1")

##### New Model

#Pooled OLS
pool <- plm(df$math4 ~ df$lunch + df$lrexpp + df$small + df$y95+
              df$y96 + df$y97 + df$y98, data=df, model="pooling")
summary(pool)

#fixed effects

fixed_model1 <- plm(df$math4 ~ df$lunch + df$lrexpp + df$small + df$y95+
                      df$y96 + df$y97 + df$y98, data=df, model="within")
summary(fixed_model1)

#random effects

random_model1 <- plm(df$math4 ~ df$lunch + df$lrexpp + df$small + df$y95+
                       df$y96 + df$y97 + df$y98, data=df, model="random")
summary(random_model1)

#Hausman Test
#Fixed vs Random

phtest(fixed_model1, random_model1)