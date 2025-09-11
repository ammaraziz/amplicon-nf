process ARTIC_GET_SCHEME {
    label "process_single"

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
        ? 'oras://community.wave.seqera.io/library/artic:1.8.4--1f9246bebdff8da5'
        : 'community.wave.seqera.io/library/artic:1.8.4--464dd0e425a760e9'}"

    input:
    tuple val(meta), path(fastq_1), path(fastq_2)
    path store_directory

    output:
    tuple val(meta), path(fastq_1), path(fastq_2), path("primer.bed"), path("reference.fasta"), emit: reads_and_scheme
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    scheme_split = meta.scheme.split("/")

    """
    artic_get_scheme \\
        --scheme-directory ${store_directory}/amplicon-nf/primer-schemes/ \\
        --scheme-name ${scheme_split[0]} \\
        --scheme-length ${scheme_split[1]} \\
        --scheme-version ${scheme_split[2]} \\
        --read-file ${fastq_1}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        artic: \$(artic -v 2>&1 | sed 's/^.*artic //; s/ .*\$//')
    END_VERSIONS
    """
}
