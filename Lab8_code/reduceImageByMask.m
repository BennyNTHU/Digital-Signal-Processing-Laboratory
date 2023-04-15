function imageReduced = reduceImageByMask(image, seamMask)
    % Note that the type of the mask is logical and you 
    % can make use of this.
    [h, w, c]=size(image);
    imageReduced = zeros(h, w-1, c);
    
    
    for i=1:h
        for j=1:w
            if (seamMask(i,j)==0)
               imageReduced(i,:,:)=[image(i,1:j-1,:) image(i,j+1:w,:)];
            end
        end
    end
    
end

