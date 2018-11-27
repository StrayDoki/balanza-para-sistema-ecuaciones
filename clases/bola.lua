require('clases/caja')

function crearBola(x,y,radio,color,borde,peso)
  local bola = {
    x=x,
    basex=x,
    y=y,
    basey=y,
    radio=radio,
    color=color,
    borde=borde,
    peso=peso or 1,
    estado="reposo",
    offset = {
      x=0,
      y=0
    }
  }

  function bola.update(dt,balanzas)
    if bola.estado=="reposo" then
      bola.x=bola.basex
      bola.y=bola.basey
    elseif bola.estado=="seguir" then
      bola.x=love.mouse.getX() + bola.offset.x
      bola.y=love.mouse.getY() + bola.offset.y
    else
      if bola.estado.plato == "A" then
        bola.x=balanzas[bola.estado.balanza].getA().x
        bola.y=balanzas[bola.estado.balanza].getA().y
      end
    end
  end

  function bola.draw()
    dibujarCirculo(bola.x,bola.y,bola.radio,bola.color,bola.borde,bola.peso,bola.radio*1.3,{0,0,0,1})
  end

  function bola.isSelected(x,y)
    local isSelected = false
    local distanceX = bola.x - x
    local distanceY = bola.y - y
  
    if distanceX^2 + distanceY^2 < bola.radio^2 then
      isSelected = true
    end 

    return isSelected
  end

  function bola.mousepressed(x,y)
    if bola.isSelected(x,y)==true then
      bola.offset = {
        x=bola.x - x,
        y=bola.y - y
      }
      bola.estado = "seguir"
    end
  end

  return bola
end