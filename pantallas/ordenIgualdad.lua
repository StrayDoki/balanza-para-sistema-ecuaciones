require('clases/formas')
ordenIgualdad={}

local cadenas = {
  titulo = [[MÉTODO POR IGUALACIÓN]],
  boton = [[ATRAS]],
  fichas = {
    [[Multiplicar]],
    [[Despejar x]],
    [[Despejar y]],
    [[Resolver]],
    [[Reemplazar]],
    [[Igualar]],
  }
}

local cfg = {
  textoColor = {0,0,0,1},
  tamañoTitulo = 40,
  alturaTitulo = 80,
  bloque_ancho = 200,
  bloque_alto = 100,
  bloque_color = {1,1,1,1},
  bloque_borde = 5,
  bloque_borde_color = {0,0,0,1},
  ficha_color = {0.3,0.3,1},
  fila_1 = 200,
  fila_2 = 350,
  fila_3 = 500,
  separacion = 50,
  num_bloques = 3,
  num_fichas = 3,
  boton = {
    ancho = 150,
    largo = 50,
    distancia = 50,
    color = {0.2,0.8,0.2},
    tamaño_texto,
    borde = 3,
    color_texto = {0,0,0,1},
    color_borde = {0,0,0,1}
  }
}

local fichas
local triangulos

function ordenIgualdad.load()
  --CREAR BOTON
  boton_atras = crearBoton(
    love.graphics.getWidth() - cfg.boton.distancia - cfg.boton.ancho,
    love.graphics.getHeight() - cfg.boton.distancia - cfg.boton.largo,
    cfg.boton.ancho,
    cfg.boton.largo,
    cfg.boton.color,
    cadenas.boton,
    cfg.boton.tamaño_texto,
    cfg.boton.color_texto,
    cfg.boton.borde,
    cfg.boton.color_borde
  )

  --CREAR FICHAS
  fichas = {}
  local inicioFicha = (
    love.graphics.getWidth()/2
    - cfg.bloque_ancho*cfg.num_fichas/2
    - cfg.separacion*(cfg.num_fichas-1)/2
  ) 
  for i=1, cfg.num_fichas do
    fichas[i] = {
      x=inicioFicha + cfg.bloque_ancho/2 + (i-1)*(cfg.bloque_ancho+cfg.separacion),
      y=cfg.fila_2,
      baseX = inicioFicha + cfg.bloque_ancho/2 + (i-1)*(cfg.bloque_ancho+cfg.separacion),
      baseY = cfg.fila_2,
      texto = cadenas.fichas[i],
      estado = "reposo"
    }
  end
  for i=1, cfg.num_fichas do
    fichas[i+cfg.num_fichas] = {
      x=inicioFicha + cfg.bloque_ancho/2 + (i-1)*(cfg.bloque_ancho+cfg.separacion),
      y=cfg.fila_3,
      texto = cadenas.fichas[i+cfg.num_fichas]
    }
  end

  --CREAR TRIANGULOS
  triangulos = {}
  local inicioTriangulo = (
    love.graphics.getWidth()/2
    - (cfg.num_bloques-1)*(cfg.bloque_ancho+cfg.separacion)/4
  )
  for i=1, cfg.num_bloques-1 do
    triangulos[i] = inicioTriangulo + (i-1)*(cfg.bloque_ancho+cfg.separacion)
  end
end  

function ordenIgualdad.update()
  --FICHAS UPDATE
  for i=1, #fichas do
    if fichas[i].estado == "reposo" then
      fichas[i].x = fichas[i].baseX
      fichas[i].y = fichas[i].baseY
    elseif fichas[i].estado == "seguir" then
      fichas[i].x = love.mouse.getX()
      fichas[i].y = love.mouse.getY()
    end
  end
  
  --BOTON UPDATE
  boton_atras.update(
    love.mouse.getX(),
    love.mouse.getY()
  )
end

function ordenIgualdad.draw()
  --DIBUJAR TITULO
  dibujarTexto(
    cadenas.titulo,
    love.graphics.getWidth()/2,
    cfg.alturaTitulo/2,
    cfg.tamañoTitulo,
    cfg.textoColor
  )

  --DIBUJAR BLOQUES
  for i=1, cfg.num_bloques do
    dibujarCaja(
      love.graphics.getWidth()/2 - cfg.bloque_ancho*cfg.num_bloques/2 - cfg.separacion*(cfg.num_bloques-1)/2 + (i - 1)*(cfg.bloque_ancho + cfg.separacion) ,
      cfg.fila_1 - cfg.bloque_alto/2,
      cfg.bloque_ancho,
      cfg.bloque_alto,
      cfg.bloque_color,
      nil,nil,nil,
      cfg.bloque_borde,
      cfg.bloque_borde_color
    )
  end

  --DIBUJAR FICHAS
  for i=1, #fichas do
    dibujarCaja (
      fichas[i].x - cfg.bloque_ancho/2,
      fichas[i].y - cfg.bloque_alto/2,
      cfg.bloque_ancho,
      cfg.bloque_alto,
      cfg.ficha_color,
      fichas[i].texto,
      cfg.bloque_alto*0.3
    )
  end

  --DIBUJAR TRIANGULOS
  love.graphics.setColor(cfg.textoColor)
  for i=1, #triangulos do
    love.graphics.polygon(
      "fill",
      triangulos[i] - cfg.separacion/4,
      cfg.fila_1 - cfg.bloque_alto/4,
      triangulos[i] - cfg.separacion/4,
      cfg.fila_1 + cfg.bloque_alto/4,
      triangulos[i] + cfg.separacion/4,
      cfg.fila_1
    )
  end

  --DIBUJAR BOTON RETROCESO
  boton_atras.draw()
end

function ordenIgualdad.mousepressed(x,y)
  for i=1, #fichas do
    if fichaEstaSeleccionada(x,y,fichas[i].x,fichas[i].y,cfg.bloque_ancho,cfg.bloque_alto) then
      fichas[i].estado = "seguir"
    end
  end

  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

function fichaEstaSeleccionada(curX,curY,x,y,width,height)
  return (
    curX > x - width/2 and
    curX < x + width/2 and
    curY > y - height/2 and
    curY < y + height/2
  )
end