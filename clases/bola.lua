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
    estatico=false,
    hidden = nil
  }

  function bola.draw()
    dibujarCirculo(bola.x,bola.y,bola.radio,bola.color,bola.borde,bola.hidden or bola.peso,bola.radio*1.3,{0,0,0,1})
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

  return bola
end