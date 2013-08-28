require 'rubygems'
require 'win32ole'
if RUBY_VERSION=~/1\.9\../
  require_relative 'SettingHandle'
  require_relative 'DBHandle'
  require_relative 'UserHandle'
else
  require 'SettingHandle'
  require 'DBHandle'
  require 'UserHandle'
end



#---------------main------------------
#setup logger
@logger=Logger.new("log.txt","daily")

#create ole object
@shell=WIN32OLE.new("shell.application")


#connect to database
@dbselect=DBHandle.new(SettingHandle::DBTYPE,SettingHandle::DBHOST,SettingHandle::DBID,SettingHandle::DBPW,SettingHandle::DBSID)
@logger.info("DicomCQuery_Batch : #{SettingHandle::DBHOST},#{SettingHandle::DBSID} connect ok.")
@dbdo=DBHandle.new(SettingHandle::DBTYPE,SettingHandle::DBHOST,SettingHandle::DBID,SettingHandle::DBPW,SettingHandle::DBSID)
@logger.info("DicomCQuery_Batch : #{SettingHandle::DBHOST},#{SettingHandle::DBSID} connect ok.")



#get EMR not complete record DICOM image
begin  
  sql="select "
  sql+="* "
  sql+="from " 
  sql+="db2inst1.EecTDcmLogTbl "
  sql+="where "
  sql+="RESULT_VALUE='90001' or RESULT_VALUE='49413' "
  @dbselect.dbh.select_all(sql) do |rec|
    accessionno=rec["ACCESSIONNO"]
    patientid=rec["CHARTNO"]
    
    #call movescu to Dicom C-Query
    flag=system("#{SettingHandle::APPPATH}#{SettingHandle::APPNAME} #{SettingHandle::MODE} #{SettingHandle::AETITLE} #{SettingHandle::CALL} #{SettingHandle::QUERYLEVEL} #{SettingHandle::QUERYRESULTLEVEL} -k 0010,0020=#{patientid} -k 0008,0050=#{accessionno} #{SettingHandle::IP} #{SettingHandle::PORT}")
    @logger.info("DicomCQuery_Batch : C-Move accessionno=#{accessionno}, patientid=#{patientid}.")
	if !flag
		sql="update "
		sql+="db2inst1.EecTDcmLogTbl "
		sql+="set "
		sql+="RESULT_VALUE=#{1} "
		sql+="where "
		sql+="ACCESSION=#{accessionno} and "
		sql+="CHARTNO=#{patientid} "
		@dbdo.dbh.do(sql)
		@logger.info("DicomCQuery_Batch : C-Move faild.")
	end
  end
  
  @logger.info("DicomCQuery_Batch : ended.")
rescue => e
  @logger.debug("DicomCQuery_Batch : crashed.")
  @logger.debug(e)
ensure
  @db.dbh.disconnect() if @db!=nil
  @logger.info("DicomCQuery_Batch : closed database.")
end