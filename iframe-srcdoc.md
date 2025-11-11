# iframe srcdoc security

There used to be an `Html.Attributes.srcdoc` function. Well, there technically still is one, but all it does is take you here. As it turns out, `srcdoc` on an iframes is a security issue. It allows Elm packages to execute JavaScript code without you knowing. Maybe you thought you were rendering an icon from a package, but behind the scenes it also stole all data on your page. Oops!

If you have code like this:

```elm
Html.iframe [ Html.Attributes.srcdoc myHtml ] []
```

Then you can change it to a web component:

```elm
Html.node "my-iframe" [ Html.Attributes.attribute "html" myHtml ] []
```

```js
/**
 * This custom element forwards the `html` attribute to `srcdoc` on an `iframe`.
 *
 * Example:
 *
 *     <my-iframe html="<p>Hello</p>"></my-iframe>
 *
 * Becomes:
 *
 *     <my-iframe html="<p>Hello</p>">
 *          <iframe srcdoc="<p>Hello</p>" sandbox=""></iframe>
 *     </my-iframe>
 */
customElements.define(
    'my-iframe',
    class extends HTMLElement {
        iframe = document.createElement('iframe');

        connectedCallback() {
            // It's important to set `sandbox` on iframes for security.
            // https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/iframe#sandbox
            this.iframe.sandbox = '';
            this.appendChild(this.iframe);
        }

        // Note: You can't call the attribute `srcdoc` even on the custom element.
        // For simplicity, Elm forbids that name regardless of element.
        // Simply choose another name.
        static observedAttributes = ['html'];

        attributeChangedCallback(name, _oldValue, newValue) {
            switch (name) {
                case 'html':
                    if (newValue === null) {
                        this.iframe.removeAttribute('srcdoc');
                    } else {
                        this.iframe.setAttribute('srcdoc', newValue);
                    }
                    break;
            }
        }
    }
);
```

Why is a web component safer than using an iframe directly? The difference is that an Elm package can't ship the JavaScript web component definition, only the Elm code that tries to render it. And with the web component, you can guarantee that the `sandbox` attribute is set _before_ `srcdoc`.
