# Destiny
A simple, configurable ZSH prompt with no dependencies.
Destiny has been tested on Linux, macOS and iOS.

<image src="images/example.png" alt="example" width="500px" height="400px">

---

# How to install
A key point of Destiny is that it doesn't at all depend on Oh My ZSH. This means that you can just drop it into your .zshrc and it will work out of the box. You can also install it this way with Oh My ZSH. The way I'd recommend installing Destiny for any use case is by running the following commands:
```
git clone https://github.com/ja1dan/Destiny ~/.destiny && echo "source ~/.destiny/destiny" >> ~/.zshrc && source ~/.zshrc
```

# Customization
Another key point of Destiny is that it is very customizable. You can customize the colors of every prompt element, and even choose whether you want the username of your device to show when you're on SSH. With Destiny, you can cater everything to your tastes. Just edit the appropriate variables at the top of `destiny.zsh`.

# How to update
Destiny will be consistently updated by me. I'd recommend running `git pull` in `~/.destiny` (or wherever you have Destiny cloned) every once in a while to have the latest and greatest updates to your favorite prompt.