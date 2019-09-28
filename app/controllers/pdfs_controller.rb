class PdfsController < ApplicationController
  require 'RMagick'
  include Magick
  before_action :set_pdfs, only: [:selects, :merge, :download_pdf]
  
  def index
  end
  
  def new
    @pdf = Pdf.new
  end
  
  def create
    if params[:pdf] == nil 
      return redirect_to new_pdf_path 
    end
    @pdf = Pdf.new(pdf_params)
    
      if @pdf.save
         redirect_to selects_path(@pdf.id), notice: "The pdf has been combined."
      else
         render :new
      end
  end

  def selects
    @id = params[:id]
  end
  
  def merge
    index = params[:index].to_i
    unless index == 0 
      @pdfs.insert(0, @pdfs.delete_at(index))
    end
    for i in 0..@pdfs.length-1
      pdf = Magick::ImageList.new("public/uploads/pdf/#{params[:id]}/#{@pdfs[i].identifier}") do
        self.quality = 80
        self.density = "300"
      end
      unless i == 0
        FileUtils.mkdir_p "public/uploads/pdf/#{params[:id]}/pdf_img"
        pdf.write("public/uploads/pdf/#{params[:id]}/pdf_img/washed_#{i}.jpg")
        pdf_img_list = Dir.glob("public/uploads/pdf/#{params[:id]}/pdf_img/*.jpg").sort
        for i in 0..pdf_img_list.length-1
          pdf_img = Magick::ImageList.new("#{pdf_img_list[i]}")
          anno = Draw.new
          anno_text = '[별첨1]'
          anno.annotate(pdf_img, 0,0,40,40, anno_text) {
          self.font = 'D2Coding'
          self.fill = 'black'
          self.stroke = 'transparent'
          self.pointsize = 25
          self.font_weight = NormalWeight
          self.gravity = NorthEastGravity
          }
          pdf_img.write("public/uploads/pdf/#{params[:id]}/washed_#{i+1}.pdf")
          
        end
      else
        pdf.write("public/uploads/pdf/#{params[:id]}/washed_#{i}.pdf")
      end
    end
    # for i in 0..@pdfs.length-1
    #   pdf << CombinePDF.load("public/uploads/pdf/#{params[:id]}/#{@pdfs[i].identifier}") 
    # end
    # pdf.save "public/uploads/pdf/#{params[:id]}/#{@pdfs.first.file.basename}_combined.pdf"
    pdf = CombinePDF.new
    for i in 0..pdf_img_list.length
      pdf << CombinePDF.load("public/uploads/pdf/#{params[:id]}/washed_#{i}.pdf") 
    end
    pdf.save "public/uploads/pdf/#{params[:id]}/merged.pdf"
    redirect_to download_path(params[:id], index)
  end
  
  def download
    @id = params[:id]
    @index_id = params[:index_id]
  end
  
  def download_pdf
    index = params[:index_id].to_i
    send_file(
    "public/uploads/pdf/#{params[:id]}/merged.pdf",
    filename: "merged.pdf",
    type: "application/pdf"
    )
  end
  
  def destroy
    @pdf = Pdf.find(params[:id])
    @pdf.destroy
    FileUtils.rm_rf("public/uploads/pdf/#{params[:id]}/")
    redirect_to new_pdf_path
  end
  
  private
    def set_pdfs
        @pdfs = Pdf.find(params[:id]).pdf
    end
    
    def pdf_params
      params.require(:pdf).permit({pdf: []})
    end
end
