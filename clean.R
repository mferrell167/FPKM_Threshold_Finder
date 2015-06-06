#
# Script create 'clean' fpkm_tracking files
#

fpkm_tracking <- commandArgs()[6]

inc <- commandArgs()[7]

old <- read.table(fpkm_tracking, header=T)

included <- read.table(inc, header=T)

include <- included$id

t <- subset(old, old$tracking_id %in% include)

basename <- head(tail(strsplit(fpkm_tracking, split = "\\.")[[1]], n=2), n=1)

type <- tail(strsplit(tail(strsplit(fpkm_tracking, split = "\\.")[[1]], n=1), split = "/")[[1]], n=1)

fname <- paste(basename, "_clean", sep = "")

if(type == "fpkm_tracking"){

fname <- paste(fname, ".fpkm_tracking", sep="")
}

if(type == "xprs"){
  
  fname <- paste(fname, ".xprs", sep="")
}

fname <- head(strsplit(fname, split = "/")[[1]], n=1)

write.table(t, file = fname, quote=F, row.names=F, sep='\t')
