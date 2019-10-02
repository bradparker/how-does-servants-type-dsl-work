{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.Aeson (ToJSON)
import Data.Proxy (Proxy(Proxy))
import Data.Time (Day, fromGregorian)
import GHC.Generics (Generic)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Servant
  ( (:<|>)((:<|>))
  , (:>)
  , Capture
  , Get
  , Handler
  , JSON
  , Server
  , serve
  )

data User = User
  { name :: String
  , age :: Int
  , email :: String
  , username :: String
  , registrationDate :: Day
  } deriving (Generic)

instance ToJSON User

type UsersIndex =
  Get '[JSON] [User]

type UsersShow =
  Capture "username" String
    :> Get '[JSON] User

type UsersAPI =
  "users"
    :> (UsersIndex :<|> UsersShow)

users :: [User]
users =
  [ User
    { name             = "Isaac Newton"
    , age              = 372
    , email            = "isaac@newton.co.uk"
    , username         = "isaac"
    , registrationDate = fromGregorian 1683 3 1
    }
  , User
    { name             = "Albert Einstein"
    , age              = 136
    , email            = "ae@mc2.org"
    , username         = "albert"
    , registrationDate = fromGregorian 1905 12 1
    }
  ]

usersIndex :: Handler [User]
usersIndex = pure users

usersShow :: String -> Handler User
usersShow _uname = _

usersServer :: Server UsersAPI
usersServer = usersIndex :<|> usersShow

usersApp :: Application
usersApp = serve (Proxy @UsersAPI) usersServer

main :: IO ()
main = run 8080 usersApp
