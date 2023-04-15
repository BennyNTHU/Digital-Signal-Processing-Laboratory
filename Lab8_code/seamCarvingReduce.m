function output = seamCarvingReduce(image, newSize)
    % How many seam you need to delet from origin image
    output = image;
    reducesize = newSize;
    % Delet each seam 

    % You can use a for loop to delet each seam
    % with your "energyRGB", "findOptSeam", "reduceImageByMask"
    for num = 1:1:reducesize
        energy = energyRGB(output);
        [seamMask, ~] = findOptSeam(energy);
        output = reduceImageByMask(output, seamMask);
    end

end    