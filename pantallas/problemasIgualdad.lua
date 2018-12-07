problemasIgualdad = {}

local x,y,a,b,c,d,e,f
local pregunta
local botones
local paso
local paso_seleccionado
local linea
local boton_atras
local puntos

function generarProblema()
  x = love.math.random(2,9)
  y = love.math.random(2,9)
  a = love.math.random(2,9)
  b = love.math.random(2,9)
  c = love.math.random(2,9)
  d = love.math.random(2,9)
  e = a*x+b*y
  f = c*x+d*y

  local pregunta
  local respuesta
  local decide_pregunta = love.math.random(1,4)

  if decide_pregunta == 1 then
    pregunta = {
      "Si María compra "..a.." galletas y "..b.." empanadas, gastará ".. e,
      "soles. En cambio, si compra "..c.." galletas y "..d.." empanadas, gastará",
      f.." soles. ¿Cuanto cuesta una galleta?"
    }
    respuesta = x
  elseif decide_pregunta == 2 then
    pregunta = {
      "Si un comerciante vende "..a.." patos y "..b.." gallos, ganará ".. e,
      "soles. En cambio, si vende "..d.." gallos y "..c.." patos, ganará",
      f.." soles. ¿A cuanto vende cada gallo?"
    }
    respuesta = y
  elseif decide_pregunta == 3 then
    pregunta = {
      "Si Hilda compra regalos de "..a.." soles para sus sobrinos y de "..b.." soles para sus",
      "sobrinas, gastaría "..e.." soles. Si decide comprar de "..c.." soles para sus sobrinos",
      "y de "..d.." soles para sus sobrinas, gastaría "..f.." soles. ¿Cuantas sobrinas tiene?"
    }
    respuesta = y
  elseif decide_pregunta == 4 then
    pregunta = {
      ""..a.." ceviches y "..b.." jaleas cuestan "..e.." soles, mientras que "..c.." ceviches y",
      ""..d.." jaleas cuestan "..f.. " soles. ¿Cuánto cuesta un ceviche?",
    }
    respuesta = x
  end

  return {pregunta,respuesta}
end

function _generarBotones()
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

function generarPlanteo()
  local botones = {}

  local planteos = {}
  local planteos_fallidos = {
    {
      a.."x+"..b.."y="..e,
      d.."x+"..c.."y="..f,
    },
    {
      a.."x+"..b.."y="..f,
      c.."x+"..d.."y="..e,
    },
    {
      a.."x+"..d.."y="..e,
      b.."x+"..c.."y="..f,
    },
  }

  local n_correcto = love.math.random(1,3)
  planteos = planteos_fallidos
  planteos[n_correcto] = {
    a.."x+"..b.."y="..e,
    c.."x+"..d.."y="..f,
  }

   -- creando botones
   for i=1, 3 do
    botones[i] = crearBoton(
      love.graphics.getWidth()/2 - 1.5*250 - 50 + (250+50)*(i-1),
      0, 
      250,
      50,
      {0,0,1},
      planteos[i][1]..", "..planteos[i][2],
      18,
      {1,1,1},
      5,
      {0,0,0}
    )
    botones[i].correcto = false
  end
  botones[n_correcto].correcto = true

  return botones
end

function generarSolucion()
  local botones = {}
  local respuesta = pregunta[2]
  local alternativas = {}
  for i = 1, 3 do
    local dif = 2*(love.math.random(1,2)-1.5)*love.math.random(1,2)
    alternativas[i] = respuesta + dif
  end

  local n_correcto = love.math.random(1,3)
  alternativas[n_correcto] = respuesta

  for i=1, 3 do
    botones[i] = crearBoton(
      love.graphics.getWidth()/2 - 1.5*200 - 50 + (200+50)*(i-1),
      0, 
      200,
      50,
      {0,0,1},
      "x = "..alternativas[i],
      30,
      {1,1,1},
      5,
      {0,0,0}
    )

    botones[i].correcto = false
  end

  botones[n_correcto].correcto = true

  return botones
end

function problemasIgualdad.load()
  botones = {}
  puntos = 0

  paso_seleccionado={}
  pregunta = generarProblema()
  paso = 0.5
  botones = generarPlanteo()

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

function problemasIgualdad.draw()
  linea = 50
  for i=1, #pregunta[1] do
    linea = 50 + 50*(i-1)
    dibujarTexto(
      pregunta[1][i],
      love.graphics.getWidth()/2,
      linea,
      25,
      {0,0,0}
    )
  end

  linea = linea + 50
  if paso == 0.5 then
    for i=1,3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 0.5 then
    linea = linea + 20
    dibujarTexto(
      paso_seleccionado[10],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = linea + 40
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+10)
  end
  
  linea = linea+20
  if paso == 1 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 1 then
    linea = linea + 20
    dibujarTexto(
      paso_seleccionado[1],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = linea + 40
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+10)
  end

  linea = linea+20
  if paso == 2 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 2 then
    linea = linea + 20
    dibujarTexto(
      paso_seleccionado[2],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = linea + 40
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+10)
  end

  linea = linea+20
  if paso == 3 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 3 then
    linea = linea +20
    dibujarTexto(
      paso_seleccionado[3],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
    )

    linea = linea + 40
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill",love.graphics.getWidth()/2-15, linea-15, love.graphics.getWidth()/2+15, linea-15, love.graphics.getWidth()/2,linea+10)
  end

  linea = linea+20
  if paso == 4 then
    for i=1, 3 do
      botones[i].y = linea
      botones[i].draw()
    end
  elseif paso > 4 then
    linea = linea + 20
    dibujarTexto(
      paso_seleccionado[4],
      love.graphics.getWidth()/2,
      linea,
      30,
      {0,0,1}
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

function problemasIgualdad.update()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  for i=1, 3 do
    botones[i].update(x,y)
  end
  boton_atras.update(x,y)
end

function problemasIgualdad.mousepressed(x,y)
  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end

  if paso == 0 then
    puntos = 0
    paso_seleccionado={}
    pregunta = generarProblema()
    paso = 0.5
    botones = generarPlanteo()
  end

  for i=1, 3 do
    if botones[i].estaSeleccionado(x,y) then
      if botones[i].correcto then
        if paso == 0.5 then
          paso_seleccionado[10] = botones[i].texto
          paso = 1
          botones = _generarBotones()
        elseif paso == 1 then
          paso_seleccionado[1] = botones[i].texto
          paso = 2
          botones = _generarBotones()
        elseif paso == 2 then
          paso_seleccionado[2] = botones[i].texto
          paso = 3
          botones = _generarBotones()
        elseif paso == 3 then
          paso_seleccionado[3] = botones[i].texto
          paso = 4
          botones = generarSolucion()
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
    pregunta = generarProblema()
    paso = 0.5
    botones = generarPlanteo()
  end
end