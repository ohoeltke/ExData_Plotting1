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

#unzip if not already unzipped
if (!file.exists(dataDir)) {
  unzip(localFile,exdir='./data')  
}

#read csv as data-frame
powerConsumption <- read.csv(file.path(dataDir,"household_power_consumption.txt"),header = TRUE,sep=";",na.strings ="?",stringsAsFactors=FALSE)
#convert time column
powerConsumption$Time <- strptime(paste(powerConsumption$Date,powerConsumption$Time,sep=" "),"%d/%m/%Y %H:%M:%S")
#convert date column 
powerConsumption$Date <- as.Date(powerConsumption$Date , "%d/%m/%Y")

#filter by date
powerConsumption <- powerConsumption[powerConsumption$Date %in% as.Date(c('2007-02-01', '2007-02-02')),]

#open file
png(filename="plot2.png", width=480,height=480,bg="transparent")
#draw plot
plot(powerConsumption$Time,powerConsumption$Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab="")
#close file
dev.off();
