function areaname=getarea(areanames,index)

allareas=fieldnames(areanames);
for i=1:length(allareas)
    if areanames.(allareas{i})==index
        areaname=allareas{i};
    end
end
