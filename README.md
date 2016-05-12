# HTML for Elm

The core HTML library for Elm. It is backed by [elm-lang/virtual-dom](http://package.elm-lang.org/packages/elm-lang/virtual-dom/latest/) which handles the dirty details of rendering things quickly.

The best way to learn how to use this library is to read [guide.elm-lang.org](http://guide.elm-lang.org/), particularly the section on [The Elm Architecture][arch]

[arch]: http://guide.elm-lang.org/architecture/index.html

## Example

Heres a quick example of how to build HTML apps with Elm:

```elm
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Events exposing (onClick)

main =
  App.beginnerProgram { model = 0, view = view, update = update }

type Msg = Increment | Decrement

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

You can paste the code into Elm's online editor to see it in action.

From there, install Elm on your machine and, assuming you've copied the example into a file Counter.elm in an empty directory, run the following commands inside that directory:

```bash
# Create an elm-package.json file and install the required packages
elm-package install -y elm-lang/html
# Compile the example file
elm-make Counter.elm --output=counter.html
# Open the compiled file with your browser
open counter.html
```

You can read more about elm commands in the [Get Started guide][started] or work through the [Elm Architecture tutorial][arch] which starts with this counter example and gradually works up to programs with HTTP and animation.

[started]: http://elm-lang.org/get-started
