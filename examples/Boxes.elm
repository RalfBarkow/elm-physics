module Boxes exposing (main)

import Common.Bodies as Bodies exposing (DemoBody)
import Common.Demo as Demo exposing (Demo, DemoProgram)
import Physics.Body as Body exposing (Body)
import Random


main : DemoProgram
main =
    Demo.demo
        |> Demo.addBodies initialBoxes
        |> Demo.dropOnClick randomlyRotatedBox
        |> Demo.run


{-| Boxes in the initial scene
-}
initialBoxes : List (Body DemoBody)
initialBoxes =
    [ Bodies.box
        |> Body.moveBy { x = 0, y = 0, z = 2 }
        |> Body.rotateBy (-pi / 5) { x = 0, y = 1, z = 0 }
    , Bodies.box
        |> Body.moveBy { x = -1.2, y = 0, z = 9 }
        |> Body.rotateBy (-pi / 4) { x = 0, y = 1, z = 0 }
    , Bodies.box
        |> Body.moveBy { x = 1.3, y = 0, z = 6 }
        |> Body.rotateBy (pi / 5) { x = 0, y = 1, z = 0 }
    ]


{-| A box raised above the plane and rotated to a random 3d angle
-}
randomlyRotatedBox : Random.Generator (Body DemoBody)
randomlyRotatedBox =
    Random.map4
        (\angle x y z ->
            Bodies.box
                |> Body.moveBy { x = 0, y = 0, z = 10 }
                |> Body.rotateBy angle { x = x, y = y, z = z }
        )
        (Random.float (-pi / 2) (pi / 2))
        (Random.float -1 1)
        (Random.float -1 1)
        (Random.float -1 1)
