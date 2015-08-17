#
# Script create 'clean' gtf files for Cuffdiff
#

gtf <- commandArgs()[6]

inc <- commandArgs()[7]

write("Loading GTF", stderr())

old <- read.table(gtf, header=F, sep = "\t")

write("Load Complete", stderr())

included <- read.table(inc, header=T)

include <- included$id

rows_include <- c()

for(i in c(1:nrow(old))){
    
   percent_done <- 100 * (i / nrow(old))
    
    write(percent_done, stderr())
    
    #write(as.character(length(unique(rows_include))), stderr())
    
   feature <- old[i,3]

   attributes <- as.character(old[i,9])
    
   tid_s <- strsplit(attributes, ";")[[1]][2]
    
   tid <- strsplit(tid_s, " ")[[1]][3]
    
   if(feature == "transcript" & tid %in% include){
        
       rows_include <- c(rows_include, i)
        
   }

}

t <- old[rows_include,]

basename <- head(tail(strsplit(gtf, split = "\\.")[[1]], n=2), n=1)

#type <- tail(strsplit(tail(strsplit(gtf, split = "\\.")[[1]], n=1), split = "/")[[1]], n=1)

fname <- paste(basename, "_clean.gtf", sep = "")

fname <- head(strsplit(fname, split = "/")[[1]], n=1)

write.table(t, file = fname, quote=F, row.names=F, col.names=F, sep='\t')
