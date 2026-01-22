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
    slices = CONVERT( segmented )
    images = VISUALIZE_TRAINING( slices )
    = SPLIT_TRAINING(  )
    training_labels = MODEL_TRAINING( slices )
}


// 1. INITIAL SEGMENTATION: CELLPOSE
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

// 3. MANUAL SEGMENTATION
process MANUAL_SEGMENT {
    publishDir "${params.output_dir}", mode: 'copy'

    input:
    tuple val(imageID), path(image), path(masks)

    output:
    tuple val(imageID), path(image), path("${imageID}_segmented.tif")

    script:
    """
    python ${projectDir}/bin/napari_segment.py ${imageID} ${image} ${masks}
    """
}

// 4. REFINING THE SEGMENTATION: CELLPOSE FINE-TUNING
process CONVERT {
    publishDir "${params.output_dir}/2d_slices", mode: 'copy'

    input:
    tuple val(imageID), path(image), path(masks)

    output:
    tuple path("raw_slices/*"), path("mask_slices/*")

    script:
    """
    python ${projectDir}/bin/convert_slices.py . raw_slices false
    python ${projectDir}/bin/convert_slices.py . mask_slices true
    """
}

/*
process VISUALIZE_TRAINING {
    publishDir "${params.visual_train_dir}", mode: 'copy'

    input:
    tuple path("raw_slices/*"), path("mask_slices/*")

    output:
    path("*.png")

    script:
    """
    python ${projectDir}/bin/visualize_training.py . .
    """
}
*/

process MODEL_TRAINING {
    publishDir "${params.output_dir}/training", mode: 'copy'

    input:
    tuple path(raw_slices), path(mask_slices)

    output:
    path

    script:
    """
    python -m cellpose --verbose --train \
    --dir ${train_dir} \
    --pretrained_model ${initial_model} \
    --chan ${params.train.chan} \
    --n_epochs ${n_epochs} \
    --learning_rate ${learning_rate} \
    --weight_decay ${weight_decay} \
    --model_name_out ${model_name}
    """
}