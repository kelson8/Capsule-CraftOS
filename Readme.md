# Capsule package manager for CC Tweaked
This is a package manager for the CC Tweaked Minecraft mod, this also work on CraftOS-PC on the desktop.


### Setting up capsule
To setup the Capsule package manager on a computer.

1. Run the installer from my Github, otherwise it won't download the library files: `wget run https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/src/capsule.lua`

2. Then, install it from my GitHub to the root of your computer: `wget https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/src/capsule.lua`

3. Lastly, run the `capsule update` command to update the repository list.

I normally add this to my startup.lua on the root of a computer:
```lua
-- This is mostly for the capsule programs.
if fs.exists("/usr/bin") then
    shell.setPath(shell.path() .. ":/usr/bin")
end
```

Which adds the `/usr/bin` folder to the path, so you don't have to switch to that directory each time to run the programs.

You can also copy the [extras/startup.lua](https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/extras/startup.lua) file into the root of your computer, this file will also clear the monitor if it finds one.

### Using capsule
To use the capsule package manager

**Installing packages**

You can use `capsule install package-name.lua` on a ComputerCraft computer, replace `package-name.lua` with a value from the `repo.json`. 

**List packages**

To list installed package, use `capsule list --installed`, this will display a list of all packages installed with Capsule package manager.

**Removing packages**

To remove a package: `capsule remove package-name.lua`

**Updating packages**

To update all packages out of date: `capsule upgrade`

**Display capsule version**

To display the current version for capsule.lua: `capsule version`

### Capsule files

**Files in project**

**Src folder**

| Filename | Description |
| --------- | ----------- |
| chacha20-text.lua  | Chacha20 encryption/decryption, takes either a `decrypt` or `encrypt` argument. |
| display_disk_space.lua | |
| generator_ui.lua | This is mostly for turning on/off my generator created with Create Power grid, all it does is turn on/off a redstone link and store the value of the status into `/disk/generator_status.txt` |
| monitor_test.lua | Basic test to write to the bottom center of a monitor. |


**Lib folder**
| Filename | Description |
| --------- | ----------- |
| args.lua | Argument parser functions. |
| basalt.lua | Basalt UI library, licensed under MIT. |
| config.lua | Looks like this is for the values from the `package.list` file. |
| logger.lua | Logging to a file and to the console, used in `capsule.lua`. |
| print-utils.lua | For the scrolling text in `capsule.lua` |
| stringbuilder.lua | Stringbuilder library. |
| crypto/sha2.lua | SHA2 hashing utility. |
| util/hash_util | Hash utilities, mostly for converting bytes to hex and hex back to bytes for the chacha20 encryption. |
| utils/monitor_util | Write to center, and write to specific spot on monitor functions. |
| utils/text_util | So far, just reading lines from text files. |


## Adding files to capsule

You can add lua files to be downloaded into the `repo.json` file.

Here is an example using my Github. Set the name, author, version, description, SHA-256 checksum and download link.

```json
    {
        "name": "display_disk_space.lua",
        "author": "kelson8",
        "version": {
            "major": 1,
            "minor": 0,
            "patch": 0
        },
        "desc": "Display free space on a computer internal storage and floppy disk if inserted",
        "checksum": "7ce254a5aef05cb7bdd978810a9e640b15e1b25ce9a220d66c67e2e46e0746f7",
        "dwn_lnk": "https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/src/display_disk_space.lua"
    },
```

# Credits

Credit to this forum post on the ComputerCraft forums, some in the lib folder except for the util folder, capsule.lua, and repo.json are from here.

List of files that came from here:
crypto/sha2.lua, args.lua, config.lua, logger.lua, print-utils.lua, and stringbuilder.lua.

Computer Craft forum post about capsule.
* https://forums.computercraft.cc/index.php?topic=652.0

I have modified this, and made it download the files from my GitHub.

All source files in the `lib` folder that were not created by me have been labeled with their pastebin sources.

Credit goes to Pyroxenium for the [Basalt2](https://github.com/Pyroxenium/Basalt2) UI library in `/lib/basalt.lua`.
