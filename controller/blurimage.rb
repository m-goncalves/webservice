require 'bunny'

def destinationPath(sourcePath)

    destinationFolder = "/blurred-images"
    
    sourceFile = sourcePath.dup

    if sourceFile.include? "/"
        idx = sourceFile.length - sourceFile.reverse!.index("/")
        sourceFile.reverse!   
    else
        idx = 0
    end
    
    return destinationFolder + "/" + sourcePath[idx..-1]
end

# RabbitMQ initialization

connection = Bunny.new(host: "rabbitmq")
connection.start
channel = connection.create_channel  
queue = channel.queue('blur-service')
sourceFile = ""

begin
    queue.subscribe(block: true) do |  _delivery_info, _properties, filepath |
        # calling the python programm and passing the arguments it needs: the image to be blurred and where it has to be placed
        output = system "python3", "transformation/blur.py", filepath, destinationPath (filepath)
        system("rm -f " + filepath)
    end
rescue
    puts output
ensure
    connection.close()
    #removing original file
    system("rm -f " + sourceFile)
end