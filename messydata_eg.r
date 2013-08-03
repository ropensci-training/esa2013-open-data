library(taxize)
dat <- read.csv("data/messydata.csv")
spnames <- dat[,2]

# Search TNRS
out <- tnrs(spnames, source_ = "iPlant_TNRS")

# The following were not exact matches
out$submittedName[!out$submittedName %in% out$matchedName]
names_spell_corrected <- out$matchedName

# get tsn's
tsns <- get_tsn(names_spell_corrected)

# are names those accepted in ITIS? (prints good and bad name message)
accepted <- llply(tsns, getacceptednamesfromtsn)

# replace names not accepted by ITIS
names_spell_corrected[!len == 1] <- sapply(accepted[!len == 1], "[[", "acceptedName")

# put new names in data.frame, and remove old
dat$newnames <- names_spell_corrected
dat <- dat[,-c(1:2)]

# make long
library(reshape2)
library(ggplot2)
dat_m <- melt(dat)
ggplot(dat_m, aes(newnames, value)) +
  geom_bar(stat="identity") +
  coord_flip() +
  facet_wrap(~variable)