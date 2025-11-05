// Channel for raw images
images = Channel.fromPath("${params.input_dir}/*.tif")
    .map { file -> tuple(file.baseName, file) }

workflow {
    // Segment raw images
    labels = SEGMENT( images )

    // Measure using original images and generated labels
    MEASURE( images.join( labels ) )
}

process SEGMENT {
    publishDir "${params.output_dir}", mode: 'move'

    input:
    tuple val(imageID), path(image)
    
    output:
    tuple val(imageID), path("*_cp_masks.tif")
    
    script:
    """
    cellpose --image_path ${image} \
    --pretrained_model ${params.cellpose.model} \
    --diameter ${params.cellpose.diameter} \
    --cellprob_threshold ${params.cellpose.cellprob_threshold} \
    --flow_threshold ${params.cellpose.stitch_threshold} \
    --save_tif
    """
}



process MEASURE {
    publishDir "${params.output_dir}", mode: 'move'
    input:
    tuple val(imageID), path(image), path(labels)
    
    output:
    path("*csv")
    
    script:
    """
    /Applications/Fiji/Fiji --run measure.groovy "${image}, ${labels}, ${imageID}.csv"
    """
}
