# VoiceRubyKit

This gem implements a quick back-end service for deploying Alexa and Google Assistant applications.

## Installation

Add this line to the gemfile:
```ruby
gem "voice-ruby-kit", github: "Onlim/voice-ruby-kit", branch: "master"
```

then run:
```ruby
bundle install
```

## Usage

The library consists of two main functionalities:
1. processing the alexa/assistant request
2. creating alexa/assistant response

### Request

To process alexa request, use this code.

```ruby
    alexa_request = VoiceRubyKit::Alexa.build_request(JSON.parse(request))
```
or for Assistant

```ruby
    assistant_request = VoiceRubyKit::Assistant.build_request(JSON.parse(request))
```

The request is processed by `build_request`, which checks what was received. Supported request types:
- Intent request
- Launch request
- Option request (Display.ElementSelected)
- Session ended request

This request processes a lot of additional attributes from voice assistants like:
- Amazon API
- Alexa Geolocation
- Alexa and Assistant interfaces
- Alexa scopes
- Alexa and Assistant sessions
- Alexa and Assistant slots

Some usages for requests:

```ruby
  assistant_request = VoiceRubyKit::Assistant.build_request(JSON.parse(request))

  case assistant_request
     when ::VoiceRubyKit::Requests::LaunchRequest
       # do something when launch request
     when ::VoiceRubyKit::Requests::OptionRequest
       # do something when option request
     else
       # otherwise handle intent request (in google assistant it is not real intent request, but we receive only user text request)
     end
```

You can have a look if the device supports display, for example:

```ruby
if assistant_request.display?
  # return rich data for display devices
end
```

or you can check if you have granted permissions for geolocation:
```ruby
if alexa_request.geolocation.available? && alexa_request.scope.granted?('alexa::devices:all:geolocation:read')
  # do something cool
end
```
### Response

You can use this library also for creating proper responses for alexa or google assistant. Some actions are supported for both platforms, and some are only by alexa.
The first step is to initialize response:

```ruby
alexa_response = VoiceRubyKit::Alexa.response(alexa_request)
```

or 

```ruby
assistant_response = VoiceRubyKit::Assistant.response(assistant_request)
```

Then you can add a bunch of response objects that will be sent to the voice assistant.

#### Reprompt

````ruby
assistant_response.add_reprompt('What can I help you?')
````

#### Speech

```ruby
assistant_response.add_speech('This is spoken text')
```

#### Alexa Permission requests
You can also request permission for some user data in alexa:
```ruby
alexa_response.add_permission_card(['alexa::devices:all:geolocation:read'])
```

#### Card
````ruby
alexa_response.add_card({
                          type: "Standard",
                          title: title,
                          text: subtitle,
                          image: {
                            smallImageUrl: image_url,
                            largeImageUrl: large_image_url
                          }
                        })
````

#### Session
Also, you can save session attributes which are then preserved during the session.
```ruby
alexa_response.add_session_attribute(key, value)
```

#### Should End Session
Sometimes you would like to add a flag, that conversation ended.
```ruby
asssitant_response.add_should_end_session(true)
```

### Alexa APL templates
Alexa dropped support for Display Templates, instead of it is using new APL language for displaing content. Here is small example of usage prebuild APL templates:
```ruby
message = {
  type: 'AlexaDetail',
  detailType: "generic",
  detailImageAlignment: "right",
  headerTitle: title,
  headerSubtitle: nil,
  bodyText: subtitle,
  primaryText: title
}

if background_image_content.present?
  message[:backgroundImageSource] = background_image_url
  message[:imageBlurredBackground] = false
end

if image_url.present?
  message[:imageSource] = image_url
  message[:imageAspectRatio] = "square"
end

responder.add_apl_directive(message)
```

#### Alexa Directives
For more complicated responses, you can send alexa directives.
```ruby
directives << message.to_directive
alexa_response.instance_variable_set("@directives", directives)
```

#### Final steps
After adding all response messages to the response object, you need to build JSON response out of it:
```ruby
response_json = alexa_response.build_response
```
