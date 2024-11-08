/*
    Get the embeddings for the input text by calling the OpenAI API
    and then search the most similar articles (by title)
    Note: <deployment-id> needs to be replaced with the deployment name of your embedding model in Azure OpenAI
*/

declare @inputText nvarchar(max) = 'database performance monitoring for azure sql';
declare @retval int, @embedding vector(1536);

exec @retval = dbo.get_embedding '<deployment-id>', @inputText, @embedding output;

select top(10)
   a.*,
   least(
        vector_distance('cosine', @embedding, b.embedding),
        vector_distance('cosine', @embedding, c.embedding)
    ) as distance_score
from
    [dbo].[pass_sessions] a
left join  
    [dbo].[pass_sessions_speakers_embeddings] b on a.session_id = b.session_id
left join  
    [dbo].[pass_sessions_abstracts_embeddings] c on a.session_id = c.session_id
order by
    distance_score;
go

