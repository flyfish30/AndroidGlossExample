
-- | Tree Fractal.
--      Based on ANUPlot code by Clem Baker-Finch.
--
{-# LANGUAGE ForeignFunctionInterface #-}

module GlExample where

import Data.IORef ( IORef, newIORef )
import System.Exit ( exitWith, ExitCode(ExitSuccess) )
import Graphics.Rendering.OpenGL.GL as GL
import Graphics.UI.GLUT
import Graphics.Gloss as GS
import Graphics.Gloss.Rendering as GR

foreign export ccall "app_main" app_main :: IO ()
app_main :: IO ()
app_main = do
  {-
  animate (InWindow "Tree" (500, 650) (20,  20))
          black (picture 4)
  -}
  (_progName, _args) <- getArgsAndInitialize
  initialDisplayMode $= [ RGBMode, WithDepthBuffer, DoubleBuffered ]
  _window <- createWindow "GlExample"

  state <- makeState
  rsState <- GR.initState
  keyboardMouseCallback $= Just (keyboard state)
  visibilityCallback $= Just (visible state)
  displayCallback $= displayFrame rsState
  actionOnWindowClose $= ContinueExecution

  mainLoop

displayFrame :: GR.State -> IO ()
displayFrame state = do
  GL.clearColor $= GL.Color4 0.5 0 1 (1 :: GLfloat)
  GL.clear [ColorBuffer, DepthBuffer]
  loadIdentity
  let (sizeX, sizeY) = (500, 650)
  let (sx, sy)    = (fromIntegral sizeX / 2, fromIntegral sizeY / 2)
  -- GL.ortho (-sx) sx (-sy) sy 0 (-100)

  -- draw the world
  -- GL.matrixMode   $= GL.Modelview 0
  renderPicture state 1.0 (picture 4 0.5)
  swapBuffers

idle :: GlState -> IdleCallback
idle state = do
   angle' state $~! (+2)
   postRedisplay Nothing

keyboard :: GlState -> KeyboardMouseCallback
keyboard state (Char 'z')           _ _ _ = modRot state ( 0,  0,  5)
keyboard state (Char 'Z')           _ _ _ = modRot state ( 0,  0, -5)
keyboard state (SpecialKey KeyUp)   _ _ _ = modRot state ( 5,  0,  0)
keyboard state (SpecialKey KeyDown) _ _ _ = modRot state (-5,  0,  0)
keyboard state (SpecialKey KeyLeft) _ _ _ = modRot state ( 0,  5,  0)
keyboard state (SpecialKey KeyRight)_ _ _ = modRot state ( 0, -5,  0)
keyboard _     (Char '\27')         _ _ _ = exitWith ExitSuccess
keyboard _     _                    _ _ _ = return ()

modRot :: GlState -> View -> IO ()
modRot state (dx,dy,dz) = do
   (x, y, z) <- get (viewRot state)
   viewRot state $= (x + dx, y + dy, z + dz)
   postRedisplay Nothing

visible :: GlState -> Visibility -> IO ()
visible state Visible    = idleCallback $= Just (idle state)
visible _     NotVisible = idleCallback $= Nothing

type View = (GLfloat, GLfloat, GLfloat)

data GlState = GlState {
   frames  :: IORef Int,
   t0      :: IORef Int,
   viewRot :: IORef View,
   angle'  :: IORef GLfloat }

makeState :: IO GlState
makeState = do
   f <- newIORef 0
   t <- newIORef 0
   v <- newIORef (20, 30, 0)
   a <- newIORef 0
   return $ GlState { frames = f, t0 = t, viewRot = v, angle' = a }

-- The picture is a tree fractal, graded from brown to green
picture :: Int -> Float -> Picture
picture degree time
        = Translate 0 (-0.6)  -- (300)
        $ tree degree time (dim $ dim brown)


-- Basic stump shape
stump :: GS.Color -> Picture
stump color
        = GS.Color color
        $ GS.Polygon [(0.06,0.0), (0.03,0.6), (-0.03,0.6), (-0.06,0)]
        -- $ GS.Polygon [(30,0), (15,300), (-15,300), (-30,0)]


-- Make a tree fractal.
tree    :: Int          -- Fractal degree
        -> Float        -- time
        -> GS.Color     -- Color for the stump
        -> Picture

tree 0 time color = stump color
tree n time color
 = let  smallTree
                = Rotate (sin time)
                $ Scale 0.5 0.5
                $ tree (n-1) (- time) (greener color)
   in   Pictures
                [ stump color
                , Translate 0 0.6  $ smallTree
                , Translate 0 0.48 $ Rotate 20    smallTree
                , Translate 0 0.36 $ Rotate (-20) smallTree
                , Translate 0 0.24 $ Rotate 40    smallTree
                , Translate 0 0.12 $ Rotate (-40) smallTree ]


-- A starting colour for the stump
brown :: GS.Color
brown =  makeColorI 139 100 35  255


-- Make this color a little greener
greener :: GS.Color -> GS.Color
greener c = mixColors 1 10 green c

