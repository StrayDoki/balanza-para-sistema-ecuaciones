require 'pantallas/titulo'

local pantalla = {}

function cambiarPantalla(p)
  pantalla = p
  if pantalla.load ~= nil then
    pantalla.load()
  end
end

function love.load()
  cambiarPantalla(titulo)
end

function love.update(dt)
  if pantalla.update ~= nil then
    pantalla.update(dt)
  end
end

function love.draw()
  if pantalla.draw ~= nil then
    pantalla.draw()
  end
end

function love.mousepressed(x,y,button)
  if button ~= 1 then
    return
  end

  if pantalla.mousepressed ~= nil then
    pantalla.mousepressed(x,y)
  end
end

function love.mousereleased(x,y,button)
  if button ~= 1 then
    return
  end

  if pantalla.mousereleased ~= nil then
    pantalla.mousereleased(x,y)
  end
end


