truncate table dbo.pass_sessions_abstracts_embeddings
truncate table dbo.pass_sessions_speakers_embeddings

/*
create schema [bck] authorization dbo
alter schema [bck] transfer dbo.pass_sessions_abstracts_embeddings
alter schema [bck] transfer dbo.pass_sessions_speakers_embeddings

drop table if exists dbo.pass_sessions_abstracts_embeddings
drop table if exists dbo.pass_sessions_speakers_embeddings

alter schema [dbo] transfer bck.pass_sessions_abstracts_embeddings
alter schema [dbo] transfer bck.pass_sessions_speakers_embeddings
*/

