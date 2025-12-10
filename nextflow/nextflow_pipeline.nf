// Parameteres declared in 'nextflow.config'

// Channel for raw images 
images = Channel.fromPath("${params.input_dir}/*.tif")
    .map { file -> tuple(file.baseName, file) }

workflow {
    // Segment raw images
    labels = SEGMENT( images )

    // Visualize segmentation masks
    VISUALIZE( images.join( labels ) )

    // Measure using original images and generated labels
    // MEASURE( images.join( labels ) )
}

process SEGMENT {
    input:
    tuple val(imageID), path(image)
    
    output:
    tuple val(imageID), path("*_cp_masks.tif")
    
    script:
    """    
    cellpose --save_tif --Zstack --verbose \
    --image_path ${image} \
    --pretrained_model ${params.cellpose.pretrained_model} \
    --chan ${params.cellpose.chan} \
    --diameter ${params.cellpose.diameter} \
    --stitch_threshold ${params.cellpose.stitch_threshold} \
    --dP_smooth ${params.cellpose.dP_smooth} \
    --anisotropy ${params.cellpose.anisotropy}
    """
}

process VISUALIZE {
    publishDir "${params.viz_dir}", mode: 'copy'

    input:
    tuple val(imageID), path(image), path(masks)

    output:
    path("${imageID}*.png")

    script:
    """
    python /Users/wei-tunghsu/nextflow-sandbox/bin/visualize.py
    """

}


/*
process MEASURE {
    publishDir "${params.output_dir}", mode: 'copy'
    input:
    tuple val(imageID), path(image), path(labels)
    
    output:
    path("*csv")
    
    script:
    """
    /Applications/Fiji/Fiji --run measure.groovy "${image}, ${labels}, ${imageID}.csv"
    """
}
*/