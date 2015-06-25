library(lme4)
library(ggplot2)
library(lmerTest)

data <- read.csv("mixed_inter0.5_intra0.txt")
data <- within(data,id <- factor(id))

# dataframe average within subjects
dataSubject = aggregate(.~id,data=data,mean)

a <- ggplot(data = data, aes(x = x1, y = x2, col=id))
a <- a + geom_point(alpha = .6, size = 3)
a <- a + geom_smooth(method = "lm", formula = y ~ x, se = F, size = 1.2)
a <- a + geom_smooth(aes(y = x2, x = x1), method = "lm", formula = y ~ x, se = F, size = 1.2, color = "black")
a <- a + geom_point(data = dataSubject, aes(y = x2, x = x1),alpha = .6, size = 8)
a <- a + geom_smooth(data = dataSubject,aes(y = x2, x = x1), method = "lm", formula = y ~ x, se = F, size = 1.2, color = "black", linetype = 2)
a

# Naive model assuming all data independent
m0 = lm(x1 ~ x2,data=data)
summary(m0)

# Average data model, more appropriate DOF
m1 = lm(x1 ~ x2,data=dataSubject)
summary(m1)

# Mixed model
m2 = lmer(x1 ~ x2 + (1|id),data=data)
summary(m2)
