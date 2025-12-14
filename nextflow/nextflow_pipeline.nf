images = Channel.fromPath("${params.input_dir}/*.tif")
    .map { file -> tuple(file.baseName, file) }

workflow {
    labels = SEGMENT( images )

    VISUALIZE( images.join( labels ) )
    // Segmentation evaluation metrics...
    
    // 2. Automated corrections with Trackmate in FIJI

    // 3. Manual Segmentation with Napari
    // MANUAL_SEGMENTATION( labels )

    // 4. Cellpose fine-tuning

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