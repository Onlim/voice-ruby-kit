module VoiceRubyKit
  module Channels
    module Helpers
      class Apl
        class << self
          def directive(items)
            {
              type: 'Alexa.Presentation.APL.RenderDocument',
              version: '1.0',
              document: document(items)
            }
          end

          def document(items)
            {
              type: 'APL',
              version: '1.7',
              import: [
                {
                  name: 'alexa-layouts',
                  version: '1.4.0'
                }
              ],
              mainTemplate: {
                parameters: [
                  'payload'
                ],
                items: [
                  items
                ]
              }
            }
          end
        end
      end
    end
  end
end
