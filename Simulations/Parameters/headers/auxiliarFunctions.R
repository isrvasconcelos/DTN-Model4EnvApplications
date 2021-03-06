# Gera a figura do campo observado, considerando uma matrix ou um geoR
GerarFigura <- function(name_, dados_, geoDados_){
  if(missing(geoDados_)){
    dadosPlot = dados_
  } else { # Transformação dos dados geoR em matrix
    size = length(geoDados_$data)
    dadosPlot = matrix(nrow = maxX, ncol = maxX)
    for(i in 1:size){
      x_ = trunc(geoDados_$coords[i,1])
      y_ = trunc(geoDados_$coords[i,2])
      dadosXY = geoDados_$data[i]
      dadosPlot[x_,y_] <- dadosXY
    }
  }
  # Desenhando o campo como um gráfico.
  graphics.off()
  postscript(name_,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
  image(dadosPlot,col=gray((1:32)/32), xaxt="n", yaxt="n", xlab="", ylab="")
  graphics.off()
}

GerarFiguraRedPalette <- function(name_, dados_, geoDados_){
  if(missing(geoDados_)){
    dadosPlot = dados_
  } else { # Transformação dos dados geoR em matrix
    size = length(geoDados_$data)
    dadosPlot = matrix(nrow = maxX, ncol = maxX)
    for(i in 1:size){
      x_ = trunc(geoDados_$coords[i,1])
      y_ = trunc(geoDados_$coords[i,2])
      dadosXY = geoDados_$data[i]
      dadosPlot[x_,y_] <- dadosXY
    }
  }
  # Desenhando o campo como um gráfico.
  graphics.off()
  postscript(name_,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
  image(dadosPlot,xaxt="n", yaxt="n", xlab="", ylab="")
  graphics.off()
}

#################################################################################################
## Israel (02/2015) ##

# Gera imagem referente a distribuição com SSI dos sensores no campo
GerarFiguraSSI <- function(name_, sensores) {

	xcoords <- ceiling(sensores$x)
	ycoords <- ceiling(sensores$y)

	fieldMatrix <- matrix(1, nrow=maxX, ncol=maxY)

	for(i in 1:length(xcoords)) {
		fieldMatrix[xcoords[i], ycoords[i]] = 0
	}

	graphics.off()
	postscript(name_,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
	image(fieldMatrix, col=gray((1:32)/32), xaxt="n", yaxt="n", xlab="", ylab="")
	graphics.off()

}

printNode <- function(name_, sensores, n) {

	xcoords <- ceiling(sensores$x)
	ycoords <- ceiling(sensores$y)

	fieldMatrix <- matrix(1, nrow=maxX, ncol=maxY)

	fieldMatrix[xcoords[n], ycoords[n]] = 0
	
	print(paste("Sensor nº ", n , ": (",xcoords[n],",",ycoords[n],")"))

	graphics.off()
	postscript(name_,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
	image(fieldMatrix,col=gray((1:32)/32))
	graphics.off()
}

#Corrigido
#Israel (02/2015)
GerarFiguraVoronoi <- function(name_, sensores){
	voronoiMatrix = matrix(nrow = maxX, ncol = maxY)
	dadosPlot = matrix(1,nrow = maxX, ncol = maxY)

	# Obtendo os dados de voronoi
	xcoords = ceiling(sensores$x)
	ycoords = ceiling(sensores$y)

	fieldMatrix <- matrix(1, nrow=maxX, ncol=maxY)

	for(i in 1:maxX){
		for(j in 1:maxY){
		dist = 99999;

		for(k in 1:n_sensores){
			aux = sqrt((i-xcoords[k])^2 + (j-ycoords[k])^2)
			if(aux < dist){
		  		dist = aux
		  		voronoiMatrix[i, j] = k
				}
			}

		#print(paste("x:",i," / y:",j," / sensor:",voronoiMatrix[i, j]))
		}
		
	cat('\r',format(paste("Printing Voronoi Diagram: ",i, "%", sep='')))
	flush.console() 
	}

	#Filtrando bordas
	for(i in 1:maxX){
		for(j in 1:maxY){

			#Se o valor do pixel atual for diferente do anterior, ele é uma borda.
			if(voronoiMatrix[i,j]!=voronoiMatrix[i-1,j] && i>1) {
				dadosPlot[i,j] = 0
			}

			if(voronoiMatrix[i,j]!=voronoiMatrix[i,j-1] && j>1) {
				dadosPlot[i,j] = 0
			}
		}
	}

	for(i in 1:length(xcoords)) {
		dadosPlot[xcoords[i], ycoords[i]] = 0
	}

	# Desenhando o gráfico de voronoi.
	graphics.off()
	postscript(name_,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
	image(x,y,dadosPlot,col=gray((1:32)/32), xaxt="n", yaxt="n", xlab="", ylab="")
	graphics.off()
	print((paste("Voronoi Diagram: OK!")))
}

#################################################################################################
## Israel (02/2015) ##
## Divide o campo em 100 subsetores (10x10) e calcula quantos são cobertos pelos nós após a redução.

coverage <- function(dadosSampled) {

	sectors <- c(1,11,21,31,41,51,61,71,81,91) # LEMBRAR: CORRIGIR COM X+1, FROM:0/TO:FIELDSIZE-1/BY:10
	dataMatrix <- matrix(0, ncol=100, nrow=100)
	coverageMatrix <- matrix(0, ncol=10, nrow=10)


	num_indexes <- which(is.na(dadosSampled)==FALSE) #Armazena os indices dos valores amostrados
    	for(i in 1:length(num_indexes)) { 
		index <- num_indexes[i] # indices dos valores amostrados
		dataMatrix[index] <- 1
    	} 

	for(i in 1:length(sectors)) {
		for(j in 1:length(sectors)) {
			
			for(x in (sectors[i]):(sectors[i]+9)) { #Varrendo cada setor
				for(y in (sectors[j]):(sectors[j]+9)) {
					
					if(dataMatrix[x,y] == 1) { # Se houver amostras neste ponto, o respectivo setor está coberto
						coverageMatrix[i,j] = 1
					}
				}
			}
		}
	}

	return(coverageMatrix)
}

#################################################################################################
## Alla (2011) ##
readData <- function(sensores, campo, raio=10)
{
  if(missing(sensores)) stop('Falta sensores')
  if(missing(campo)) stop('Falta o campo gaussiano')
  data <- c()
  
  # Para cada sensor, faz a coleta de informação
  for(s in 1:sensores$n)
  {
    # inf -> inferior sup -> superior no caso do disco
    x <- trunc(sensores$x[s])
    y <- trunc(sensores$y[s])
    x_inf <- x - raio
    x_sup <- x + raio
    y_inf <- y - raio
    y_sup <- y + raio
    
    # Ajustando os valores 
    if(x == 0) x <- 1
    if(y == 0) y <- 1
    if(x_inf <= 0) x_inf <- 1
    if(y_inf <= 0) y_inf <- 1
    if(x_sup > 100) x_sup <- 100
    if(y_sup > 100) y_sup <- 100
    
    #print(paste("X e Y ",x," ",y))
    
    #Quantidade de pixels
    quant <- 0
    temp <- 0
    
    # data recebe a integral do campo sobre o disco(x,y,raio)
    for(i in x_inf:x_sup)
      for(j in y_inf:y_sup)
        if((i-x)^2 + (j-y)^2 <= raio^2)
        {
          #print(paste("X e Y ",x," ",y," I e J: ",i," ",j))
          temp <- temp + campo[i,j]
          quant <- quant + 1
        }
    data[s] <- temp/quant
  }
  
  return(data)
}

#Converte para a classe geodata
geo <- function(sensors, data)
{
        if(missing(sensors)) stop('Missing sensors')
        if(missing(data)) stop("Missing sensors' data")
        if(sensors$n != length(data)) stop('#sensors not equal to #data')
        g <- matrix(nrow=sensors$n, ncol=3)
        g[,1] <- sensors$x
        g[,2] <- sensors$y
        g[,3] <- data
        return(as.geodata(g))
}
