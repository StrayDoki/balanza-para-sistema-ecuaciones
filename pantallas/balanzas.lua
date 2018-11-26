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

  bolas[1] = crearBola(50,50,20,{1,0.8,0.1},5,50)
end

function balanzas.update(dt)
  scales[1].update(dt)
  bolas[1].update(dt)
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
  bolas[1].mousepressed(x,y)
end

function balanzas.mousereleased(x,y)
  bolas[1].mousereleased(x,y)
end
