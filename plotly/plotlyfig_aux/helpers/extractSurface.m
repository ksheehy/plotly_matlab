function surface = extractSurface(plotData)

    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
    %                                                                         %
    % %-DESCRIPTION-%                                                         %
    %                                                                         %
    % EXTRACTS THE MARKER STYLE USED FOR MATLAB OBJECTS OF TYPE "PATCH".      %
    % THESE OBJECTS ARE USED IN AREASERIES BARSERIES, CONTOURGROUP,           %
    % SCATTERGROUP.                                                           %
    %                                                                         %
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%

    %-INITIALIZATIONS-%
    axisData = get(ancestor(plotData.Parent,'axes'));
    figureData = get(ancestor(plotData.Parent,'figure'));

    surface = struct();
    surface.sizeref = 1;
    surface.sizemode = 'area';
%     surface.size = getMarkerSize(plotData);
    surface.line.width = 1.5*plotData.LineWidth;

    xDataSurface = plotData.XData;
    yDataSurface = plotData.YData;
    zDataSurface = plotData.ZData;

    %-------------------------------------------------------------------------%
    %-------------------------------------------------------------------------%

    %-------------------------------------------------------------------------%
end

function flatColor = getScatterFlatColor(plotData, axisData, opacity)

    %-------------------------------------------------------------------------%

    cData = plotData.CData;
    colorMap = axisData.Colormap;
    cLim = axisData.CLim;
    nColors = size(colorMap, 1);
    cDataByIndex = false;

    if isvector(cData)
        lenCData = length(cData);
        nMarkers = length(plotData.XData);
        cDataByIndex = lenCData == nMarkers || lenCData == 1;
    end

    %-------------------------------------------------------------------------%

    if cDataByIndex
        cMapInd = getcMapInd(cData, cLim, nColors);
        numColor = 255 * colorMap(cMapInd, :);
    else
        numColor = 255*cData;
    end

    if size(numColor, 1) == 1
        flatColor = getStringColor(numColor);

    else
        for n = 1:size(numColor, 1)
            flatColor{n} = getStringColor(numColor(n, :));
        end
    end

    %-------------------------------------------------------------------------%
end

function cMapInd = getcMapInd(cData, cLim, nColors)
    scaledCData = rescaleData(cData, cLim);
    cMapInd = 1 + floor(scaledCData*(nColors-1));
end

function outData = rescaleData(inData, dataLim)
    outData = max( min( inData, dataLim(2) ), dataLim(1) );
    outData = (outData - dataLim(1)) / diff(dataLim);
end

function markerSize = getMarkerSize(plotData)
    markerSize = plotData.SizeData;

    if length(markerSize) == 1
        markerSize = markerSize * ones(size(plotData.XData));
    end
end