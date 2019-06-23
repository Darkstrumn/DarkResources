function DebugPrint(header,msg,errorLevel)
  head='Debug: '
  el='Notice'
  if(errorLevel) then
    el=errorLevel
  end--</if>
  if(header) then
    head=header
  end--</if>
  message=header..msg
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
