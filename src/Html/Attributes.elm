module Html.Attributes exposing
  ( style, property, attribute, map
  , class, classList, id, title, hidden
  , type_, value, checked, placeholder, selected
  , accept, acceptCharset, action, autocomplete, autofocus
  , disabled, enctype, list, maxlength, minlength, method, multiple
  , name, novalidate, pattern, readonly, required, size, for, form
  , max, min, step
  , cols, rows, wrap
  , href, target, download, hreflang, media, ping, rel
  , ismap, usemap, shape, coords
  , src, height, width, alt
  , autoplay, controls, loop, preload, poster, default, kind, srclang
  , sandbox
  , reversed, start
  , align, colspan, rowspan, headers, scope
  , accesskey, contenteditable, contextmenu, dir, draggable, dropzone
  , itemprop, lang, spellcheck, tabindex
  , cite, datetime, pubdate, manifest
  , srcdoc
  )

{-| Helper functions for HTML attributes. They are organized roughly by
category. Each attribute is labeled with the HTML tags it can be used with, so
just search the page for `video` if you want video stuff.

# Primitives
@docs style, property, attribute, map

# Super Common Attributes
@docs class, classList, id, title, hidden

# Inputs
@docs type_, value, checked, placeholder, selected

## Input Helpers
@docs accept, acceptCharset, action, autocomplete, autofocus,
    disabled, enctype, list, maxlength, minlength, method, multiple,
    name, novalidate, pattern, readonly, required, size, for, form

## Input Ranges
@docs max, min, step

## Input Text Areas
@docs cols, rows, wrap


# Links and Areas
@docs href, target, download, hreflang, media, ping, rel

## Maps
@docs ismap, usemap, shape, coords


# Embedded Content
@docs src, height, width, alt

## Audio and Video
@docs autoplay, controls, loop, preload, poster, default, kind, srclang

## iframes
@docs sandbox

# Ordered Lists
@docs reversed, start

# Tables
@docs align, colspan, rowspan, headers, scope

# Less Common Global Attributes
Attributes that can be attached to any HTML tag but are less commonly used.
@docs accesskey, contenteditable, contextmenu, dir, draggable, dropzone,
      itemprop, lang, spellcheck, tabindex

# Miscellaneous
@docs cite, datetime, pubdate, manifest

# Deprecated
@docs srcdoc

-}


import Elm.Kernel.VirtualDom
import Html exposing (Attribute)
import Json.Encode as Json
import VirtualDom


-- This library does not include low, high, or optimum because the idea of a
-- `meter` is just too crazy.



-- PRIMITIVES


{-| Specify a style.

    greeting : Node msg
    greeting =
      div
        [ style "background-color" "red"
        , style "height" "90px"
        , style "width" "100%"
        ]
        [ text "Hello!"
        ]

There is no `Html.Styles` module because best practices for working with HTML
suggest that this should primarily be specified in CSS files. So the general
recommendation is to use this function lightly.
-}
style : String -> String -> Attribute msg
style =
  VirtualDom.style


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with. For example, maybe we want a way to view notices:

    viewNotice : Notice -> Html msg
    viewNotice notice =
      div
        [ classList
            [ ("notice", True)
            , ("notice-important", notice.isImportant)
            , ("notice-seen", notice.isSeen)
            ]
        ]
        [ text notice.content ]

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!
-}
classList : List (String, Bool) -> Attribute msg
classList classes =
  class <| String.join " " <| List.map Tuple.first <|
    List.filter Tuple.second classes



-- CUSTOM ATTRIBUTES


{-| Create *properties*, like saying `domNode.className = 'greeting'` in
JavaScript.

    import Json.Encode as Encode

    class : String -> Attribute msg
    class name =
      property "className" (Encode.string name)

Read more about the difference between properties and attributes [here][].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md
-}
property : String -> Json.Value -> Attribute msg
property =
  VirtualDom.property


