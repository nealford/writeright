class DailyLogs
    private 
    @@Home_Dir = "c:/MyDocuments/Documents/"
  
  # begin: list of docs
  def doc_list
    docs = Array.new
    docs << "Sisyphus Project Planner.xls"
    docs << "TimeLog.xls"
    docs << "NFR.xls"
  end
  #end: list of docs

  def open_daily_logs
    # begin: win32
   excel = WIN32OLE.new("excel.application")
    #end:           win32
        
    workbooks = excel.WorkBooks
    excel.Visible = true
    doc_list.each do |f| 
      begin
        workbooks.Open(@@Home_Dir + f, true)
      rescue
        puts "Cannot open workbook:", @@Home_Dir + f
      end
    end
    excel.Windows.Arrange(7)
  end
end

