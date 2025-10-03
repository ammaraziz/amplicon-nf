/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { CAT_CAT }              from '../modules/nf-core/cat/cat/main'
include { NEXTCLADE_DATASETGET } from '../modules/nf-core/nextclade/datasetget/main.nf'
include { NEXTCLADE_RUN }        from '../modules/nf-core/nextclade/run/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
workflow LINEAGE_CALL {
    take: ch_consensus // channel from amplicon-nf.nf 
    
    ch_nextclade_report = Channel.empty()
    nextclade_tag_ch = Channel.of(params.nextclade_dataset_tag ?: "")
    NEXTCLADE_DATASETGET (
        params.nextclade_dataset_name,
        nextclade_tag_ch
    )
    NEXTCLADE_RUN (
        ch_consensus,
        NEXTCLADE_DATASETGET.out.dataset
    )
    
    emit:
    ch_versions = NEXTCLADE_RUN.out.versions
    ch_nextclade_report = NEXTCLADE_RUN.out.tsv
}