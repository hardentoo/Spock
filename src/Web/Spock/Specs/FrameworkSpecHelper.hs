{-# LANGUAGE OverloadedStrings #-}
module Web.Spock.Specs.FrameworkSpecHelper where

import Test.Hspec
import Test.Hspec.Wai

import qualified Network.Wai as Wai

frameworkSpec :: IO Wai.Application -> Spec
frameworkSpec app =
    with app $
    do routingSpec
       actionSpec

routingSpec :: SpecWith Wai.Application
routingSpec =
    describe "Routing Framework" $
      do it "allows root actions" $
            get "/" `shouldRespondWith` "root" { matchStatus = 200 }
         it "routes different HTTP-verbs to different actions" $
            do verbTest get "GET"
               verbTest (\p -> post p "") "POST"
               verbTest (\p -> put p "") "PUT"
               verbTest delete "DELETE"
               verbTest (\p -> patch p "") "PATCH"
         it "can extract params from routes" $
            get "/param-test/42" `shouldRespondWith` "int42" { matchStatus = 200 }
         it "can handle multiple matching routes" $
            get "/param-test/static" `shouldRespondWith` "static" { matchStatus = 200 }
    where
      verbTest verb verbVerbose =
          (verb "/verb-test")
          `shouldRespondWith` (verbVerbose { matchStatus = 200 })

actionSpec :: SpecWith Wai.Application
actionSpec =
    describe "Action Framework" $ return ()
