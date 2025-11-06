// Declaring parameters
params.inputDir = "Hello World"

// Declaring process PRINT_HELLO_WORLD
process PRINT_HELLO_WORLD {
    output:
        stdout

    script:
    """
    echo ${params.inputDir}
    """
}

// Declaring workflow - display "Hello World" in terminal
workflow {
    PRINT_HELLO_WORLD() | view
}