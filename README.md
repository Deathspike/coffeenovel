# CoffeeNovel

A visual novel engine written with open web technologies.

## Acknowledgements

  1. Inspired by the Ren'Py visual novel engine.
  2. Game 'The Question' is an adaptation of the Ren'Py game (http://games.renpy.org/game/question.shtml).

## Building

  1. Install nodejs (http://nodejs.org/)
  2. Install required modules. Use the command line to navigate to folder and run `npm install`
  3. Run the CoffeeScript compiler from `bin\coffee`. This compiles `CoffeeScript` to `JavaScript`
  4. Run the application server from `bin\app`. This will start a web server and bundle files.
  5. Play your game at http://localhost/

## Dependencies

  1. jQuery 1.9.x (http://jquery.com/)
  2. jQuery Transition 0.9.X (http://ricostacruz.com/jquery.transit/)

## Releasing (No Installation)

  1. Upload the files in the `public` folder to your web server and serve as static content.
  2. Remove unnecessary `.coffee` files to prevent easy access to your scenarios.
  3. Example is live at http://roelvanuden.nl/coffeenovel/

## Status

This project is in alpha stage and will undergo significant changes and improvements.
