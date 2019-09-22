class Pdf < ApplicationRecord
  mount_uploaders :pdf, PdfUploader
  serialize :pdf, JSON
end
