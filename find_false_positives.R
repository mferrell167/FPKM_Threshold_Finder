# Marc Ferrell
# Plot Distributions of False Positive Rate Based on 'Reliable' Count For RNA-Seq Data
#
# Usage: Rscript find_false_positves.R <input.txt> <conf_level>
#
# Input: tab: id  FPKM	FPKMlo	FPKMhi
# Output: Plot of FNR and FPR

#write(commandArgs()[6], "")

data <- read.table(commandArgs()[6], header=T)

names(data) <- c("id", "FPKM", "FPKMlo", "FPKMhi")

conf_level <- as.numeric(commandArgs()[7])

breaks <- seq(from = 0, to = 75, by = 0.001)

bin_code <- .bincode(data[,2], breaks)

bins <- data.frame(bin = bin_code,
                   FPKM = data[,2],
                   FPKMlo = data[,3],
                   FPKMhi = data[,4])

bins <- na.omit(bins)

df <- data.frame(bin = NA,
                 reliable = NA, 
                 unreliable = NA)

for(i in unique(bins$bin)) {
  
  binn <- subset(bins, bins$bin > i)
  
  reliable <- nrow(subset(binn, binn$FPKMlo > 0)) / nrow(data)
    
  unreliable <- nrow(subset(binn, binn$FPKMlo <= 0)) / nrow(data)
  
  df_tmp <- data.frame(bin = i,
                       reliable = reliable,
                       unreliable = unreliable)
  
  df <- rbind(df, df_tmp)
}

bin_map <- data.frame(bin = NA,
                      FPKM = NA)

for(i in unique(df$bin)) {
  
  FPKM = (breaks[i] + breaks[i+1]) / 2
  
  df_tmp <- data.frame(bin = i,
                       FPKM = FPKM)
  bin_map <- rbind(bin_map,df_tmp)
  
}

bin_map <- na.omit(bin_map)

df <- merge(df, bin_map, by = "bin", all = T)

df <- na.omit(df)

df_conf <- subset(df, df$unreliable > conf_level)

threshold <- max(df_conf$FPKM)

include <- subset(data, data$FPKM > threshold)

exclude <- subset(data, data$FPKM < threshold)

fname <- commandArgs()[6]
message <- paste(tail(strsplit(fname, split = '/')[[1]], n=1), " Threshold: ")
message <- paste(message, threshold)
message <- paste(message, " FPKM")
write.table(matrix(message), file="Threshold.txt", quote=F, row.names=F, col.names=F)

write.table(include, file = paste(fname,"_include.txt", sep="") , quote= F, row.names=F)
write.table(exclude, file = paste(fname,"_exclude.txt",sep="") , quote= F, row.names=F)

library(ggplot2)

pdf(paste(commandArgs()[6], ".pdf", sep=""))
ggplot(df, aes(x = FPKM, y = unreliable)) + geom_point() +geom_hline(aes(yintercept=conf_level))+xlab("FPKM")+ylab("False positive rate (p)")+xlim(0,2.5)
dev.off()
