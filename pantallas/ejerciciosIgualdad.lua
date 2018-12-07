ejerciciosIgualdad = {}

local x,y,a,b,c,d,e,f
local pregunta
local botones
local paso
local paso_seleccionado
local linea
local boton_atras
local puntos

function generarPregunta()
  x = love.math.random(2,9)
  y = love.math.random(2,9)
  a = love.math.random(2,9)
  b = love.math.random(2,9)
  c = love.math.random(2,9)
  d = love.math.random(2,9)

  local decidiendo = love.math.random(1,4)
  if decidiendo == 2 then
    b = -1*b
  elseif decidiendo == 3 then
    d = -1*d
  elseif decidiendo == 4 then
    b = -1*b
    d = -1*d
  end

  e = a*x+b*y
  f = c*x+d*y

  local ecuacion_1

  if decidiendo == 1 then
    ecuacion_1 = a.."x + "..b.."y = "..e
    ecuacion_2 = c.."x + "..d.."y = "..f
  elseif decidiendo == 2 then
    ecuacion_1 = a.."x - "..(-1*b).."y = "..e
    ecuacion_2 = c.."x + "..d.."y = "..f
  elseif decidiendo == 3 then
    ecuacion_1 = a.."x + "..b.."y = "..e
    ecuacion_2 = c.."x - "..(-1*d).."y = "..f
  elseif decidiendo == 4 then
    ecuacion_1 = a.."x - "..(-1*b).."y = "..e
    ecuacion_2 = c.."x - "..(-1*d).."y = "..f
  end

  print(x,y)
  return {ecuacion_1, ecuacion_2}
end

function generarBotones()
  local botones = {}
  local n_botones = {}
  local textos = {
    [[Multiplicar]],
    [[Despejar x]],
    [[Despejar y]],
    [[Resolver]],
    [[Reemplazar]],
    [[Igualar]],
  }

  -- generando numeros de boton
  if paso == 1 then
    for i=1, 3 do
      n_botones[i] = love.math.random(1,4)
      if n_botones[i]>1 then
        n_botones[i] = n_botones[i]+2
      end
    end
  elseif paso == 2 then
    for i=1, 3 do
      n_botones[i] = love.math.random(1,5)
    end
  elseif paso == 3 then
    for i=1, 3 do
      n_botones[i] = love.math.random(1,5)
      if n_botones[i]>3 then
        n_botones[i] = n_botones[i]+1
      end
    end
  end

  --generando respuesta correcta
  local n_correcto = love.math.random(1,3)
  if paso == 1 then
    local escoge = love.math.random(2,3)
    n_botones[n_correcto] = escoge
  elseif paso == 2 then
    n_botones[n_correcto] = 6
  elseif paso == 3 then
    n_botones[n_correcto] = 4
  end

  -- creando botones
  for i=1, 3 do
    botones[i] = crearBoton(
      love.graphics.getWidth()/2 - 1.5*200 - 50 + (200+50)*(i-1),
      0, 
      200,
      50,
      {0,0,1},
      textos[n_botones[i]],
      30,
      {1,1,1},
      5,
      {0,0,0}
    )
  end

  botones[1].correcto = false
  botones[2].correcto = false
  botones[3].correcto = false
  botones[n_correcto].correcto = true

  return botones
end

function generarSoluciones()
  local solucion = {}
  local textos = {}
  local botones = {}
  for i=1, 3 do
    local dif_x = 2*(love.math.random(1,2)-1.5)*love.math.random(1,2)
    local dif_y = 2*(love.math.random(1,2)-1.5)*love.math.random(1,2)
    solucion[i] = {
      x = x + dif_x,
      y = y + dif_y
    }
  end

  local solucion_real = love.math.random(1,3)
  solucion[solucion_real] = {
    x=x,
    y=y
  }

  for i=1, 3 do
    textos[i] = "x = ".. solucion[i].x .." , y = ".. solucion[i].y
    print(textos[i])
  end

  for i=1, 3 do
    botones[i] = crearBoton(
      love.graphics.getWidth()/2 - 1.5*250 - 50 + (250+50)*(i-1),
      0, 
      250,
      50,
      {0,0,1},
      textos[i],
      30,
      {1,1,1},
      5,
      {0,0,0}
    )
    botones[i].correcto = false
  end

  botones[solucion_real].correcto = true

  return botones
