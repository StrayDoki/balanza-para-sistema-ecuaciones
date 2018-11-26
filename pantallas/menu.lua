require('pantallas/balanzas')
require('clases/texto')
require('clases/caja')

menu = {}

local cadena = {
  titulo = [[ELIGE UNA OPCIÓN]],
}

local cfg = {
  background = {1,1,1,1},
  textoColor = {0,0,0,1},
  tamañoTitulo = 40,
  alturaTitulo = 80,
  columnas = 2,
  filas = 0,
  separacion = 30,
}

local opciones = {
  {"Las balanzas", balanzas},
  {"Las balanzas", balan},
  {"Las", balanzas},
  {"Las balanzas", balanzas}
}

local botones = {}

function menu.load()
  love.graphics.setBackgroundColor(cfg.background)

  cfg.filas = math.ceil(#opciones / cfg.columnas)
  for i=1, cfg.filas do
    for j=1, cfg.columnas do
      local width = (love.graphics.getWidth() - cfg.separacion*(cfg.columnas + 1))/cfg.columnas
      local height = (love.graphics.getHeight()-cfg.alturaTitulo - cfg.separacion*(cfg.filas+1))/cfg.filas
      local x = cfg.separacion*j + width*(j-1)
      local y = cfg.alturaTitulo + cfg.separacion*i + height*(i-1)
      botones[#botones+1] =
        crearBoton(x,y,width,height,{0.1,0.1,0.2,1},opciones[(i-1)*cfg.columnas+j][1],40,{1,1,1,1},10)
    end
  end
end

function menu.update()
  for i=1, #botones do
    botones[i].update(love.mouse.getX(),love.mouse.getY())
  end
end

function menu.draw()
  dibujarTexto(
    cadena.titulo,
    love.graphics.getWidth()/2,
    cfg.alturaTitulo/2,
    cfg.tamañoTitulo,
    cfg.textoColor
  )

  for i=1, #botones do
    botones[i].draw()
  end
end

function menu.mousepressed(x,y)
  for i=1, #botones do
    if botones[i].estaSeleccionado(x,y) then
      cambiarPantalla(opciones[i][2])
    end
  end
end

