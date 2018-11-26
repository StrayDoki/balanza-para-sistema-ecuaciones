require('pantallas/menu')
require('clases/texto')

titulo = {}

local cadena = {
  titulo = [[APRENDIENDO ECUACIONES]],
  autor = [[Profesor Arturo Sotelo Linares]]
}

local cfg = {
  background = {0.05,0.05,0.05,0},
  tamañoTitulo = 50,
  espacioTituloAutor=10,
  tamañoAutor = 30,
  colorAutor = {0.8,1,0.5,1}
}

function titulo.load()
  love.graphics.setBackgroundColor(cfg.background)
end

function titulo.draw()
  dibujarTexto(
    cadena.titulo,
    love.graphics.getWidth()/2,
    love.graphics.getHeight()/2 - cfg.tamañoTitulo/2 - cfg.espacioTituloAutor/2,
    cfg.tamañoTitulo
  )

  dibujarTexto(
    cadena.autor,
    love.graphics.getWidth()/2,
    love.graphics.getHeight()/2 + cfg.tamañoTitulo/2 + cfg.espacioTituloAutor/2,
    cfg.tamañoAutor,
    cfg.colorAutor
  )
end

function titulo.mousepressed()
  cambiarPantalla(menu)
end

