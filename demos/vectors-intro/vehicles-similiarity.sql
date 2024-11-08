declare @car vector(1536), @plane vector(1536), @truck vector(1536);

exec get_embedding 'text-embedding-3-small', 'car', @car output;
exec get_embedding 'text-embedding-3-small', 'plane', @plane output;
exec get_embedding 'text-embedding-3-small', 'truck', @truck output;

drop table if exists #vehicles;
create table #vehicles (vehicle nvarchar(100), embedding vector(1536));
insert into #vehicles values 
('car', @car),
('plane', @plane),
('truck', @truck)
go

select * from  #vehicles

select 
    ve1.vehicle,
    ve2.vehicle,
    round(vector_distance('cosine', ve1.embedding, ve2.embedding), 2) as distance -- similarity search -- 0 => most similar
from #vehicles ve1 cross join #vehicles ve2
order by distance


