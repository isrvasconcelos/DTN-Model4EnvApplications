r1 <- 1:30

sc500 <- vector()
dr500 <- vector()

sc1000 <- vector()
dr1000 <- vector()

sc1500 <- vector()
dr1500 <- vector()

sc2000 <- vector()
dr2000 <- vector()

sc2500 <- vector()
dr2500 <- vector()

for(i in r1) {

	try(sc500[i] <- read.table(paste(i,"_50_250_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr500[i] <- read.table(paste(i,"_50_250_coverage_DropRandom.dat",sep=''))[[1]])

	try(sc1000[i] <- read.table(paste(i,"_50_1000_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr1000[i] <- read.table(paste(i,"_50_1000_coverage_DropRandom.dat",sep=''))[[1]])

	try(sc1500[i] <- read.table(paste(i,"_50_2500_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr1500[i] <- read.table(paste(i,"_50_2500_coverage_DropRandom.dat",sep=''))[[1]])

	try(sc2000[i] <- read.table(paste(i,"_50_5000_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr2000[i] <- read.table(paste(i,"_50_5000_coverage_DropRandom.dat",sep=''))[[1]])

	try(sc2500[i] <- read.table(paste(i,"_50_10000_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr2500[i] <- read.table(paste(i,"_50_10000_coverage_DropRandom.dat",sep=''))[[1]])
}

sc500 <- sc500[!is.na(sc500)]
dr500 <- dr500[!is.na(dr500)]

sc1000 <- sc1000[!is.na(sc1000)]
dr1000 <- dr1000[!is.na(dr1000)]

sc1500 <- sc1500[!is.na(sc1500)]
dr1500 <- dr1500[!is.na(dr1500)]

sc2000 <- sc2000[!is.na(sc2000)]
dr2000 <- dr2000[!is.na(dr2000)]

sc2500 <- sc2500[!is.na(sc2500)]
dr2500 <- dr2500[!is.na(dr2500)]

######################################

sc500 <- t.test(sc500)
dr500 <- t.test(dr500)

sc1000 <- t.test(sc1000)
dr1000 <- t.test(dr1000)

sc1500 <- t.test(sc1500)
dr1500 <- t.test(dr1500)

sc2000 <- t.test(sc2000)
dr2000 <- t.test(dr2000)

sc2500 <- t.test(sc2500)
dr2500 <- t.test(dr2500)

sc_tt <- rbind(
	c(sc500$conf.int[1], sc500$estimate , sc500$conf.int[2]),
	c(sc1000$conf.int[1], sc1000$estimate , sc1000$conf.int[2]),
	c(sc1500$conf.int[1], sc1500$estimate , sc1500$conf.int[2]),
	c(sc2000$conf.int[1], sc2000$estimate , sc2000$conf.int[2]),
	c(sc2500$conf.int[1], sc2500$estimate , sc2500$conf.int[2])
)

dr_tt <- rbind(
	c(dr500$conf.int[1], dr500$estimate , dr500$conf.int[2]),
	c(dr1000$conf.int[1], dr1000$estimate , dr1000$conf.int[2]),
	c(dr1500$conf.int[1], dr1500$estimate , dr1500$conf.int[2]),
	c(dr2000$conf.int[1], dr2000$estimate , dr2000$conf.int[2]),
	c(dr2500$conf.int[1], dr2500$estimate , dr2500$conf.int[2])
)

comparisonMatrix <- 1-(dr_tt/sc_tt) 

write.csv(comparisonMatrix, file="Time-coverage (Comparison Matrix SC vs DR).csv")

##########################################################################
y_lim <- c(min(0,sc_tt, dr_tt), max(sc_tt, dr_tt, 100))
x <- c(1,2,3,4,5)

setEPS()
postscript("graphic_varyTimeCoverage.eps")

plot(x, sc_tt[,2] ,ylim=y_lim, type='b', pch=4, col='black', ylab='Coverage (%)', xlab='Walking  Time (seconds).', xaxt="n")
axis(1, at=x, labels=c("250","1000","2500","5000","10000"))
legend("topright", legend=c("Data-Aware Drop", "Random Packet Drop"), lty=1, col=c("black","red", "blue", "green", "gray"), bty="n", pch=c(4,5,6))

#matplot(x, type = "n", ylab='Erro', xlab='% dos dados', xlim = y_lim, axes = FALSE)
#matpoints(, sc_tt[,2],  pch = 4, col = 1, cex=1.2)
arrows(x, sc_tt[,1], x, sc_tt[,3], length = .05, angle = 90, code = 3) 
segments(x, sc_tt[,1], x, sc_tt[,3])
#lines(1:length(x), sc_tt[,1], lty = i, lwd = 1.5) 

points(x, dr_tt[,2], type='b', pch=5, col='red')
points(x, dr_tt[,1], type='p', pch="-", col='red')
points(x, dr_tt[,3], type='p', pch="-", col='red')
segments(x, dr_tt[,1], x, dr_tt[,3], col='red')

dev.off()

