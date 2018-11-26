function crearTexto(_texto, x, y, size, color)
  local texto = {_texto, x, y, size}

  function texto.draw ()
    local font = love.graphics.newFont(size)
    local width = font:getWidth(texto)
    local height = font:getHeight(texto)
    font:setFilter('nearest', 'nearest')
    love.graphics.setFont(font)
    love.graphics.setColor(color or {1,1,1,1})
    love.graphics.print(texto,x,y,0,1,1,width/2,height/2)
  end
end

function dibujarTexto(texto, x, y, size, color)
  local font = love.graphics.newFont(size or 24)
  local width = font:getWidth(texto)
  local height = font:getHeight(texto)
  font:setFilter('nearest', 'nearest')
  love.graphics.setFont(font)
  love.graphics.setColor(color or {1,1,1,1})
  love.graphics.print(texto,x,y,0,1,1,width/2,height/2)
end