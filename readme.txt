The overall layout is very similar to the setup for Lab 6. Add all of the SV files into the project, making sure to
include the lab62_soc.qip as well. The top level for this project will just be lab62.sv, once again similar to Lab 6. Otherwise,
all necessary modules should not require further linkage apart from adding to the base project. 

Once the physical part compiles and is built onto the FPGA, the next step is to work with the NIOS II software. After opening up the
workspace in Eclipse, follow the general procedure from lab. First, generate the BSP for our project, and then Build All. Finally,
make sure to refresh the connection before configuring the running settings for the software, which is mainly used to handle the USB
throughput.

The expected output is very straightforward. As soon as the program builds onto the FPGA, you should see a basic game of Tetris being
displayed on the center of the screen. The Eclipse program allows us to use our keyboard to control the game. The WASD keys are used to
move the Tetromino in any cardinal direction. The arrow keys will be used to turn the Tetromino both clockwise and counterclockwise.

The game becomes progressively faster as you accumulate score, which is visible on the on-board hex displays. The game continues, generating
random Tetrominos using the LSFR until it tries to spawn in the Tetromino at an alread occupied space. At this time, the game ends and an
"End" screen is displayed to the player.