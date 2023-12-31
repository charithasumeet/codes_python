install.packages("tidyverse")
install.packages("RNHANES")

library(tidyverse)
library(RNHANES)
library(ggplot2)
library(pROC)
install.packages("olsrr")
library(olsrr)
library(dplyr)


#Nominal
#Slope
#Chest pain
#Ca
#Thal

#Binomial (0,1)
#Sex : 0,1
#Fbs
#RestECG
#ExAng

#Binomial (N,Y)
#AHD : N,Y



#1a- LM Analysis

data1 <- Heart



dat1 <- data1 %>%
  select(RestBP,Age, Chol, MaxHR, Oldpeak, ChestPain, Sex,
         Fbs, RestECG,ExAng, Slope, Ca, Thal, AHD)


#Exclude missings - Continous variables for assessing linear regression against Rest BP

dat_na = dat1 %>% 
  filter(!is.na(RestBP), !is.na(Age), !is.na(Chol), !is.na(MaxHR), !is.na(Oldpeak), 
         !is.na(ChestPain), !is.na(Sex), !is.na(Fbs), !is.na(RestECG), 
         !is.na(ExAng),!is.na(Slope), !is.na(Ca), !is.na(Thal), !is.na(AHD))
head(dat_na)


dat2 = dat1 %>% 
  filter(!is.na(RestBP), !is.na(Age), !is.na(Chol), !is.na(MaxHR), !is.na(Oldpeak), 
         !is.na(ChestPain), !is.na(Sex), !is.na(Fbs), !is.na(RestECG), 
         !is.na(ExAng),!is.na(Slope), !is.na(Ca), !is.na(Thal), !is.na(AHD))
head(dat2)
head(Heart)

#Modifying some variables into descriptive values for easier interpretation
#Sex, Fbs: > 120 mg/dl , RestECG, ExAngmSlope, Ca


dat2 = dat1 %>% 
  mutate(Sex = recode_factor(Sex, 
                                `1` = "Male", 
                                `0` = "Female"),
         Fbs = recode_factor(Fbs, 
                                `1` = "True", 
                                `0` = "False"), 
         RestECG = recode_factor(RestECG, 
                             `0` = "Normal", 
                             `1` = "Having ST-T wave abnormality ",
                             `2` = " Showing probable or definite left ventricular hypertrophy by Estes' criteria"),
         ExAng = recode_factor(ExAng, 
                             `0` = "No", 
                             `1` = "Yes"),
         Slope = recode_factor(Slope, 
                               `1` = "Upsloping", 
                               `2` = "Flat",
                               `3` ="Downsloping" ))



#using the lm() function to run the linear regression and then 
#summary() command to get the results.

#Age
fit <-lm(RestBP ~ Age, ,
           data = dat2)
summary(fit)


#Chol
fit <- lm(RestBP ~ Chol, 
           data = dat2)
summary(fit)


#MaxHR
fit <- lm(RestBP ~ MaxHR, 
           data = dat2)
summary(fit)




#Oldpeak
fit <- lm(RestBP ~ Oldpeak, 
           data = dat2)
summary(fit)




#ChestPain
fit <- lm(RestBP ~ ChestPain, 
           data = dat2)
summary(fit)


#Thal
fit <- lm(RestBP ~ Thal, 
           data = dat2)
summary(fit)

#AHD
fit <- lm(RestBP ~ AHD, 
           data = dat2)
summary(fit)

#Sex
fit <- lm(RestBP ~ Sex, 
           data = dat2)
summary(fit)



#Fbs
fit <- lm(RestBP ~ Fbs, 
          data = dat2)
summary(fit)

#RestECG
fit <- lm(RestBP ~ RestECG, 
          data = dat2)
summary(fit)


#ExAng
fit <- lm(RestBP ~ ExAng, 
          data = dat2)
summary(fit)

#Slope
fit <- lm(RestBP ~ Slope, 
          data = dat2)
summary(fit)


#Ca
fit <- lm(RestBP ~ Ca, 
          data = dat2)
summary(fit)

#Multiple regression
# Fit a multiple linear regression model with all predictors
full_model <- lm(RestBP ~ Age + Chol + MaxHR + Oldpeak + ChestPain + Sex + 
                   Fbs + RestECG + ExAng + Slope + Ca + Thal + AHD, 
                 data = dat2)
summary(full_model)



#Model selection
# forward selection
model = lm(RestBP ~Age + Chol + MaxHR + Oldpeak + ChestPain + Sex + 
             Fbs + RestECG + ExAng + Slope + Ca + Thal + AHD, data = dat_na)
summary(model)
olsrr::ols_step_forward_aic(model, details= TRUE)


