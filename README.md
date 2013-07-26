# Neural network implementation in Octave

## configuration

copy `config.sample.csv` to `config.csv` and change the options. The configuration options are loaded in a struct with:

```
config = config();
```

After that, options are available with

```
config.layers
config.input_path
```

New variables will be added automatically when added to the config file

### input_path
The value of this field can be both relative and absolute. Use `./` for input files in the same folder as `main.m`. The `main.m` script requires one command line argument, which is the name of the input file (without .csv). The input file is retrieved from the folder in the `input_path` variable. The csv with the output variables should have the same name, but should end with `-out.csv`. Both the input and the output file should have integers, separated with comma's (`,`). The output file only has 0 and 1 values. Do not confuse the `output` file with the saved weights file.

### layers
the `layers` option is the number of layers in the neural network. Please enter a value of 2 or higher! A network with 2 layers has 1 output layer and 1 internal layer (also known as a perceptron). A network with 1 layer can only learn linear divisable models, which can be calculated with a single comparison.

### layer_size
The number of neurons in each internal layer. 

When `layers` is equal to 2, the only internal layer has the `layer_size` neurons. The matrix of weights between the input layer and the internal layer has `layer_size * input_size` values, with `input_size` the number of columns in the input csv file.

Also when `layers` is equal to 2, the weight matrix between the only internal layer and the output layer has `layer_size * output_size` values, with `output_size` the number of columns in the output csv file.

## input

