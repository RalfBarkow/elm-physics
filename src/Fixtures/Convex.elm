module Fixtures.Convex exposing (askewSquarePyramid, boxHull, boxVertexIndices, nonSquareQuadPyramid, octoHull, octoVertexIndices, octoVertices, originalBoxHull, originalOctoHull, squareLikePyramid, squarePyramid, vec3HalfExtent)

import Array exposing (Array)
import Internal.Const as Const
import Internal.Convex as Convex exposing (Convex)
import Internal.Vector3 as Vec3 exposing (Vec3, vec3)



-- Test data generators


vec3HalfExtent : Float -> Vec3
vec3HalfExtent halfExtent =
    vec3 halfExtent halfExtent halfExtent


{-| A Convex for a cube with the given half-extent, constructed
using optimized box-specific initializers.
-}
boxHull : Float -> Convex
boxHull halfExtent =
    Convex.fromBox <| vec3HalfExtent halfExtent


originalBoxHull : Float -> Convex
originalBoxHull halfExtent =
    Convex.fromBox <| vec3HalfExtent halfExtent


boxVertexIndices : List (List Int)
boxVertexIndices =
    [ [ 3, 2, 1, 0 ]
    , [ 4, 5, 6, 7 ]
    , [ 5, 4, 0, 1 ]
    , [ 2, 3, 7, 6 ]
    , [ 0, 4, 7, 3 ]
    , [ 1, 2, 6, 5 ]
    ]


octoVertices : Float -> Array Vec3
octoVertices halfExtent =
    [ vec3 0 0 halfExtent
    , vec3 0 halfExtent 0
    , vec3 halfExtent 0 0
    , vec3 -halfExtent 0 0
    , vec3 0 0 -halfExtent
    , vec3 0 -halfExtent 0
    ]
        |> Array.fromList


octoHull : Float -> Convex.Convex
octoHull halfExtent =
    octoVertices halfExtent
        |> Convex.init octoVertexIndices


originalOctoHull : Float -> Convex.Convex
originalOctoHull halfExtent =
    octoVertices halfExtent
        |> Convex.init octoVertexIndices


octoVertexIndices : List (List Int)
octoVertexIndices =
    [ [ 2, 1, 0 ]
    , [ 0, 5, 2 ]
    , [ 1, 2, 4 ]
    , [ 3, 0, 1 ]
    , [ 2, 5, 4 ]
    , [ 4, 3, 1 ]
    , [ 5, 0, 3 ]
    , [ 3, 4, 5 ]
    ]


squarePyramid : Convex
squarePyramid =
    -- Specify 0 for exact precision
    squareLikePyramid 0.0


askewSquarePyramid : Convex
askewSquarePyramid =
    -- Use an insignificant epsilon for an approximately square base
    squareLikePyramid (Const.precision / 3.0)


nonSquareQuadPyramid : Convex
nonSquareQuadPyramid =
    -- Use a significant epsilon for a not even approximately square base
    squareLikePyramid (Const.precision * 3.0)


squareLikePyramid : Float -> Convex
squareLikePyramid epsilon =
    let
        x =
            1

        y =
            1

        z =
            1

        -- zOffset is the height of the pyramid's center of gravity above its
        -- base -- the cube root of 1/2.
        -- It serves to keep the object vertically centered.
        zOffset =
            z * (0.5 ^ (1.0 / 3.0))

        faces =
            [ [ 3, 2, 1, 0 ]
            , [ 0, 1, 4 ]
            , [ 1, 2, 4 ]
            , [ 2, 3, 4 ]
            , [ 3, 0, 4 ]
            ]

        vertices =
            Array.fromList
                [ vec3 -x -y -zOffset
                , vec3 x -y -zOffset

                -- An optional adjustment of one base corner controls
                -- the number (0 or 2) of edge pairs that are exactly
                -- parallel OR approximately parallel.
                , vec3 (x + epsilon) (y + epsilon) -zOffset
                , vec3 -x y -zOffset
                , vec3 0 0 (z - zOffset)
                ]
    in
    Convex.init faces vertices