# Backward selection method
model = lm(RestBP ~Age + Chol + MaxHR + Oldpeak + ChestPain + Sex + 
             Fbs + RestECG + ExAng + Slope + Ca + Thal + AHD, data = dat_na)
summary(model)
olsrr::ols_step_backward_aic(model, details= TRUE)

#Step-wis selection method
model = lm(RestBP ~Age + Chol + MaxHR + Oldpeak + ChestPain + Sex + 
             Fbs + RestECG + ExAng + Slope + Ca + Thal + AHD, data = dat_na)
summary(model)
olsrr::ols_step_both_aic(model, details= TRUE)




#2.a Logistic regression
#Remove NAs
Heart1 <- Heart
data_na = Heart1 %>% 
  filter(!is.na(RestBP), !is.na(Age), !is.na(Chol), !is.na(MaxHR), !is.na(Oldpeak), 
         !is.na(ChestPain), !is.na(Sex), !is.na(Fbs), !is.na(RestECG), 
         !is.na(ExAng),!is.na(Slope), !is.na(Ca), !is.na(Thal), !is.na(AHD))
head(data_na)
#change AHD to binary values
data_na%>%
  mutate(AHD= ifelse(AHD=="Yes",1,0))


#Age
log_1 <- glm(as.factor(AHD)~Age, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#RestBP
log_1 <- glm(as.factor(AHD)~RestBP, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))

#Chol
log_1 <- glm(as.factor(AHD)~Chol, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#MaxHR
log_1 <- glm(as.factor(AHD)~MaxHR, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#ChestPain
log_1 <- glm(as.factor(AHD)~ChestPain, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#Sex
log_1 <- glm(as.factor(AHD)~Sex, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#Fbs
log_1 <- glm(as.factor(AHD)~Fbs, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))



#RestECG
log_1 <- glm(as.factor(AHD)~RestECG, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#ExAng
log_1 <- glm(as.factor(AHD)~ExAng, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))

#Slope
log_1 <- glm(as.factor(AHD)~Slope, data_na, family = binomial)
summary(log_1)
exp



#Ca
log_1 <- glm(as.factor(AHD)~Ca, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))



#Thal
log_1 <- glm(as.factor(AHD)~Thal, data_na, family = binomial)
summary(log_1)
exp(cbind(Odds_Ratio = coef(log_1), confint(log_1)))


#Multiple logistic regression
log_multiple <- glm(as.factor(AHD) ~ Age+Sex+ChestPain+RestBP+Chol+Fbs+RestECG+MaxHR+
                           ExAng+Oldpeak+Slope+Ca+Thal, data = data_na, family = binomial)
summary(log_multiple)

library(pROC)

model1<-predict(log_multiple, type = c("response"))
roc(AHD ~ model1, data= data_na, plot= TRUE, print.auc=TRUE, col= "Blue", lwd=4, legacy.axes=TRUE, main="ROC Curve")

threshold= 0.5
pred_val <- ifelse(predict(log_multiple, type = "response")>threshold,1,0)
act_val <- log_multiple$y
conf_mat <- table(pred_val, act_val)
conf_mat


library(caret)
sensitivity(conf_mat)
specificity(conf_mat)


#PART - C

library(MASS)

#Logistic model with all the predictors
model_all <- glm(as.factor(AHD) ~ ., data= data_na, family= binomial)

#Stepwise forward
forwar_log <- step(model_all, direction = "forward", trace=0 , k=2)
summary(forwar_log)


#Stepwise backward
back_log <- step(model_all, direction = "backward", trace=0 , k=2)
summary(back_log)

#Stepwise selection using AIC
selec_mo <- step(model_all, direction = "both", trace=0 , k=2)
summary(selec_mo)



# Load required libraries (if not already loaded)
library(caret)

# Set seed for reproducibility
set.seed(297)

# Create a training set with an 80/20 split
train_in <- createDataPartition(data_na$AHD, p = 0.7, list = FALSE, times = 1)
train1 <- data_na[train_in, ]
test <- data_na[-train_in, ]

# Fit a logistic regression model
trainmodel <- glm(formula = AHD ~ Age + Sex + ChestPain + RestBP + Chol + Fbs + RestECG + MaxHR +
                    ExAng + Oldpeak + Slope + Ca + Thal, 
                  data = train1, family = binomial)

# Summary of the logistic regression model
summary(trainmodel)

# Set the threshold for classification
threshold <- 0.5

# Predict using the model and threshold
predicted_value <- ifelse(predict(trainmodel, type = "response") > threshold, 1, 0)
act_value <- train1$AHD  # Use the training data for actual values

# Create a confusion matrix
conf_mat <- table(predicted_value, act_value)

conf_mat

library(caret)
sensitivity_value <- sensitivity(conf_mat)