{-| This is used for attributes that have a property that:

- Is boolean.
- Defaults to `false`.
- Removes the attribute when setting to `false`.

Note:

- Some properties, like `checked`, can be modified by the user.
- `.setAttribute(property, "false")` does not set the property to `false` – we have to remove the attribute. (Except `spellcheck` which explicitly has a "false" (and "true") value.)

Consider `hidden : Bool -> Attribute msg`. When that `Bool` is `True`, we could implement the function with `attribute "hidden" ""`. (Using the empty string seems to be “canonical”, but any string would make the element hidden.) But what do we do when the `Bool` is `False`? The intention is to make the element _not_ hidden. The only way of doing that is to remove the `hidden` attribute, but we cannot do that with `attribute` – it always results in the attribute being present (we can only choose its value, but no value will result in the element _not_ being hidden). To keep this API, we _have_ to use the `hidden` _property_ instead, which (like mentioned above) automatically removes the attribute when set to `false`.

An alternative would be to have `hidden : Attribute msg` and let users do `if shouldHide then hidden else ???` where `???` would have to be a way to express a no-op `Attribute msg`, or the user has to resort to list manipulation.

-}
boolProperty : String -> Bool -> Attribute msg
boolProperty key bool =
  Elm.Kernel.VirtualDom.property key (Json.bool bool)


{-| Create *attributes*, like saying `domNode.setAttribute('class', 'greeting')`
in JavaScript.

    class : String -> Attribute msg
    class name =
      attribute "class" name

Read more about the difference between properties and attributes [here][].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md
-}
attribute : String -> String -> Attribute msg
attribute =
  VirtualDom.attribute


{-| Transform the messages produced by an `Attribute`.
-}
map : (a -> msg) -> Attribute a -> Attribute msg
map =
  VirtualDom.mapAttribute



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!
-}
class : String -> Attribute msg
class =
  Elm.Kernel.VirtualDom.attribute "class"


{-| Indicates the relevance of an element. -}
hidden : Bool -> Attribute msg
hidden =
  boolProperty "hidden"


{-| Often used with CSS to style a specific element. The value of this
attribute must be unique.
-}
id : String -> Attribute msg
id =
  Elm.Kernel.VirtualDom.attribute "id"


{-| Text to be displayed in a tooltip when hovering over the element. -}
title : String -> Attribute msg
title =
  Elm.Kernel.VirtualDom.attribute "title"



-- LESS COMMON GLOBAL ATTRIBUTES


{-| Defines a keyboard shortcut to activate or add focus to the element. -}
accesskey : Char -> Attribute msg
accesskey char =
  Elm.Kernel.VirtualDom.attribute "accesskey" (String.fromChar char)


{-| Indicates whether the element's content is editable.

Note: These days, the contenteditable attribute can take more values than a boolean, like "inherit" and "plaintext-only". You can set those values like this:

    attribute "contenteditable" "inherit"
-}
contenteditable : Bool -> Attribute msg
contenteditable bool =
  -- Note: `node.contentEditable = 'bad'` throws an error!
  Elm.Kernel.VirtualDom.attribute "contenteditable" (if bool then "true" else "false")


{-| Defines the ID of a `menu` element which will serve as the element's
context menu.
-}
contextmenu : String -> Attribute msg
contextmenu =
  Elm.Kernel.VirtualDom.attribute "contextmenu"


{-| Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl
(Right-To-Left).
-}
dir : String -> Attribute msg
dir =
  Elm.Kernel.VirtualDom.attribute "dir"


{-| Defines whether the element can be dragged. -}
draggable : String -> Attribute msg
draggable =
  Elm.Kernel.VirtualDom.attribute "draggable"


{-| Indicates that the element accept the dropping of content on it.

Note: This attribute or property seems to no longer exist.
-}
dropzone : String -> Attribute msg
dropzone =
  Elm.Kernel.VirtualDom.attribute "dropzone"


{-|-}
itemprop : String -> Attribute msg
itemprop =
  Elm.Kernel.VirtualDom.attribute "itemprop"


{-| Defines the language used in the element. -}
lang : String -> Attribute msg
lang =
  Elm.Kernel.VirtualDom.attribute "lang"


{-| Indicates whether spell checking is allowed for the element. -}
spellcheck : Bool -> Attribute msg
spellcheck bool =
  -- Note: The spellcheck _property_ defaults to `true`, unlike other boolean properties.
  -- Setting it back to the default value does _not_ remove the attribute.
  -- Because of this, we set it using an attribute instead.
  Elm.Kernel.VirtualDom.attribute "spellcheck" (if bool then "true" else "false")


