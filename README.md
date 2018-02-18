# HTML

Quickly render HTML in Elm.


## Examples

The HTML part of an Elm program looks something like this:

```elm
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

type Msg = Increment | Decrement

view : Int -> Html Msg
view count =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString count) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

If you call `view 42` you get something like this:

```html
<div>
  <button>-</button>
  <div>42</div>
  <button>+</button>
</div>
```

This snippet comes from a complete example. You can play with it online [here](http://elm-lang.org/examples/buttons) and read how it works [here](https://guide.elm-lang.org/architecture/user_input/buttons.html).

You can play with a bunch of other examples [here](http://elm-lang.org/examples).


## Learn More

**Definitely read through [guide.elm-lang.org](http://guide.elm-lang.org/) to understand how this all works!** The section on [The Elm Architecture](http://guide.elm-lang.org/architecture/index.html) is particularly helpful.


## Implementation

This library is backed by [elm-lang/virtual-dom](http://package.elm-lang.org/packages/elm-lang/virtual-dom/latest/) which handles the dirty details of rendering DOM nodes quickly. You can read some blog posts about it here:

  - [Blazing Fast HTML, Round Two](http://elm-lang.org/blog/blazing-fast-html-round-two)
  - [Blazing Fast HTML](http://elm-lang.org/blog/blazing-fast-html)
