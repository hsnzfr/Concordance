
set nocount on

declare @KW varchar(100)
set @KW=' tramatic ' -- the pattern (keyword) to be searched. NOTE, for some patterns its important to add a space before or after it or not!
declare crsr cursor  forward_only

for 
SELECT patient_id,con,ptsd   FROM [EncounterNotesExp_gropued] 
  where  con like  '%' +@KW+ '%' 



declare @old_hit int = 0
declare @hit int = 0
declare @count int = 0
declare @span_width int = 66 -- number of characters to be shown after and before the pattern found
declare @i int = 0
declare @s varchar(max)
declare @kws varchar(max)
declare @Patient_id numeric(18, 0)
declare @flag  int,@ptsd int


open crsr
declare @allPatterns varchar(max)
fetch next from crsr into @Patient_id,@s,@ptsd
set @flag=0
 while(@@FETCH_STATUS<>-1)
   begin --tt
   set @count=@count+1
   print (CHAR(13)+CHAR(10)+'------- '+cast(@count as varchar(3))+'------------------ '+cast(@Patient_id as varchar(12))+'------------------- '+cast(@ptsd as varchar(3))+'---')

  -----------------------------
       set @flag=0
       set @hit = 0
       set @old_hit = 0
       set @i  = 0
       set @allPatterns=''
       while @i<len(@s)
          begin -- process content
           set @hit=charindex(@KW,@s,@i)
           if @hit>@old_hit 
             begin -- if
               set @flag=1
               set @allPatterns=@allPatterns+'   ....'+ substring(@s,@hit-@span_width,2*@span_width+len(@KW))+'... '+ CHAR(13)+CHAR(10) 
                set @old_hit =@hit
               set @i=@hit+1
             end --if
           else
             break
          end-- process content
       if @flag=1
         begin --if
           print @allPatterns
         end
  fetch next from crsr into @Patient_id,@s,@ptsd
   end
close crsr
deallocate crsr
