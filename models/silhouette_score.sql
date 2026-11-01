{{
  config(
    materialized='incremental',
    unique_key=['imdbid', 'id'],
    incremental_strategy='merge'
  )
}}

SELECT INTRA.imdbid, INTRA.id, (nearest_cluster_distance - intra_cluster_distance) / (CASE WHEN nearest_cluster_distance > intra_cluster_distance THEN nearest_cluster_distance ELSE intra_cluster_distance END)
  AS silhouette_score
FROM {{ref('stg_intra_cluster_distance')}} AS INTRA
INNER JOIN {{ref('stg_nearest_cluster_distance')}} AS NEAREST
  ON INTRA.id = NEAREST.id
{% if is_incremental() %}
  -- Only pull records created since the last run
  WHERE INTRA.id NOT IN (select id from {{ this }})
{% endif %}
