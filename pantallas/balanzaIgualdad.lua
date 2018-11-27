require('clases/balanza')
require('clases/bola')

--VENTANA
balanzaIgualdad = {}

local angulo
local balanzas
local bolas
local boton_atras

local cadenas = {
  boton = [[ATRAS]],
}

local cfg = {
  color_balanza = {1,0.5,0.1},
  color_bolas_dinamicas = {1,0.8,0.1},
  color_bolas_estaticas = {0.4,0.5,1},
  ancho_lateral = 100,
  color_lateral = {0.4,0.7,1},
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

function balanzaIgualdad.load()
  --VALORES INICIALES
  balanzas = {}
  bolas = {}
  angulo = 0

  --CREAR BALANZAS
  balanzas[1] = crearBalanza(350,200,250,30,cfg.color_balanza,5)
  balanzas[2] = crearBalanza(750,200,250,30,cfg.color_balanza,5)
  balanzas[3] = crearBalanza(550,500,250,30,cfg.color_balanza,5)

  --BOLAS DINAMICAS
  bolas[1] = crearBola(cfg.ancho_lateral/2,70,30,cfg.color_bolas_dinamicas,2,5)
  bolas[3] = crearBola(cfg.ancho_lateral/2,170,30,cfg.color_bolas_dinamicas,2,4)
  bolas[4] = crearBola(cfg.ancho_lateral/2,270,30,cfg.color_bolas_dinamicas,2,6) --BOLA 2X
  bolas[6] = crearBola(cfg.ancho_lateral/2,370,30,cfg.color_bolas_dinamicas,2,1)
  bolas[7] = crearBola(cfg.ancho_lateral/2,470,30,cfg.color_bolas_dinamicas,2,9)
  bolas[8] = crearBola(cfg.ancho_lateral/2,570,30,cfg.color_bolas_dinamicas,2,3) --BOLA X

  -- BOLAS ESTATICAS
  bolas[2] = crearBola(cfg.ancho_lateral/2,170,30,cfg.color_bolas_estaticas,2,7) --BOLA Y
  bolas[5] = crearBola(cfg.ancho_lateral/2,370,30,cfg.color_bolas_estaticas,2,7) --BOLA Y

  --AGREGAR BOLA 2 A LA BALANZA 1 Y ESCONDER PESO
  bolas[2].hidden = "y"
  bolas[2].estado = "en plato"
  balanzas[1].add(bolas[2],2,"B")
  bolas[2].estatico = true

  --AGREGAR BOLA 5 A LA BALANZA 2 Y ESCONDER PESO
  bolas[5].hidden = "y"
  bolas[5].estado = "en plato"
  balanzas[2].add(bolas[5],5,"B")
  bolas[5].estatico = true

  --ESCONDER PESO DE BOLA 4
  bolas[4].hidden = "2x"

  --ESCONDER PESO DE BOLA 6
  bolas[8].hidden = "x"

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
end

function balanzaIgualdad.update(dt)
  --BALANZA UPDATE
  for i=1, #balanzas do
    balanzas[i].update(dt)
  end
  
  --BOLA UPDATE
  for i=1, #bolas do
    if bolas[i].estado=="reposo" then
      bolas[i].x=bolas[i].basex
      bolas[i].y=bolas[i].basey
    elseif bolas[i].estado=="seguir" then
      bolas[i].x=love.mouse.getX()
      bolas[i].y=love.mouse.getY()
    elseif bolas[i].estado == "en plato" then
      local ubicacion = "NO"

      for j=1, #balanzas do
        if balanzas[j].buscar(i)~="NO" then
          ubicacion = {
            balanza = j,
            plato = balanzas[j].buscar(i),
            lugar = balanzas[j].buscar(i,"lugar")
          }
        end
      end

      if ubicacion.plato == "A" then
        bolas[i].x=balanzas[ubicacion.balanza].getA().x
        bolas[i].y=balanzas[ubicacion.balanza].getA().y - ubicacion.lugar * bolas[i].radio - (ubicacion.lugar-1)*bolas[i].radio
      elseif ubicacion.plato == "B" then
        bolas[i].x=balanzas[ubicacion.balanza].getB().x
        bolas[i].y=balanzas[ubicacion.balanza].getB().y - ubicacion.lugar * bolas[i].radio - (ubicacion.lugar-1)*bolas[i].radio
      end
    end
  end

  --BOTON UPDATE
  boton_atras.update(
    love.mouse.getX(),
    love.mouse.getY()
  )
end

function balanzaIgualdad.draw()
  --DIBUJA LATERAL
  dibujarCaja(0,0,cfg.ancho_lateral,love.graphics.getHeight(),cfg.color_lateral)

  --DIBUJA BALANZAS
  for i=1, #balanzas do
    balanzas[i].draw()
  end

  --DIBUJA BOLAS
  for i=1, #bolas do
    bolas[i].draw()
  end

  --DIBUJAR BOTON RETROCESO
  boton_atras.draw()
end

function balanzaIgualdad.mousepressed(x,y)
  for i=1, #bolas do
    if not bolas[i].estatico then 
      if bolas[i].isSelected(x,y)==true then
        for j=1, #balanzas do
          local plato = balanzas[j].buscar(i)
          if plato ~= "NO" then
            balanzas[j].remove(i, plato)
          end
        end

        bolas[i].estado = "seguir"

        break
      end
    end
  end

  for i=1, #balanzas do
    balanzas[i].actualizar()
  end

  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

function balanzaIgualdad.mousereleased(x,y)
  for i=1, #bolas do
    if not bolas[i].estatico then
      if bolas[i].isSelected(x,y)==true then
        local ubicacion = estaEnBalanza(bolas[i])
        if ubicacion ~= "NO" then
          bolas[i].estado = "en plato"
          balanzas[ubicacion.balanza].add(bolas[i],i,ubicacion.plato)
        else
          bolas[i].estado = "reposo"
        end
      end
    end
  end

  for i=1, #balanzas do
    balanzas[i].actualizar()
  end
end

function estaEnBalanza(self)
  local enBalanza = "NO"

  for i=1, #balanzas do
    local distancia = 2*(#balanzas[i].bolasA + 1)*self.radio
    if self.x>balanzas[i].getA().x - balanzas[i].tamaño/4  and 
      self.x<balanzas[i].getA().x + balanzas[i].tamaño/4 and
      self.y>balanzas[i].getA().y - distancia and
      self.y<balanzas[i].getA().y + distancia/4
    then
      enBalanza = {
        balanza = i,
        plato = "A"
      }
    end
  end

  if enBalanza == "NO" then
    for i=1, #balanzas do
      local distancia = 2*(#balanzas[i].bolasB + 1)*self.radio
      if self.x>balanzas[i].getB().x - balanzas[i].tamaño/4 and 
        self.x<balanzas[i].getB().x + balanzas[i].tamaño/4 and
        self.y>balanzas[i].getB().y - distancia and
        self.y<balanzas[i].getB().y + distancia/4
      then
        enBalanza = {
          balanza = i,
          plato = "B"
        }
      end
    end
  end

  return enBalanza
end