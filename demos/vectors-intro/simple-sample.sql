declare @v1 vector(3) = '[1,2,3]'
declare @v2 vector(3) = '[3,4,5]'
select @v1, @v2

select vector_distance('cosine', @v1, @v2)

