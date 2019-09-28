class HardWorker
  include Sidekiq::Worker

  def perform(index)
    FileUtils.rm_rf("public/uploads/pdf/#{index}/")
  end
end