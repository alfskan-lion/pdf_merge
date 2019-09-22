class PdfsController < ApplicationController
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
    pdf = CombinePDF.new
    unless index == 0 
      @pdfs.insert(0, @pdfs.delete_at(index))
    end
    for i in 0..@pdfs.length-1
      pdf << CombinePDF.load("public/uploads/pdf/#{params[:id]}/#{@pdfs[i].identifier}") 
    end
    pdf.save "public/uploads/pdf/#{params[:id]}/#{@pdfs.first.file.basename}_combined.pdf"
    redirect_to download_path(params[:id], index)
  end
  
  def download
    @id = params[:id]
    @index_id = params[:index_id]
  end
  
  def download_pdf
    index = params[:index_id].to_i
    send_file(
    "public/uploads/pdf/#{params[:id]}/#{@pdfs[index].file.basename}_combined.pdf",
    filename: "#{@pdfs[index].file.basename}_combined.pdf",
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
