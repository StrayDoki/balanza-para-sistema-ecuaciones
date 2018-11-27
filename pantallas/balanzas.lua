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

  bolas[1] = crearBola(70,70,30,{1,0.8,0.1},2,4)
  bolas[2] = crearBola(70,170,30,{1,0.8,0.1},2,3)
end

function balanzas.update(dt)
  for i=1, #scales do
    scales[i].update(dt)
  end
  for i=1, #bolas do
    bolas[i].update(dt,scales)
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
    bolas[i].mousepressed(x,y)
  end
end

function balanzas.mousereleased(x,y)
  for i=1, #bolas do
    if bola.isSelected(x,y)==true then
      --corregir orden
      for i=1, #balanzas do
        if bola.estaEnBalanza(scales[i]) == "A" then
          bola.estado = {
            balanza = i,
            plato = "A"
          }
        else
          bola.estado = "reposo"
        end
      end
    end
  end
end

function estaEnBalanza()
  local enBalanza = "NO"
  local distancia = 2*(#balanza.bolasA + 1)*bola.radio
  
  if bola.x>balanza.getA().x and 
    bola.x<balanza.getA().x + distancia and
    bola.y>balanza.getA().y - balanza.tamaño/4 and
    bola.y<balanza.getA().y + balanza.tamaño/4
  then
    enBalanza = "A"
  end

  return enBalanza
end