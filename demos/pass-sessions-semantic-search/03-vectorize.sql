/*
Use 

https://github.com/Azure-Samples/azure-sql-db-vectorizer

to vectorize the data. Using the vectorizer, create two tables:

- [dbo].[pass_sessions_speakers_embeddings]
- [dbo].[pass_sessions_abstracts_embeddings]

to store vectors for the columns "speakers" and "abstract" respectively

*/

select top(5) * from [dbo].[pass_sessions_abstracts_embeddings]

select top(5) * from 
[dbo].[pass_sessions] s inner join 
[dbo].[pass_sessions_abstracts_embeddings] e on s.session_id = e.session_id
