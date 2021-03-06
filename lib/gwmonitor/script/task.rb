class Gwmonitor::Script::Task < System::Script::Base

  def self.delete
    run do
      item = Gwmonitor::Itemdelete.where(content_id: 0).first
      log "管理情報の登録なし" and next if item.blank?

      limit = eval(item.limit_date.to_s).try(:ago)
      log "管理情報の期間設定が無効: #{item.limit_date}" and next if limit.blank?

      log "照会・回答期限切れデータ削除処理: #{I18n.l(limit)} 以前を削除" do
        del = destroy_record(limit)
        log "#{del} deleted"
      end

      log "照会・回答リマインダー更新" do
        Gwmonitor::Control.renew_reminder_section
        Gwmonitor::Control.renew_reminder_personal
      end
    end
  end

  def self.preparation_delete
    run do
      log "照会・回答不要データ削除処理: #{I18n.l(limit_date_for_preparation)} 以前を削除" do
        del = preparation_destroy_record
        log "#{del} deleted"
      end
    end
  end

  private

  def self.destroy_record(limit)
    del = 0
    Gwmonitor::Control.where(['expiry_date < ?', limit]).find_each do |title|
      if title.destroy
        del += 1
      end
    end
    del
  end

  def self.preparation_destroy_record
    del = 0
    Gwmonitor::Control.where(state: 'preparation').created_before(limit_date_for_preparation).find_each do |title|
      if title.destroy
        del += 1
      end
    end
    del
  end
end
