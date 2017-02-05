#Titulo: Programa componente-entidad sistema
#Autor: Jorge Carvajal
#Licencia: que role
#Fecha: 2/4/2017

#DEFININION DE CONSTANTES
##Definimos una constante para cada componente que habra en nuestro sistema
## n << m aplica un shift de m posiciones al numero n. Visto en binario:

C_NONE = 0
C_POINT = 1 << 0	## int 1 , bin 0000001
C_AUTOINCREMENT = 1 << 1 ## int 2 , bin 0000010
C_SPRITE = 1 << ## int 4 , bin 0000100
C_RECTANGLE = 1 << 3 ## int 8 , bin 00001000
C_VELOCITY = 1 << 4 ## int 16 , bin 00010000
C_INPUT = 1 << 5 ## int 32 , bin 00100000
C_ACCELERATION = 1 << 6 ## int 64 , bin 01000000
C_COLLISION = 1 << 7 ## int 128 , bin 1000000
C_MAX = 10

require 'gosu' #framework de juegos 2D
#SECCION DE COMPONENTES

##Los componentes contienen informacion usada para describir un algo,
## la cual podra ser leida y modificada a lo largo de la ejecucion
## del programa (Notese que todos los atributos son publicos)

#Componente Punto
class Point 
	def initialize(x = 0, y = 0)
		@x = x
		@y = y
	end
	attr_accessor :x
	attr_writer :x
	attr_accessor :y
	attr_accessor :y
end

#Componente Rectangulo
class Rectangle
	def initialize(width,height)
		@width = width
		@height = height
	end
	attr_accessor :width
	attr_writer :width
	attr_accessor :height
	attr_accessor :height
end

#Componente Autoincrementable
class AutoIncrement
	def initialize(amount = 1)
		@amount = amount
	end
	attr_accessor :amount
	attr_writer :amount
end

#Componente Sprite
class Sprite
	def initialize(image)
		@image = Image
	end
end

#Componente Velocidad
class Velocity 
	def initialize(x = 0, y = 0)
		@x = x
		@y = y
	end
	attr_accessor :x
	attr_writer :x
	attr_accessor :y
	attr_accessor :y
end
#ENTIDADES

##Las entidades son contenedores de uno o mas componentes,
## es decir, las entidades se definen por la composicion de 
## los componentes que contiene. En esencia solo se manejaran
## a traves de un identificador (id).

#CLASE MUNDO

##La clase mundo contiene un 'struct de listas'.
## tendremos un arreglo de 'mascaras', donde el indice indica
## cual entidad estamos tratando, y el valor dentro del arreglo
## nos indica precisamente de que componentes esta compuesto la entidad
## asociada a ese indice.

##Si el valor del arreglo en el indice 'i' es '0', significa
## que no hay componentes, es decir, para el proposito de esta implementacion
## es una celda sin una entidad asociada. 
## De otra forma, los demas arreglos en el mundo corresponden a las componentes
## que estan asociados a la entidad en el indice correspondiente, con sus valores.

#CREACION DE UNA MASCARA

##Para crear una mascara,se utiliaza el operador bitwise 'or' : |,
## para juntar todas las componentes que compondran a una entidad.

##Ejemplo:

## Una clase con punto, rectangulo y sprite se ve de la siguiente manera

## 00000001 punto
## 00000100 sprite
## 00001000 rectangulo 
## ----
## 00001101 <- mascara
class World
	def initialize()
		@mask = [C_NONE]*C_MAX
		@point = [nil]*C_MAX
		@autoIncrement = [nil]*C_MAX
		@sprite = [nil]*C_MAX
		@rectangle = [nil]*C_MAX
		@velocity = [nil]*C_MAX
		@collision = [nil]*C_MAX
		@acceleration = [nil]*C_MAX
	end
	#addEntity:

	##Encuentra la primer celda con valor 0
	## y regresa el indice correspondiente del arreglo
	def addEntity()
		i = 0
		while i < C_MAX
			if @mask[i] == C_NONE
				return i
			end
			i+=1
		end
	end
	#removeComponent(id_entidad,componente)

	##Remueve el componente recibido de la mascara 
	## en el lugar 'id_entidad' del arreglo de mascaras
	def removeComponent(entity_id,component)
		if @mask[entity_id]&component = component
			@mask[entity_id]-=component
		end
	end
	#addComponente(id_entidad,componente)

	##Añade el componente recibido de la mascara 
	## en el lugar 'id_entidad' del arreglo de mascaras
	def addComponent(entity_id,component)
		if @mask[entity_id]&component != component
			@mask[entity_id] =  @mask[entity_id] | component
		end
	end
	#addPlayer(posicion x,posicion y, alto, ancho, ruta_sprite,velocidad x, velocidad y)

	##Especializacion de addPlayer, para añadir un jugador
	## a la lista de entidades

	##Componentes del jugador = punto+sprite+rectangulo+input+velocidad+aceleracion+colision
	def addPlayer(x,y,width,height,path,xvel=2,yvel=2)

		i = addEntity()
		#print i
		@mask[i] = C_POINT|C_SPRITE|C_RECTANGLE|C_INPUT|C_VELOCITY|C_ACCELERATION|C_COLLISION
		@sprite[i] = Gosu::Image.new(path)
		@point[i] =  Point.new(x,y)
		@rectangle[i] = Rectangle.new(width,height)
		@velocity[i] = Velocity.new(xvel,yvel)
		#@acceleration[i] = Gravity.new()
		return i
	end
	attr_accessor :mask
	attr_writer :mask
	attr_accessor :point
	attr_writer :point
	attr_accessor :autoIncrement
	attr_writer :autoIncrement
	attr_accessor :sprite
	attr_writer :sprite
	attr_accessor :rectangle
	attr_writer :rectangle
	attr_accessor :velocity
	attr_writer :velocity
