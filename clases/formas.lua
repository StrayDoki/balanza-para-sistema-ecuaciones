require('clases/texto')

function dibujarCaja(x,y,width,height,color,texto,size,textoColor,borde,bordeColor)
  local borde = borde or 0
  love.graphics.setColor(color or {1,1,1,1})
  love.graphics.rectangle("fill",x,y,width,height)
  love.graphics.setColor(bordeColor or color)
  love.graphics.setLineWidth(borde or 3)
  love.graphics.rectangle("line",x,y,width,height)
  if texto ~= nil then
    dibujarTexto(
      texto,
      x+width/2,
      y+height/2,
      size,
      textoColor
    )
  end
end

function dibujarCirculo(x,y,radio, color , borde,texto,size,textoColor)
  love.graphics.setColor(color)
  love.graphics.circle(
    "fill",
    x,
    y,
    radio
  )
  love.graphics.setColor({0,0,0,1})
  love.graphics.setLineWidth(borde or 0)
  love.graphics.circle(
    "line",
    x,
    y,
    radio
  )
  if texto ~= nil then
    dibujarTexto(
      texto,
      x,
      y,
      size,
      textoColor
    )
  end
end

function dibujarCajaRedonda(x,y,width,height,radio,color, borde)
  love.graphics.setColor(color)
  love.graphics.rectangle(
    "fill",
    x - width/2,
    y - height/2,
    width,
    height,
    radio
  )
  love.graphics.setColor({0,0,0,1})
  love.graphics.setLineWidth(borde or 0)
  love.graphics.rectangle(
    "line",
    x - width/2,
    y - height/2,
    width,
    height,
    radio
  )
end

function crearBoton(x,y,width,height,color,texto,size,textoColor,borde,bordeColor)
  local boton = {
    x = x,
    y = y,
    width = width,
    height = height,
    color = color,
    texto = texto,
    size = size,
    textoColor = textoColor,
    borde = borde,
    recuerdaBorde = borde,
    bordeColor = bordeColor,
  }

  function boton.draw()
    dibujarCaja(x,y,width,height,color,texto,size,textoColor,borde,bordeColor)
  end

  function boton.estaSeleccionado(curX, curY)
    return (
      curX > x and
      curX < x + width and
      curY > y and
      curY < y + height
    )
  end

  function boton.update(curX, curY)
    if boton.estaSeleccionado(curX, curY)
    then
      bordeColor = boton.color
      borde = boton.recuerdaBorde
      color = {1,1,1,1}
      textoColor = boton.color
    else
      borde = 0
      color = boton.color
      bordeColor = {1,1,1,1}
      textoColor = {1,1,1,1}
    end
  end

  return boton
end