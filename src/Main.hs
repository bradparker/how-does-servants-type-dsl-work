{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wall #-}

module Main where

import Servant
  ( (:<|>)
  , (:>)
  , Capture
  , Get
  , JSON
  )

data User = User

type UsersIndex =
  Get '[JSON] [User]

type UsersShow =
  Capture "username" String
    :> Get '[JSON] User

type UsersAPI =
  "users"
    :> (UsersIndex :<|> UsersShow)

main :: IO ()
main = putStrLn "Hello, Haskell!"