end
#SECCION DE SISTEMAS

##Un sistema es una funcion que actua sobre entidades
## que cuentan con un conjunto especifico de componentes.
## para hacer esto, utilizan la operacion bitwise 'and' &
## para asi ver cuales componentes coinciden contra un conjunto
## ya determinado

##ejemplo de comparacion

## entidad = 				 101011011
## conjunto de componentes = 000010011
## resultado de &           -----------
## => 						 000010011

##Si conjunto de componentes = resultado de la operacion, el sistema
## puede actuar sobre la entidad en cuestion

##movement_system(mundo,botonesPresionados)

##Recibiendo el mundo y botones presionados,
## el sistema analiza el input del usuario
## y mueve a las entidades usando la velocidad
## asociada en dicho componentes

##NOTA: botonesPresionados es recibido como parametro,
## pero una implementacion mas adecuada deberia de 
## tratar con los inputs dentro del componente 'INPUT'
## de cada entidad
def movement_system(world,toggledButtons)
	identifier = C_POINT+C_VELOCITY+C_INPUT
	for i in 0...C_MAX
		if world.mask[i] & identifier == identifier
			toggledButtons.each do |id|
				if id == Gosu::KbW
					world.point[i].y-=world.velocity[i].y
				end
				if id == Gosu::KbS
					world.point[i].y+=world.velocity[i].y
				end
				if id == Gosu::KbA
					world.point[i].x-=world.velocity[i].x
				end
				if id == Gosu::KbD
					world.point[i].x+=world.velocity[i].x
				end
			end
		end
	end
end
#draw_system(mundo)

##Recibe el mundo y dibuja el sprite asociado a
## la entidad en su posicion correspondiente
def draw_system(world)
	identifier = C_SPRITE+C_POINT
	for i in 0...C_MAX
		if world.mask[i] & identifier == identifier
			world.sprite[i].draw(world.point[i].x,world.point[i].y,0,0.1,0.1,Gosu::Color.argb(0xff_FFFF00))
		end
	end
end

#Implementacion del juego
class GameWindow < Gosu::Window

	
	def initialize(width = 800, height = 600, fullscreen = false)
		super
		self.caption = "Yo"
		@VERTEX_SIZE = 50
		@string = "1"
		@vertexes = []
		@world = World.new()
		@message = Gosu::Image.from_text(self,@string, Gosu.default_font_name,30)
		@toggledButtons = []
		@menes = []
		for i in 0...5
			@menes.push(@world.addPlayer(20+i*80,20+i*40,100,100,"men.png",i,i))
			@menes.push(@world.addPlayer(20+i*40,20+i*80,100,100,"men.png",i,i))
		end

	end
	def update
		@string = (@string.to_i + 1).to_s
		if @toggledButtons.size > 0
			movement_system(@world,@toggledButtons)
		end
		@message = Gosu::Image.from_text(self,@string, Gosu.default_font_name,30)
		
	end
	def button_down(id)
    	close if id == Gosu::KbEscape
    	@toggledButtons.push(id)
    	if id == Gosu::KbJ
    		@menes.each do |men|
    			#ejemplo de removida dinamica de componentes
    			@world.removeComponent(men,C_VELOCITY)
    		end
    	end

   	end
 	def button_up(id)
 		if id == Gosu::KbJ
 			@menes.each do |men|
 				#ejemplo de insertado dinamico de componentes
    			@world.addComponent(men,C_VELOCITY)
    		end
    	end
    	@toggledButtons.delete(id)
   	end
 
   	def needs_cursor?
   		true
   	end
   	
	def draw
		Gosu::draw_rect(0,0,800,600,Gosu::Color.argb(0xff_6495ED))
		@message.draw(10,10,0)
		draw_system(@world)
	end
end
GameWindow.new.show