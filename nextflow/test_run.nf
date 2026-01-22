// Data
params.inputDir = "/Users/wei-tunghsu/labelled_data/raw_test"
params.outputDir = "/Users/wei-tunghsu/labelled_data/results"


// Creating channel for raw images
images = Channel.fromPath("${params.inputDir}/*.tif")
    .map { file -> tuple(file.baseName, file) }

workflow {
    // Segment raw images
    labels = SEGMENT( images )

    // Measure using original images and generated labels
    MEASURE( images.join( labels ) )
}

process SEGMENT {
    input:
    tuple val(imageID), path(image)
    
    output:
    tuple val(imageID), path("*_cp_masks.tif")
    
    script:
    """
    cellpose --image_path ${image} --pretrained_model cyto --save_tif
    """
}


process MEASURE {
    publishDir "${params.outputDir}", mode: 'copy'
    input:
    tuple val(imageID), path(image), path(labels)
    
    output:
    path("*csv")
    
    script:
    """
    /Applications/Fiji/Fiji --run measure.groovy "${image}, ${labels}, ${imageID}.csv"
    """
}

//test