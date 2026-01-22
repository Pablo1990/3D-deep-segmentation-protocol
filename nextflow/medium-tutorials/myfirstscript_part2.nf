// Declaring parameters
params.inputDir = "Hello World"
params.outputDir = "/Users/wei-tunghsu/Downloads"
params.greetings = "Hello,Hola,Bonjour,Ciao"  // Multiple greetings


workflow {
    // Create a channel from parameter (comma-separated values)
    greeting_ch = Channel.of(params.greetings.split(','))
    
    // Pass channel to process - will execute once per greeting
    PRINT_HELLO_WORLD(greeting_ch) | view
    
    // Download multiple hello world files - adding '| view' will display download paths
    DOWNLOAD_HELLO_WORLD(greeting_ch)
}

process PRINT_HELLO_WORLD {
    input:
        val greeting
    
    output:
        stdout

    script:
    """
    echo "${greeting} World"
    """
}

process DOWNLOAD_HELLO_WORLD {
    publishDir params.outputDir, mode: 'copy'
    
    input:
        val greeting

    output:
        path("hello_world_${greeting}.txt")

    script:
    """
    echo "${greeting} World" > hello_world_${greeting}.txt
    """
}