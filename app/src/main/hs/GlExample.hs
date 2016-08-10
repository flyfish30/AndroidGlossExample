{-
   GlExample.hs
   Copyright (c) 2016 Parker Liu <liuchangsheng30@gmail.com>
   Further hacked by Sven Panne <svenpanne@gmail.com>
   This file is part of HOpenGL and distributed under a BSD-style license
   See the file libraries/GLUT/LICENSE
-}

--------------------------------------------------------------------------------

{-# LANGUAGE ForeignFunctionInterface #-}

module GlExample where

import Control.Monad ( when )
import Data.IORef ( IORef, newIORef )
import Data.List ( intersperse )
import System.Console.GetOpt
import System.Exit ( exitWith, ExitCode(ExitSuccess), exitFailure )
import Graphics.UI.GLUT
import Graphics.Rendering.OpenGL.GL as GL

import Foreign
import Foreign.C
import Foreign.Ptr

--------------------------------------------------------------------------------

type View = (GLfloat, GLfloat, GLfloat)

data State = State {
   frames  :: IORef Int,
   t0      :: IORef Int,
   viewRot :: IORef View,
   angle'  :: IORef GLfloat }

makeState :: IO State
makeState = do
   f <- newIORef 0
   t <- newIORef 0
   v <- newIORef (20, 30, 0)
   a <- newIORef 0
   return $ State { frames = f, t0 = t, viewRot = v, angle' = a }

idle :: State -> IdleCallback
idle state = do
   angle' state $~! (+2)
   postRedisplay Nothing

keyboard :: State -> KeyboardMouseCallback
keyboard state (Char 'z')           _ _ _ = modRot state ( 0,  0,  5)
keyboard state (Char 'Z')           _ _ _ = modRot state ( 0,  0, -5)
keyboard state (SpecialKey KeyUp)   _ _ _ = modRot state ( 5,  0,  0)
keyboard state (SpecialKey KeyDown) _ _ _ = modRot state (-5,  0,  0)
keyboard state (SpecialKey KeyLeft) _ _ _ = modRot state ( 0,  5,  0)
keyboard state (SpecialKey KeyRight)_ _ _ = modRot state ( 0, -5,  0)
keyboard _     (Char '\27')         _ _ _ = exitWith ExitSuccess
keyboard _     _                    _ _ _ = return ()

modRot :: State -> View -> IO ()
modRot state (dx,dy,dz) = do
   (x, y, z) <- get (viewRot state)
   viewRot state $= (x + dx, y + dy, z + dz)
   postRedisplay Nothing

visible :: State -> Visibility -> IO ()
visible state Visible    = idleCallback $= Just (idle state)
visible _     NotVisible = idleCallback $= Nothing

display :: State -> Ptr CFloat -> DisplayCallback
display state vBox = do
  GL.clearColor $= GL.Color4 0.5 0 1 (1 :: GLfloat)
  GL.clear [ColorBuffer, DepthBuffer]
  loadIdentity
  angleR <- get (angle' state)
  GL.rotate angleR (GL.Vector3 0 0 1)
  GL.color $ GL.Color4 1 1 0 (1::GL.GLfloat)
  arrayPointer VertexArray $= VertexArrayDescriptor 2 Float 0 vBox
  clientState VertexArray $= Enabled
  drawArrays TriangleStrip 0 4
  clientState VertexArray $= Disabled
  swapBuffers

foreign export ccall "app_main" app_main :: IO ()
app_main :: IO ()
app_main = do
  (_progName, _args) <- getArgsAndInitialize
  initialDisplayMode $= [ RGBMode, WithDepthBuffer, DoubleBuffered ]
  _window <- createWindow "GlExample"

  state <- makeState
  vBox  <- newArray ([
               -0.5, -0.33,
                0.5, -0.33,
               -0.5,  0.33,
                0.5,  0.33
            ] :: [CFloat])
  keyboardMouseCallback $= Just (keyboard state)
  visibilityCallback $= Just (visible state)
  displayCallback $= display state vBox
  actionOnWindowClose $= ContinueExecution

  mainLoop
  free vBox
