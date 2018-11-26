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

  function bola.update(dt)
    if bola.estado=="reposo" then
      bola.x=bola.basex
      bola.y=bola.basey
    elseif bola.estado=="seguir" then
      bola.x=love.mouse.getX() + bola.offset.x
      bola.y=love.mouse.getY() + bola.offset.y
    end
  end

  function bola.draw()
    dibujarCirculo(bola.x,bola.y,bola.radio,bola.color,bola.borde,20,bola.peso,20,{0,0,0,1))
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

  function bola.mousereleased(x,y)
    if bola.isSelected(x,y)==true then
      bola.estado = "reposo"
    end
  end

  return bola
end