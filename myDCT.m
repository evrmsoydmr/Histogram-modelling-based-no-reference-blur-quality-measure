function [result] = myDCT(im,F)
  
  im = double(im)/256.0;
  result = zeros(8,8);
     for i = 0:7
        for j = 0:7
           for v = 0:7
               for u = 0:7
              
                  result(i+1,j+1) = result(i+1, j+1) + F(i+1, v+1)*F(j+1, u+1)*im(v+1, u+1);
            
                end
           end
           
        result(i+1,j+1) = result(i+1,j+1)*256;
      end
     end
end
