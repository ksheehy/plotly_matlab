function obj = updateSurfaceplot(obj, plotIndex)

%-AXIS INDEX-%
axIndex = obj.getAxisIndex(obj.State.Plot(plotIndex).AssociatedAxis);

%-CHECK FOR MULTIPLE AXES-%
[xSource, ySource] = findSourceAxis(obj,axIndex);

%-SURFACE DATA STRUCTURE- %
plotData = get(obj.State.Plot(plotIndex).Handle);
figure_data = get(obj.State.Figure.Handle);

%-AXIS DATA-%
eval(['xaxis = obj.layout.xaxis' num2str(xSource) ';']);
eval(['yaxis = obj.layout.yaxis' num2str(ySource) ';']);

%-------------------------------------------------------------------------%

%-surface xaxis-%
obj.data{plotIndex}.xaxis = ['x' num2str(xSource)];

%-------------------------------------------------------------------------%

%-surface yaxis-%
obj.data{plotIndex}.yaxis = ['y' num2str(ySource)];

%-------------------------------------------------------------------------%

% check for 3D
if any(nonzeros(plotData.ZData))
    
    %---------------------------------------------------------------------%
    
    %-surface type-%
    obj.data{plotIndex}.type = 'surface';
    
    %---------------------------------------------------------------------%
    
    %-format x an y data-%
    x = plotData.XData;
    y = plotData.YData;
    cdata = plotData.CData;
    if isvector(x)
        [x, y] = meshgrid(x,y);
    end
    
    %---------------------------------------------------------------------%
    
    %-surface x-%
    obj.data{plotIndex}.x = x;

    %---------------------------------------------------------------------%
    
    %-surface y-%
    obj.data{plotIndex}.y = y;
    
    %---------------------------------------------------------------------%
    
    %-surface z-%
    obj.data{plotIndex}.z = plotData.ZData;
    
    %---------------------------------------------------------------------%
    
    %-if image comes would a 3D plot-%
    obj.PlotOptions.Image3D = true;
    
    %-if contour comes would a ContourProjection-%
    obj.PlotOptions.ContourProjection = true;
    
    %---------------------------------------------------------------------%

    %- setting grid mesh by default -%
    % x-direction
    xmin = min(x(:));
    xmax = max(x(:));
    xsize = (xmax - xmin) / (size(x, 2)-1); 
    obj.data{plotIndex}.contours.x.start = xmin;
    obj.data{plotIndex}.contours.x.end = xmax;
    obj.data{plotIndex}.contours.x.size = xsize;
    obj.data{plotIndex}.contours.x.show = true;
    obj.data{plotIndex}.contours.x.color = 'black';
    obj.data{plotIndex}.contours.x.alpha = 0.5;
    % y-direction
    ymin = min(y(:));
    ymax = max(y(:));
    ysize = (ymax - ymin) / (size(y, 1)-1);
    obj.data{plotIndex}.contours.y.start = ymin;
    obj.data{plotIndex}.contours.y.end = ymax;
    obj.data{plotIndex}.contours.y.size = ysize;
    obj.data{plotIndex}.contours.y.show = true;
    obj.data{plotIndex}.contours.y.color = 'black';
    obj.data{plotIndex}.contours.y.alpha = 0.5;
%     xmin = 1;
%     xmax = 1;
%     xsize = min((xmax - xmin) / (size(x, 2)-1),1); 
%     obj.data{surfaceIndex}.contours.x.start = xmin;
%     obj.data{surfaceIndex}.contours.x.end = xmax;
%     obj.data{surfaceIndex}.contours.x.size = xsize;
%     obj.data{surfaceIndex}.contours.x.show = true;
%     obj.data{surfaceIndex}.contours.x.color = 'black';
%     obj.data{surfaceIndex}.contours.x.alpha = 0.5;
%     % y-direction
%     ymin = 1;
%     ymax = 1;
%     ysize = min((ymax - ymin) / (size(y, 1)-1),1);
%     obj.data{surfaceIndex}.contours.y.start = ymin;
%     obj.data{surfaceIndex}.contours.y.end = ymax;
%     obj.data{surfaceIndex}.contours.y.size = ysize;
%     obj.data{surfaceIndex}.contours.y.show = true;
%     obj.data{surfaceIndex}.contours.y.color = 'black';
%     obj.data{surfaceIndex}.contours.y.alpha = 0.5;
    
else
    
    %-surface type-%
    obj = updateImage(obj, plotIndex);
    
    %-surface x-%
    obj.data{plotIndex}.x = plotData.XData(1,:);
    
    %-surface y-%
    obj.data{plotIndex}.y = plotData.YData(:,1);
end

%-------------------------------------------------------------------------%

%-image colorscale-%

cmap = figure_data.Colormap(plotIndex,:);
len = max(length(cmap)-1,1);

% for c = 1: length(cmap)
c = plotIndex;
col = 255 * cmap;
obj.data{plotIndex}.colorscale{plotIndex} = { (c-1)/len , ['rgb(' num2str(col(1)) ',' num2str(col(2)) ',' num2str(col(3)) ')'  ]  };
% % end

%-------------------------------------------------------------------------%

%-surface coloring-%
% obj.data{surfaceIndex}.surfacecolor = cdata;

%-------------------------------------------------------------------------%

%-surface name-%
obj.data{plotIndex}.name = plotData.DisplayName;

%-------------------------------------------------------------------------%

%-surface showscale-%
obj.data{plotIndex}.showscale = false;

%-------------------------------------------------------------------------%

%-surface visible-%
obj.data{plotIndex}.visible = strcmp(plotData.Visible,'on');

%-------------------------------------------------------------------------%

leg = get(plotData.Annotation);
legInfo = get(leg.LegendInformation);

switch legInfo.IconDisplayStyle
    case 'on'
        showleg = true;
    case 'off'
        showleg = false;
end

obj.data{plotIndex}.showlegend = showleg;

%-------------------------------------------------------------------------%

end
