function result = Performance_count(params)
        n = params.n;        
        L = params.L;
        GP = params.GP;
      
        % performance analy
        if params.new_sol == L
            params.count1 = params.count1+1;
            params.count2 = params.count2+1;
         elseif params.new_sol >L && params.new_sol <(L+GP)/2
             params.count2 = params.count2 + 1;
         elseif params.new_sol>=(L+GP)/2
             params.count3 = params.count3+1;
         elseif params.new_sol<L
             params.count4 = params.count4+1;
         end 

         if params.L_sol == L 
            params.count11 = params.count11+1;
            params.count12 = params.count12+1;
         elseif params.L_sol > L  && params.L_sol < (L+GP)/2
             params.count12 = params.count12 + 1;
         elseif params.L_sol >= (L+GP)/2
             params.count13 = params.count13+1;
         elseif params.L_sol < L 
             params.count14 = params.count14+1;
         end

         if params.e_sol_rx == L
            params.count21 = params.count21+1;
            params.count22 = params.count22+1;
         elseif params.e_sol_rx >L && params.e_sol_rx <(L+GP)/2
             params.count22 = params.count22 + 1;
         elseif params.e_sol_rx>=(L+GP)/2
             params.count23 = params.count23+1;
         elseif params.e_sol_rx<L
             params.count24 = params.count24+1;
         end 

         % if params.L_sol_e2 == L
         %    params.count31 = params.count31+1;
         %    params.count32 = params.count32+1;
         % elseif params.L_sol_e2 >L && params.L_sol_e2 <(L+GP)/2
         %     params.count32 = params.count32 + 1;
         % elseif params.L_sol_e2>=(L+GP)/2
         %     params.count33 = params.count33+1;
         % elseif params.L_sol_e2<L
         %     params.count34 = params.count34+1;
         % end
         % 
         % if params.L_sol_y2 == L
         %    params.count41 = params.count41+1;
         %    params.count42 = params.count42+1;
         % elseif params.L_sol_y2 >L && params.L_sol_y2 <(L+GP)/2
         %     params.count42 = params.count42 + 1;
         % elseif params.L_sol_y2>=(L+GP)/2
         %     params.count43 = params.count43+1;
         % elseif params.L_sol_y2<L
         %     params.count44 = params.count44+1;
         % end

        result.count1 = params.count1;
        result.count2 = params.count2;
        result.count3 = params.count3;
        result.count4 = params.count4;
        
        result.count11 = params.count11;
        result.count12 = params.count12;
        result.count13 = params.count13;
        result.count14 = params.count14;
        
        result.count21 = params.count21;
        result.count22 = params.count22;
        result.count23 = params.count23;
        result.count24 = params.count24;
        
        result.count31 = params.count31;
        result.count32 = params.count32;
        result.count33 = params.count33;
        result.count34 = params.count34;
        
        result.count41 = params.count41;
        result.count42 = params.count42;
        result.count43 = params.count43;
        result.count44 = params.count44;
        
end