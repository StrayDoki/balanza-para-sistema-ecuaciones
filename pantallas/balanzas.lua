require('clases/balanza')
require('clases/bola')

balanzas = {}

local angle

local scales = {}
local bolas = {}

function balanzas.load()
  angle = 0
  scales[1] = crearBalanza(350,200,250,30,{1,0.5,0.1},5)
  scales[2] = crearBalanza(750,200,250,30,{1,0.5,0.1},5)
  scales[3] = crearBalanza(550,500,250,30,{1,0.5,0.1},5)

  --BOLAS DINAMICAS
  bolas[1] = crearBola(70,70,30,{1,0.8,0.1},2,5)
  bolas[3] = crearBola(70,170,30,{1,0.8,0.1},2,4)
  bolas[4] = crearBola(70,270,30,{1,0.8,0.1},2,6) --BOLA 2X
  bolas[6] = crearBola(70,370,30,{1,0.8,0.1},2,1)
  bolas[7] = crearBola(70,470,30,{1,0.8,0.1},2,9)
  bolas[8] = crearBola(70,570,30,{1,0.8,0.1},2,3) --BOLA X

  -- BOLAS ESTATICAS
  bolas[2] = crearBola(70,170,30,{0.1,0.5,1},2,7) --BOLA Y
  bolas[5] = crearBola(70,370,30,{0.1,0.5,1},2,7) --BOLA Y

  --AGREGAR BOLA 2 A LA BALANZA 1 Y ESCONDER PESO
  bolas[2].hidden = "y"
  bolas[2].estado = "en plato"
  scales[1].add(bolas[2],2,"B")
  bolas[2].estatico = true

  --AGREGAR BOLA 5 A LA BALANZA 2 Y ESCONDER PESO
  bolas[5].hidden = "y"
  bolas[5].estado = "en plato"
  scales[2].add(bolas[5],5,"B")
  bolas[5].estatico = true

  --ESCONDER PESO DE BOLA 4
  bolas[4].hidden = "2x"
  --ESCONDER PESO DE BOLA 6
  bolas[8].hidden = "x"
end

function balanzas.update(dt)
  for i=1, #scales do
    scales[i].update(dt)
  end

  

  --BOLA UPDATE
  for i=1, #bolas do
    if bolas[i].estado=="reposo" then
      bolas[i].x=bolas[i].basex
      bolas[i].y=bolas[i].basey
    elseif bolas[i].estado=="seguir" then
      bolas[i].x=love.mouse.getX()
      bolas[i].y=love.mouse.getY()
    elseif bolas[i].estado == "en plato" then
      local ubicacion = "NO"

      for j=1, #scales do
        if scales[j].buscar(i)~="NO" then
          ubicacion = {
            balanza = j,
            plato = scales[j].buscar(i),
            lugar = scales[j].buscar(i,"lugar")
          }
        end
      end

      if ubicacion.plato == "A" then
        bolas[i].x=scales[ubicacion.balanza].getA().x
        bolas[i].y=scales[ubicacion.balanza].getA().y - ubicacion.lugar * bolas[i].radio - (ubicacion.lugar-1)*bolas[i].radio
      elseif ubicacion.plato == "B" then
        bolas[i].x=scales[ubicacion.balanza].getB().x
        bolas[i].y=scales[ubicacion.balanza].getB().y - ubicacion.lugar * bolas[i].radio - (ubicacion.lugar-1)*bolas[i].radio
      end
    end
  end
end

function balanzas.draw()
  for i=1, #scales do
    scales[i].draw()
  end
  for i=1, #bolas do
    bolas[i].draw()
  end
end

function balanzas.mousepressed(x,y)
  for i=1, #bolas do
    if not bolas[i].estatico then 
      if bolas[i].isSelected(x,y)==true then
        for j=1, #scales do
          local plato = scales[j].buscar(i)
          if plato ~= "NO" then
            print("borrando")
            scales[j].remove(i, plato)
            print (#scales[1].bolasA)
            for k=1, #scales[1].bolasA do
              print(scales[1].bolasA[k].id)
            end
          end
        end

        bolas[i].estado = "seguir"

        break
      end
    end
  end

  for i=1, #scales do
    scales[i].actualizar()
  end
end

function balanzas.mousereleased(x,y)
  for i=1, #bolas do
    if not bolas[i].estatico then
      if bolas[i].isSelected(x,y)==true then
        local ubicacion = estaEnBalanza(bolas[i])
        if ubicacion ~= "NO" then
          bolas[i].estado = "en plato"
          scales[ubicacion.balanza].add(bolas[i],i,ubicacion.plato)
        else
          bolas[i].estado = "reposo"
        end
      end
    end
  end

  for i=1, #scales do
    scales[i].actualizar()
  end
end

function estaEnBalanza(self)
  local enBalanza = "NO"

  for i=1, #scales do
    local distancia = 2*(#scales[i].bolasA + 1)*self.radio
    if self.x>scales[i].getA().x - scales[i].tamaño/4  and 
      self.x<scales[i].getA().x + scales[i].tamaño/4 and
      self.y>scales[i].getA().y - distancia and
      self.y<scales[i].getA().y + distancia/4
    then
      enBalanza = {
        balanza = i,
        plato = "A"
      }
    end
  end

  if enBalanza == "NO" then
    for i=1, #scales do
      local distancia = 2*(#scales[i].bolasB + 1)*self.radio
      if self.x>scales[i].getB().x - scales[i].tamaño/4 and 
        self.x<scales[i].getB().x + scales[i].tamaño/4 and
        self.y>scales[i].getB().y - distancia and
        self.y<scales[i].getB().y + distancia/4
      then
        enBalanza = {
          balanza = i,
          plato = "B"
        }
      end
    end
  end

  return enBalanza
end