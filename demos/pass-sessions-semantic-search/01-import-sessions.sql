/*
	Import JSON values (Sessions and speakers)
*/
drop table if exists #s1; 
select 
    se.sessionCode,
    se.title,
    se.abstract,
    sp.fullName
into    
    #s1
from 
    openrowset(bulk 'pass2024/sessions-escaped.json', data_source = 'openai_playground', codepage = '65001', single_clob) c
cross apply
    openjson(c.BulkColumn) with (
        sessionCode int,
        title nvarchar(1000),
        abstract nvarchar(max),
        published nvarchar(100),
        [status] nvarchar(100),
        participants nvarchar(max) as json -- will support JSON data type soon
    ) se
cross apply
    openjson(se.participants) with 
    (
        fullName nvarchar(1000)
    ) sp
go

select * from #s1;

/*
	Import JSON values (Sessions and properties)
*/
drop table if exists #s2; 
select 
    se.sessionCode,
    a.attribute,
    a.[value] as attributeValue
into    
    #s2
from 
    openrowset(bulk 'pass2024/sessions-escaped.json', data_source = 'openai_playground', codepage = '65001', single_clob) c
cross apply
    openjson(c.BulkColumn) with (
        sessionCode int,
        attributeValues nvarchar(max) as json
    ) se
cross apply
    openjson(se.attributeValues) with 
    (
        attribute nvarchar(1000),
        [value] nvarchar(1000)
    ) a
where a.attribute in ('Session Type', 'Session Category', 'Track', 'Level')
go

select * from #s2;

/*
	Create session table
*/
drop table if exists dbo.pass_sessions;
with s1 as 
(
    select 
        sessionCode as session_id,
        title,
        abstract,
        json_arrayagg(fullName) as speakers
    from 
        #s1
    group by
        sessionCode, title, abstract
), 
s2 as (
    select 
        sessionCode as session_id,
        cast(json_objectagg(attribute:attributeValue) as json) as properties
    from 
        #s2
    group by
        sessionCode
)
select
    s1.session_id,
    s1.title,
    s1.abstract,
    cast(s1.speakers as json) as speakers,
    cast(s2.properties as json) as properties
into    
    dbo.pass_sessions
from
    s1
inner join 
    s2 on s1.session_id = s2.session_id
go

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'pass_sessions'
go

update
    [dbo].[pass_sessions]
set
    [properties] = json_modify(properties, '$.Level', cast(left(json_value([properties], '$.Level'), 4) as int)) 
go

alter table dbo.pass_sessions
alter column session_id int not null
go

alter table dbo.pass_sessions
add constraint pk__pass_sessions primary key (session_id)
go

select * from dbo.pass_sessions
go

