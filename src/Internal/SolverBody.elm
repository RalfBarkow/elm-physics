module Internal.SolverBody exposing
    ( SolverBody
    , addToWlambda
    , fromBody
    )

import Internal.Body as Body exposing (Body)
import Internal.Const as Const
import Internal.JacobianElement as JacobianElement exposing (JacobianElement)
import Internal.Matrix3 as Mat3
import Internal.Vector3 as Vec3 exposing (Vec3)


type alias SolverBody data =
    { body : Body data
    , vlambda : Vec3
    , wlambda : Vec3
    }


fromBody : Body data -> SolverBody data
fromBody body =
    { body = body
    , vlambda = Const.zero3
    , wlambda = Const.zero3
    }


addToWlambda : Float -> JacobianElement -> SolverBody data -> SolverBody data
addToWlambda deltalambda { spatial, rotational } { body, vlambda, wlambda } =
    { body = body
    , vlambda =
        spatial
            |> Vec3.scale (deltalambda * body.invMass)
            |> Vec3.add vlambda
    , wlambda =
        rotational
            |> Mat3.transform body.invInertiaWorld
            |> Vec3.scale deltalambda
            |> Vec3.add wlambda
    }
