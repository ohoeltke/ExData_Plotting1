#set time locate to english default
Sys.setlocale("LC_TIME", "C")

if (!file.exists("data")) {
  dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
localFile <- "./data/power_consumption.zip";

dataDir <- file.path("./data")

# load file to local filesystem
if (!file.exists(localFile)) {
  download.file(fileUrl, destfile = localFile ,method="curl");
}

#unzip
unzip(localFile,exdir='./data')  

#read csv as data-frame
powerConsumption <- read.csv(file.path(dataDir,"household_power_consumption.txt"),header = TRUE,sep=";",na.strings ="?",stringsAsFactors=FALSE)
#convert time column
powerConsumption$Time <- strptime(paste(powerConsumption$Date,powerConsumption$Time,sep=" "),"%d/%m/%Y %H:%M:%S")
#convert date column 
powerConsumption$Date <- as.Date(powerConsumption$Date , "%d/%m/%Y")

#filter by date
powerConsumption <- powerConsumption[powerConsumption$Date %in% as.Date(c('2007-02-01', '2007-02-02')),]

#open file
png(filename="plot4.png", width=480,height=480,bg="transparent")

#create grid
par(mfrow=c(2,2))

#draw plot 1
plot(powerConsumption$Time, powerConsumption$Global_active_power, type="l",ylab="Global Active Power", xlab="")

#draw plot 2
plot(powerConsumption$Time, powerConsumption$Voltage, type="l", ylab="Voltage", xlab="datetime")

#draw plot 3
plot(powerConsumption$Time,powerConsumption$Sub_metering_1,type="l", ylab="Energy sub metering", xlab="")
lines(powerConsumption$Time,powerConsumption$Sub_metering_2, col="red")
lines(powerConsumption$Time,powerConsumption$Sub_metering_3, col="blue")
legend("topright", lty=c(1,1,1), bty="n", col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#draw plot 4
plot(powerConsumption$Time,powerConsumption$Global_reactive_power,type="l", ylab="Global_reactive_power", xlab="datetime")

#close file
dev.off();