end

function ejerciciosIgualdad.load()
  botones = {}
  puntos = 0

  paso_seleccionado={}
  pregunta = generarPregunta()
  paso = 1
  botones = generarBotones()

  -- CREAR BOTON ATRAS
  local distancia = 50
  local boton_ancho = 150
  local boton_largo = 50
  boton_atras = crearBoton(
    love.graphics.getWidth() - distancia - boton_ancho,
    love.graphics.getHeight() - distancia - boton_largo,
    boton_ancho,
    boton_largo,
    {0.2,0.2,0.2}, -- color de fondo
    "ATRAS",
    30, -- tamaño de texto
    {1,1,1}, --color de texto
    8
  )
end

function ejerciciosIgualdad.draw()
  linea = 50
  dibujarTexto(
    pregunta[1],
    love.graphics.getWidth()/2,
    linea,
    40,
    {0,0,0}
  )

  linea = 100
  dibujarTexto(
    pregunta[2],
    love.graphics.getWidth()/2,
    linea,
    40,
    {0,0,0}
  )

  linea = 165
  if paso == 1 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 1 then
    linea = 180
    dibujarTexto(
      paso_seleccionado[1],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = 240
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+15)
  end

  linea = 280
  if paso == 2 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 2 then
    linea = 295
    dibujarTexto(
      paso_seleccionado[2],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = 355
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+15)
  end

  linea = 395
  if paso == 3 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 3 then
    linea = 410
    dibujarTexto(
      paso_seleccionado[3],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = 470
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+15)
  end

  linea = 510
  if paso == 4 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 4 then
    linea = 525
    dibujarTexto(
      paso_seleccionado[4],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )
  end

  if paso == 0 then
    print("hola")
    dibujarCaja(
      love.graphics.getWidth()/2 - 200,
      love.graphics.getHeight()/2 - 100,
      400,
      200,
      {1,0,0}, -- color de fondo
      "FALLASTE (PUNTOS: "..puntos..")",
      30, -- tamaño de texto
      {1,1,1}, --color de texto
      8
    )
  end

  if paso == 5 then
    dibujarCaja(
      love.graphics.getWidth()/2 - 100,
      love.graphics.getHeight() - 100,
      200,
      50,
      {0.8,0.4,0}, -- color de fondo
      "¡BIEN!",
      30, -- tamaño de texto
      {0,0,0}, --color de texto
      8
    )
  end

  local distancia = 50
  local boton_ancho = 250
  local boton_largo = 50
  dibujarCaja(
    distancia,
    love.graphics.getHeight() - distancia - boton_largo,
    boton_ancho,
    boton_largo,
    {0.2,0.2,0.2}, -- color de fondo
    "PUNTOS : "..puntos,
    30, -- tamaño de texto
    {1,1,1}, --color de texto
    8
  )
  boton_atras.draw()
end

function ejerciciosIgualdad.update()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  for i=1, 3 do
    botones[i].update(x,y)
  end
  boton_atras.update(x,y)
end

function ejerciciosIgualdad.mousepressed(x,y)
  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end

  if paso == 0 then
    puntos = 0
    paso_seleccionado={}
    pregunta = generarPregunta()
    paso = 1
    botones = generarBotones()
  end

  for i=1, 3 do
    if botones[i].estaSeleccionado(x,y) then
      if botones[i].correcto then
        if paso == 1 then
          paso_seleccionado[1] = botones[i].texto
          paso = 2
          botones = generarBotones()
        elseif paso == 2 then
          paso_seleccionado[2] = botones[i].texto
          paso = 3
          botones = generarBotones()
        elseif paso == 3 then
          paso_seleccionado[3] = botones[i].texto
          paso = 4
          botones = generarSoluciones()
        elseif paso == 4 then
          paso_seleccionado[4] = botones[i].texto
          paso = 5
          puntos = puntos + 1
          return
        end
      else
        paso = 0
      end
    end
  end

  if paso == 5 then
    paso_seleccionado={}
    pregunta = generarPregunta()
    paso = 1
    botones = generarBotones()
  end
end