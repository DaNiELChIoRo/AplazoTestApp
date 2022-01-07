# Aplazo Interview Test App
This is a test project for Aplazo Company hire.

## Architecture
The arquictecture decided to use is MVVM along with SwiftUI since it is one of the most flexible combination abilable on the market.

## Networking
For the networking it is handle by Task async/await on swift which is a new fancy approach that helps by saving time and making scalable more smooth.
Along with URLSession manual implementation, Routerable approach is not taken due to the small amout and fast delivery time used on this test.

### Usage

The App usage is pretty much intuitube, though. Every time we hit the Random Meal (shuffle icon) button on the upper right corner of the dash board on the app we get a random Meal modal with a breaf overview of the given meal. In order to remove it, just scroll down the modal (sheet)