{-| Overrides the browser's default tab order and follows the one specified
instead.
-}
tabindex : Int -> Attribute msg
tabindex n =
  Elm.Kernel.VirtualDom.attribute "tabIndex" (String.fromInt n)



-- EMBEDDED CONTENT


{-| The URL of the embeddable content. For `audio`, `embed`, `iframe`, `img`,
`input`, `script`, `source`, `track`, and `video`.
-}
src : String -> Attribute msg
src url =
  Elm.Kernel.VirtualDom.attribute "src" (Elm.Kernel.VirtualDom.noJavaScriptOrHtmlUri url)


{-| Declare the height of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
height : Int -> Attribute msg
height n =
  Elm.Kernel.VirtualDom.attribute "height" (String.fromInt n)


{-| Declare the width of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
width : Int -> Attribute msg
width n =
  Elm.Kernel.VirtualDom.attribute "width" (String.fromInt n)


{-| Alternative text in case an image can't be displayed. Works with `img`,
`area`, and `input`.
-}
alt : String -> Attribute msg
alt =
  Elm.Kernel.VirtualDom.attribute "alt"



-- AUDIO and VIDEO


{-| The `audio` or `video` should play as soon as possible. -}
autoplay : Bool -> Attribute msg
autoplay =
  boolProperty "autoplay"


{-| Indicates whether the browser should show playback controls for the `audio`
or `video`.
-}
controls : Bool -> Attribute msg
controls =
  boolProperty "controls"


{-| Indicates whether the `audio` or `video` should start playing from the
start when it's finished.
-}
loop : Bool -> Attribute msg
loop =
  boolProperty "loop"


{-| Control how much of an `audio` or `video` resource should be preloaded. -}
preload : String -> Attribute msg
preload =
  Elm.Kernel.VirtualDom.attribute "preload"


{-| A URL indicating a poster frame to show until the user plays or seeks the
`video`.
-}
poster : String -> Attribute msg
poster =
  Elm.Kernel.VirtualDom.attribute "poster"


{-| Indicates that the `track` should be enabled unless the user's preferences
indicate something different.
-}
default : Bool -> Attribute msg
default =
  boolProperty "default"


{-| Specifies the kind of text `track`. -}
kind : String -> Attribute msg
kind =
  Elm.Kernel.VirtualDom.attribute "kind"


{-- TODO: maybe reintroduce once there's a better way to disambiguate imports
{-| Specifies a user-readable title of the text `track`. -}
label : String -> Attribute msg
label =
  Elm.Kernel.VirtualDom.attribute "label"
--}

{-| A two letter language code indicating the language of the `track` text data.
-}
srclang : String -> Attribute msg
srclang =
  Elm.Kernel.VirtualDom.attribute "srclang"



-- IFRAMES


{-| A space separated list of security restrictions you'd like to lift for an
`iframe`.
-}
sandbox : String -> Attribute msg
sandbox =
  Elm.Kernel.VirtualDom.attribute "sandbox"


{-| **DEPRECATED.** We would like to remove this in a future release. Please
prefer web components in cases where this might be useful.
-}
srcdoc : String -> Attribute msg
srcdoc =
  Elm.Kernel.VirtualDom.attribute "srcdoc"



-- INPUT


{-| Defines the type of a `button`, `checkbox`, `input`, `embed`, `menu`,
`object`, `script`, `source`, or `style`.
-}
type_ : String -> Attribute msg
type_ =
  Elm.Kernel.VirtualDom.attribute "type"


{-| Defines a default value which will be displayed in a `button`, `option`,
`input`, `li`, `meter`, `progress`, or `param`.
-}
value : String -> Attribute msg
value string =
  -- Note: `.value` has no corresponding attribute, so we have to set it
  -- using a property. It can also be modified by the user by typing in inputs.
  -- Properties are diffed against the actual DOM, not the virtual DOM, so
  -- this ensures that the DOM is up-to-date with the model.
  Elm.Kernel.VirtualDom.property "value" (Json.string string)


{-| Indicates whether an `input` of type checkbox is checked. -}
checked : Bool -> Attribute msg
checked =
  boolProperty "checked"


{-| Provides a hint to the user of what can be entered into an `input` or
`textarea`.
-}
placeholder : String -> Attribute msg
placeholder =
  Elm.Kernel.VirtualDom.attribute "placeholder"


{-| Defines which `option` will be selected on page load. -}
selected : Bool -> Attribute msg
selected =
  boolProperty "selected"



-- INPUT HELPERS


{-| List of types the server accepts, typically a file type.
For `input`.
-}
accept : String -> Attribute msg
accept =
  Elm.Kernel.VirtualDom.attribute "accept"


{-| List of supported charsets in a `form`.
-}
acceptCharset : String -> Attribute msg
acceptCharset =
  Elm.Kernel.VirtualDom.attribute "accept-charset"


{-| The URI of a program that processes the information submitted via a `form`.
-}
action : String -> Attribute msg
action uri =
  Elm.Kernel.VirtualDom.attribute "action" (Elm.Kernel.VirtualDom.noJavaScriptUri uri)


{-| Indicates whether a `form` or an `input` can have their values automatically
completed by the browser.

Note: These days, the autocomplete attribute can take more values than a boolean. For example, you can use this to autocomplete a street address:

    attribute "autocomplete" "street-address"
-}
autocomplete : Bool -> Attribute msg
autocomplete bool =
  Elm.Kernel.VirtualDom.attribute "autocomplete" (if bool then "on" else "off")


{-| The element should be automatically focused after the page loaded.
For `button`, `input`, `select`, and `textarea`.
-}
autofocus : Bool -> Attribute msg
autofocus =
  boolProperty "autofocus"


{-| Indicates whether the user can interact with a `button`, `fieldset`,
`input`, `optgroup`, `option`, `select` or `textarea`.
-}
disabled : Bool -> Attribute msg
disabled =
  boolProperty "disabled"


{-| How `form` data should be encoded when submitted with the POST method.
Options include: application/x-www-form-urlencoded, multipart/form-data, and
text/plain.
-}
enctype : String -> Attribute msg
enctype =
  Elm.Kernel.VirtualDom.attribute "enctype"


{-| Associates an `input` with a `datalist` tag. The datalist gives some
pre-defined options to suggest to the user as they interact with an input.
The value of the list attribute must match the id of a `datalist` node.
For `input`.
-}
list : String -> Attribute msg
list =
  Elm.Kernel.VirtualDom.attribute "list"


{-| Defines the minimum number of characters allowed in an `input` or
`textarea`.
-}
minlength : Int -> Attribute msg
minlength n =
  Elm.Kernel.VirtualDom.attribute "minLength" (String.fromInt n)


{-| Defines the maximum number of characters allowed in an `input` or
`textarea`.
-}
maxlength : Int -> Attribute msg
maxlength n =
  Elm.Kernel.VirtualDom.attribute "maxlength" (String.fromInt n)


{-| Defines which HTTP method to use when submitting a `form`. Can be GET
(default) or POST.
-}
method : String -> Attribute msg
method =
  Elm.Kernel.VirtualDom.attribute "method"


{-| Indicates whether multiple values can be entered in an `input` of type
email or file. Can also indicate that you can `select` many options.
-}
multiple : Bool -> Attribute msg
multiple =
  boolProperty "multiple"


{-| Name of the element. For example used by the server to identify the fields
in form submits. For `button`, `form`, `fieldset`, `iframe`, `input`,
`object`, `output`, `select`, `textarea`, `map`, `meta`, and `param`.
-}
name : String -> Attribute msg
name =
  Elm.Kernel.VirtualDom.attribute "name"


{-| This attribute indicates that a `form` shouldn't be validated when
submitted.
-}
novalidate : Bool -> Attribute msg
novalidate =
  boolProperty "noValidate"


{-| Defines a regular expression which an `input`'s value will be validated
against.
-}
pattern : String -> Attribute msg
pattern =
  Elm.Kernel.VirtualDom.attribute "pattern"


{-| Indicates whether an `input` or `textarea` can be edited. -}
readonly : Bool -> Attribute msg
readonly =
  boolProperty "readOnly"


{-| Indicates whether this element is required to fill out or not.
For `input`, `select`, and `textarea`.
-}
required : Bool -> Attribute msg
required =
  boolProperty "required"


{-| For `input` specifies the width of an input in characters.

For `select` specifies the number of visible options in a drop-down list.
-}
size : Int -> Attribute msg
size n =
  Elm.Kernel.VirtualDom.attribute "size" (String.fromInt n)


{-| The element ID described by this `label` or the element IDs that are used
for an `output`.
-}
for : String -> Attribute msg
for =
  Elm.Kernel.VirtualDom.attribute "for"


{-| Indicates the element ID of the `form` that owns this particular `button`,
`fieldset`, `input`, `label`, `meter`, `object`, `output`, `progress`,
`select`, or `textarea`.
-}
form : String -> Attribute msg
form =
  Elm.Kernel.VirtualDom.attribute "form"



-- RANGES


{-| Indicates the maximum value allowed. When using an input of type number or
date, the max value must be a number or date. For `input`, `meter`, and `progress`.
-}
max : String -> Attribute msg
max =
  Elm.Kernel.VirtualDom.attribute "max"


{-| Indicates the minimum value allowed. When using an input of type number or
date, the min value must be a number or date. For `input` and `meter`.
-}
min : String -> Attribute msg
min =
  Elm.Kernel.VirtualDom.attribute "min"


{-| Add a step size to an `input`. Use `step "any"` to allow any floating-point
number to be used in the input.
-}
step : String -> Attribute msg
step n =
  Elm.Kernel.VirtualDom.attribute "step" n


--------------------------


{-| Defines the number of columns in a `textarea`. -}
cols : Int -> Attribute msg
cols n =
  Elm.Kernel.VirtualDom.attribute "cols" (String.fromInt n)


{-| Defines the number of rows in a `textarea`. -}
rows : Int -> Attribute msg
rows n =
  Elm.Kernel.VirtualDom.attribute "rows" (String.fromInt n)


{-| Indicates whether the text should be wrapped in a `textarea`. Possible
values are "hard" and "soft".
-}
wrap : String -> Attribute msg
wrap =
  Elm.Kernel.VirtualDom.attribute "wrap"



-- MAPS


{-| When an `img` is a descendant of an `a` tag, the `ismap` attribute
indicates that the click location should be added to the parent `a`'s href as
a query string.
-}
ismap : Bool -> Attribute msg
ismap =
  boolProperty "isMap"


{-| Specify the hash name reference of a `map` that should be used for an `img`
or `object`. A hash name reference is a hash symbol followed by the element's name or id.
E.g. `"#planet-map"`.
-}
usemap : String -> Attribute msg
usemap =
  Elm.Kernel.VirtualDom.attribute "usemap"


{-| Declare the shape of the clickable area in an `a` or `area`. Valid values
include: default, rect, circle, poly. This attribute can be paired with
`coords` to create more particular shapes.
-}
shape : String -> Attribute msg
shape =
  Elm.Kernel.VirtualDom.attribute "shape"


{-| A set of values specifying the coordinates of the hot-spot region in an
`area`. Needs to be paired with a `shape` attribute to be meaningful.
-}
coords : String -> Attribute msg
coords =
  Elm.Kernel.VirtualDom.attribute "coords"



-- REAL STUFF


{-| Specifies the horizontal alignment of a `caption`, `col`, `colgroup`,
`hr`, `iframe`, `img`, `table`, `tbody`,  `td`,  `tfoot`, `th`, `thead`, or
`tr`.
-}
align : String -> Attribute msg
align =
  Elm.Kernel.VirtualDom.attribute "align"


{-| Contains a URI which points to the source of the quote or change in a
`blockquote`, `del`, `ins`, or `q`.
-}
cite : String -> Attribute msg
cite =
  Elm.Kernel.VirtualDom.attribute "cite"




-- LINKS AND AREAS


{-| The URL of a linked resource, such as `a`, `area`, `base`, or `link`. -}
href : String -> Attribute msg
href url =
  Elm.Kernel.VirtualDom.attribute "href" (Elm.Kernel.VirtualDom.noJavaScriptUri url)


{-| Specify where the results of clicking an `a`, `area`, `base`, or `form`
should appear. Possible special values include:

  * _blank &mdash; a new window or tab
  * _self &mdash; the same frame (this is default)
  * _parent &mdash; the parent frame
  * _top &mdash; the full body of the window

You can also give the name of any `frame` you have created.
-}
target : String -> Attribute msg
target =
  Elm.Kernel.VirtualDom.attribute "target"


{-| Indicates that clicking an `a` and `area` will download the resource
directly. The `String` argument determins the name of the downloaded file.
Say the file you are serving is named `hats.json`.

    download ""               -- hats.json
    download "my-hats.json"   -- my-hats.json
    download "snakes.json"    -- snakes.json

The empty `String` says to just name it whatever it was called on the server.
-}
download : String -> Attribute msg
download fileName =
  Elm.Kernel.VirtualDom.attribute "download" fileName


{-| Two-letter language code of the linked resource of an `a`, `area`, or `link`.
-}
hreflang : String -> Attribute msg
hreflang =
  Elm.Kernel.VirtualDom.attribute "hreflang"


{-| Specifies a hint of the target media of a `a`, `area`, `link`, `source`,
or `style`.
-}
media : String -> Attribute msg
media =
  Elm.Kernel.VirtualDom.attribute "media"


{-| Specify a URL to send a short POST request to when the user clicks on an
`a` or `area`. Useful for monitoring and tracking.
-}
ping : String -> Attribute msg
ping =
  Elm.Kernel.VirtualDom.attribute "ping"


{-| Specifies the relationship of the target object to the link object.
For `a`, `area`, `link`.
-}
rel : String -> Attribute msg
rel =
  Elm.Kernel.VirtualDom.attribute "rel"



-- CRAZY STUFF


{-| Indicates the date and time associated with the element.
For `del`, `ins`, `time`.
-}
datetime : String -> Attribute msg
datetime =
  Elm.Kernel.VirtualDom.attribute "datetime"


{-| Indicates whether this date and time is the date of the nearest `article`
ancestor element. For `time`.
-}
pubdate : String -> Attribute msg
pubdate =
  Elm.Kernel.VirtualDom.attribute "pubdate"



-- ORDERED LISTS


{-| Indicates whether an ordered list `ol` should be displayed in a descending
order instead of a ascending.
-}
reversed : Bool -> Attribute msg
reversed =
  boolProperty "reversed"


{-| Defines the first number of an ordered list if you want it to be something
besides 1.
-}
start : Int -> Attribute msg
start n =
  Elm.Kernel.VirtualDom.attribute "start" (String.fromInt n)



-- TABLES


{-| The colspan attribute defines the number of columns a cell should span.
For `td` and `th`.
-}
colspan : Int -> Attribute msg
colspan n =
  Elm.Kernel.VirtualDom.attribute "colspan" (String.fromInt n)


{-| A space separated list of element IDs indicating which `th` elements are
headers for this cell. For `td` and `th`.
-}
headers : String -> Attribute msg
headers =
  Elm.Kernel.VirtualDom.attribute "headers"


{-| Defines the number of rows a table cell should span over.
For `td` and `th`.
-}
rowspan : Int -> Attribute msg
rowspan n =
  Elm.Kernel.VirtualDom.attribute "rowspan" (String.fromInt n)


{-| Specifies the scope of a header cell `th`. Possible values are: col, row,
colgroup, rowgroup.
-}
scope : String -> Attribute msg
scope =
  Elm.Kernel.VirtualDom.attribute "scope"


{-| Specifies the URL of the cache manifest for an `html` tag. -}
manifest : String -> Attribute msg
manifest =
  Elm.Kernel.VirtualDom.attribute "manifest"


{-- TODO: maybe reintroduce once there's a better way to disambiguate imports
{-| The number of columns a `col` or `colgroup` should span. -}
span : Int -> Attribute msg
span n =
    Elm.Kernel.VirtualDom.attribute "span" (String.fromInt n)
--}
