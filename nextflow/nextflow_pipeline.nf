// Parameteres declared in 'nextflow.config'

// Channel for raw images 
images = Channel.fromPath("${params.input_dir}/*.tif")
    .map { file -> tuple(file.baseName, file) }

workflow {
    // Step 1 - Initial segmentation: Cellpose
    labels = SEGMENT( images )

    // Visualize segmentation masks
    masks = VISUALIZE( images.join( labels ) )

    // Step 2 - Automated corrections: TrackMate (???)
    // Step 3 - Manual segmentation: napari
    segmented = MANUAL_SEGMENT( images.join( labels ) )

    // Step 4 - Refining segmentation: Cellpose fine-tuning
}

process SEGMENT {
    publishDir "${params.output_dir}", mode: 'copy'

    input:
    tuple val(imageID), path(image)
    
    output:
    tuple val(imageID), path("*_cp_masks.tif")
    
    script:
    """
    export KMP_DUPLICATE_LIB_OK=TRUE    
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
    publishDir "${params.visual_dir}", mode: 'copy'

    input:
    tuple val(imageID), path(image), path(masks)

    output:
    path("${imageID}*.png") // How does this path() connect to publishDir?

    script:
    """
    python ${projectDir}/bin/visualize.py ${imageID} ${image} ${masks}
    """
}

process MANUAL_SEGMENT {
    publishDir "${params.output_dir}", mode: 'copy'

    input:
    tuple val(imageID), path(image), path(masks)

    output:
    tuple val(imageID), path(image), path("${imageID}_segmented.tif")

    script:
    """
    python ${projectDir}/bin/napari.py ${imageID} ${image} ${masks}
    """

}