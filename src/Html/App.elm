module Html.App exposing
  ( map
  , beginnerProgram
  , program
  , programWithFlags
  )

{-| These functions will help you set up an Elm program that follows [the Elm
Architecture][arch], a pattern for creating great code that *stays* great as
your project grows.

If you are totally new to Elm, you should only worry about the `beginnerProgram`
function. As you progress through [the tutorial][arch], more advanced functions
like `program` and `map` will be introduced gradually. The hope is that every
time Elm needs you to learn something, the usage path will clearly motivate and
explain the new concept!

[arch]: https://github.com/evancz/elm-architecture-tutorial/

# Nesting Views
@docs map

# Create a Program

Every Elm app needs to define a `main` value. That is what we are going to
show on screen. The following functions help you define `main`, so your first
Elm program will likely contain a definition like:

    main =
      Html.App.beginnerProgram
        { model = model
        , view = view
        , update = update
        }

If you are using `elm-reactor` you will just see everything on screen. If you
are using `elm-make` it will be generating HTML files that you can open in any
browser.

@docs beginnerProgram, program, programWithFlags

-}

import Html exposing (Html)
import VirtualDom



-- NESTING VIEWS


{-| This function is useful when nesting components with [the Elm
Architecture](https://github.com/evancz/elm-architecture-tutorial/). It lets
you transform the messages produced by a subtree.

Say you have a node named `button` that produces `()` values when it is
clicked. To get your model updating properly, you will probably want to tag
this `()` value like this:

    type Msg = Click | ...

    update msg model =
      case msg of
        Click ->
          ...

    view model =
      map (\_ -> Click) button

So now all the events produced by `button` will be transformed to be of type
`Msg` so they can be handled by your update function!
-}
map : (a -> msg) -> Html a -> Html msg
map =
  VirtualDom.map



-- CREATING PROGRAMS


{-| Create a [`Program`][program] that specifies how your whole app should
work. The essence of every Elm program is:

  * **Model** &mdash; a nice representation of your application state.
  * **View** &mdash; a function that turns models into HTML.
  * **Update** &mdash; given a user-input messages and the model, produce a new model.

Between these three things, you have everything you need! When the user clicks
on a button, it produces a message. That message is piped into the `update`
function, producing a new model. We use the `view` function to show the new
model on screen. And then we just repeat this forever!

Check out [the Elm Architecture Tutorial][tutorial] for a a more complete
explanation along with some examples!

[program]: http://package.elm-lang.org/packages/elm-lang/core/latest/Platform#Program
[tutorial]: https://github.com/evancz/elm-architecture-tutorial

-}
beginnerProgram
  : { model : model
    , view : model -> Html msg
    , update : msg -> model -> model
    }
  -> Program Never
beginnerProgram {model, view, update} =
  programWithFlags
    { init = \_ -> model ! []
    , update = \msg model -> update msg model ! []
    , view = view
    , subscriptions = \_ -> Sub.none
    }


{-| Create a [`Program`][program] that specifies how your whole app should
work. Here we extend the basic model/view/update pattern we saw in
`beginnerProgram` with a few things.

> I would very highly recommend reading [the Elm Architecture Tutorial][tutorial]
for a proper introduction to all the new pieces here.

[program]: http://package.elm-lang.org/packages/elm-lang/core/latest/Platform#Program
[tutorial]: https://github.com/evancz/elm-architecture-tutorial

First we augment the `model` and `update` functions to return a pair of
`model` and `Cmd msg`. A [command][cmd] is a way of saying “Hey Elm, I need
you to perform all these tasks.” This lets us update our model *and* make HTTP
requests or whatever else.

Second we add a `subscriptions` function. Similar to `view` it is always
applied to the latest model, but instead of HTML it gives us a list of
*subscriptions*. A [subscription][sub] is a way of saying “Hey Elm, I need
you to listen for any updates about these various things.” Now when you get
a geolocation change or a websocket message, it will be given to your update
function.

[cmd]: http://package.elm-lang.org/packages/elm-lang/core/latest/Platform-Cmd
[sub]: http://package.elm-lang.org/packages/elm-lang/core/latest/Platform-Sub

Now again, it is very important that you read [the Elm Architecture Tutorial][tutorial]
because it describes how these building blocks work and how you can put them
together into a nice modular architecture. I swear it will be faster to read
through than to muddle around and try to sort it out by trial-and-error.
-}
program
  : { init : (model, Cmd msg)
    , update : msg -> model -> (model, Cmd msg)
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
  -> Program Never
program app =
  programWithFlags
    { app | init = \_ -> app.init }


{-| Same as `program` but it lets you demand flags on initialization. So the
JavaScript code to start a program with flags might look like this:

```javascript
// Program { userID : String, token : String }

var app = Elm.MyApp.fullscreen({
    userID: 'Tom',
    token: '12345'
});
```
-}
programWithFlags
  : { init : flags -> (model, Cmd msg)
    , update : msg -> model -> (model, Cmd msg)
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
  -> Program flags
programWithFlags =
  VirtualDom.programWithFlags
