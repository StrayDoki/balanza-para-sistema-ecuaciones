require('clases/caja')

function crearBalanza(x,y,tamaño,grosor, color, borde)
  local balanza = {
    x = x,
    y = y,
    tamaño = tamaño,
    grosor = grosor,
    color = color,
    borde = borde or 0,
    angulo = 0,
    estado = "reposo",
    bolasA = {},
    bolasB = {}
  }

  function balanza.getA()
    local punto = {
      x = balanza.x - (balanza.tamaño/2 - balanza.grosor/2)*math.cos(balanza.angulo),
      y = balanza.y - balanza.tamaño/2 + balanza.grosor/2 - (balanza.tamaño/2 - balanza.grosor/2)*math.sin(balanza.angulo)
    }
    return punto
  end

  function balanza.getB()
    local punto = {
      x = balanza.x + (balanza.tamaño/2 - balanza.grosor/2)*math.cos(angulo),
      y = balanza.y - balanza.tamaño/2 + balanza.grosor/2 + (balanza.tamaño/2 - balanza.grosor/2)*math.sin(angulo)
    }
    return punto
  end

  function balanza.actualizar()
    local pesoA = 0
    local pesoB = 0
    for i=1, #balanza.bolasA do
      pesoA = pesoA + balanza.bolasA[i].peso
    end
    for i=1, #balanza.bolasB do
      pesoB = pesoB + balanza.bolasB[i].peso
    end

    if pesoA > pesoB then
      balanza.estado = "pesoenA"
    elseif pesoB > pesoA then
      balanza.estado = "pesoenB"
    elseif pesoA == pesoB then
      balanza.estado = "pesoIgual"
    end
  end

  function balanza.update(dt)
    if balanza.estado == "reposo" then
      balanza.angulo = 0
    elseif balanza.estado == "reposoA" then
      balanza.angulo = -1/2
    elseif balanza.estado == "reposoB" then
      balanza.angulo = 1/2
    elseif balanza.estado == "pesoenA" then
      if balanza.angulo - dt < -1/2 then
        balanza.estado = "reposoA"
      else
        balanza.angulo = balanza.angulo - dt
      end
    elseif balanza.estado == "pesoenB" then
      if balanza.angulo + dt > 1/2 then
        balanza.estado = "reposoB"
      else
        balanza.angulo = balanza.angulo + dt
      end
    elseif balanza.estado == "pesoIgual" then
      if dt > math.abs(balanza.angulo) then
        balanza.estado = "reposo"
      else
        balanza.angulo = balanza.angulo - math.abs(balanza.angulo)/balanza.angulo * dt
      end
    end
  end

  function balanza.draw()
    local puntos ={
      {
        x = balanza.x,
        y = balanza.y - balanza.tamaño/2 + balanza.grosor/2
      },
      {
        x = balanza.x,
        y = balanza.y + balanza.tamaño/2 - balanza.grosor/2
      },
      {
        x = balanza.x - (balanza.tamaño/2 - balanza.grosor/2)*math.cos(balanza.angulo),
        y = balanza.y - balanza.tamaño/2 + balanza.grosor/2 - (balanza.tamaño/2 - balanza.grosor/2)*math.sin(balanza.angulo)
      },
      {
        x = balanza.x + (balanza.tamaño/2 - balanza.grosor/2)*math.cos(balanza.angulo),
        y = balanza.y - balanza.tamaño/2 + balanza.grosor/2 + (balanza.tamaño/2 - balanza.grosor/2)*math.sin(balanza.angulo)
      }
    }
    
    dibujarCajaRedonda(balanza.x,balanza.y,balanza.grosor,balanza.tamaño,balanza.grosor/2,balanza.color,balanza.borde)
    dibujarCajaRedonda(puntos[2].x,puntos[2].y,balanza.tamaño/2,balanza.grosor,balanza.grosor/2,balanza.color,balanza.borde)
    
    love.graphics.push()
    love.graphics.translate(puntos[1].x, puntos[1].y)
    love.graphics.rotate(balanza.angulo)
    dibujarCajaRedonda(0,0,balanza.tamaño,balanza.grosor,balanza.grosor/2,balanza.color,balanza.borde)
    love.graphics.pop()

    love.graphics.line(puntos[3].x,puntos[3].y,puntos[3].x,puntos[3].y+balanza.tamaño/2)
    love.graphics.line(puntos[3].x,puntos[3].y,puntos[3].x-balanza.tamaño/4,puntos[3].y+balanza.tamaño/2)
    love.graphics.line(puntos[3].x,puntos[3].y,puntos[3].x+balanza.tamaño/4,puntos[3].y+balanza.tamaño/2)
    love.graphics.line(puntos[4].x,puntos[4].y,puntos[4].x,puntos[4].y+balanza.tamaño/2)
    love.graphics.line(puntos[4].x,puntos[4].y,puntos[4].x-balanza.tamaño/4,puntos[4].y+balanza.tamaño/2)
    love.graphics.line(puntos[4].x,puntos[4].y,puntos[4].x+balanza.tamaño/4,puntos[4].y+balanza.tamaño/2)

    dibujarCajaRedonda(puntos[3].x,puntos[3].y+balanza.tamaño/2,balanza.tamaño/2,balanza.grosor/2,balanza.grosor/2,balanza.color,balanza.borde)
    dibujarCajaRedonda(puntos[4].x,puntos[4].y+balanza.tamaño/2,balanza.tamaño/2,balanza.grosor/2,balanza.grosor/2,balanza.color,balanza.borde)

    for i=1, #puntos do
      dibujarCirculo(puntos[i].x,puntos[i].y,balanza.grosor/4,{1,0,0,1},balanza.borde)
    end
  end

  return balanza
end
