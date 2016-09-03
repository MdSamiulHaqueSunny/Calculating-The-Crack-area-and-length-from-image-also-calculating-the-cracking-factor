clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 18;

% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% Read in a standard MATLAB gray scale demo image.
button = menu('Use which demo image?', 'MRI', 'Moon', 'Tire', 'Spine', 'Saturn');
if button == 1
	baseFileName = 'crack5.jpg';
elseif button == 2
	baseFileName = 'crack2.jpg';
elseif button == 3
	baseFileName = 'tire.tif';
elseif button == 4
	baseFileName = 'spine.tif';
else
	baseFileName = 'saturn.png';
end

% Read in a standard MATLAB gray scale demo image.
folder = fileparts(which('cameraman.tif')); % Get demos folder.
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
	% File doesn't exist -- didn't find it there.  Check the search path for it.
	fullFileNameOnSearchPath = baseFileName; % No path this time.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
originalImage = imread(fullFileName);
% Display the original gray scale image.
hFig = figure;
subplot(2, 2, 1);
imshow(originalImage, []);
axis on;
title('Original Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(originalImage);
if numberOfColorBands > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = originalImage(:, :, 2); % Take green channel.
else
	% It's already grayscale.
	grayImage = originalImage;
end

% Binarize the image
level = graythresh(grayImage);
binaryImage = im2bw(grayImage, level);
% Display the image.
subplot(2, 2, 2);
imshow(binaryImage, []);
axis on;
title('Initial Binary Image', 'FontSize', fontSize);

% Fill holes
binaryImage = imfill(binaryImage, 'holes');
% Get rid of anything less than 10% of the image
binaryImage = bwareaopen(binaryImage, round(0.1*numel(binaryImage)));
% Display the image.
subplot(2, 2, 4);
imshow(binaryImage, []);
axis on;
hold on;
caption = sprintf('Filled, Cleaned Binary Image with\nBoundaries and Feret Diameters');
title(caption, 'FontSize', fontSize);

% Copy the gray scale image to the lower left.
subplot(2, 2, 3);
imshow(originalImage, []);
caption = sprintf('Original Image with\nBoundaries and Feret Diameters');
title(caption, 'FontSize', fontSize);
axis on;
hold on;

% Label the image so we can get the average perpendicular width.
labeledImage = bwlabel(binaryImage);
% Measure the area
measurements = regionprops(labeledImage, 'Area');

% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = size(boundaries, 1);
for blobIndex = 1 : numberOfBoundaries
	thisBoundary = boundaries{blobIndex};
	x = thisBoundary(:, 2); % x = columns.
	y = thisBoundary(:, 1); % y = rows.
	
	% Find which two bounary points are farthest from each other.
	maxDistance = -inf;
	for k = 1 : length(x)
		distances = sqrt( (x(k) - x) .^ 2 + (y(k) - y) .^ 2 );
		[thisMaxDistance, indexOfMaxDistance] = max(distances);
		if thisMaxDistance > maxDistance
			maxDistance = thisMaxDistance;
			index1 = k;
			index2 = indexOfMaxDistance;
		end
	end
	
	% Find the midpoint of the line.
	xMidPoint = mean([x(index1), x(index2)]);
	yMidPoint = mean([y(index1), y(index2)]);
	longSlope = (y(index1) - y(index2)) / (x(index1) - x(index2))
	perpendicularSlope = -1/longSlope
	% Use point slope formula (y-ym) = slope * (x - xm) to get points
	y1 = perpendicularSlope * (1 - xMidPoint) + yMidPoint;
	y2 = perpendicularSlope * (columns - xMidPoint) + yMidPoint;
	
	% Get the profile perpendicular to the midpoint so we can find out when if first enters and last leaves the object.
	[cx,cy,c] = improfile(binaryImage,[1, columns], [y1, y2], 1000);
	% Get rid of NAN's that occur when the line's endpoints go above or below the image.
	c(isnan(c)) = 0;
	firstIndex = find(c, 1, 'first');
	lastIndex = find(c, 1, 'last');
	% Compute the distance of that perpendicular width.
	perpendicularWidth = sqrt( (cx(firstIndex) - cx(lastIndex)) .^ 2 + (cy(firstIndex) - cy(lastIndex)) .^ 2 );
	% Get the average perpendicular width.  This will approximately be the area divided by the longest length.
	averageWidth = measurements(blobIndex).Area / maxDistance;
	
	% Plot the boundaries, line, and midpoints over the two images.
	% Plot the boundary over the gray scale image
	subplot(2, 2, 3);
	plot(x, y, 'y-', 'LineWidth', 3);
	% For this blob, put a line between the points farthest away from each other.
	line([x(index1), x(index2)], [y(index1), y(index2)], 'Color', 'r', 'LineWidth', 3);
	plot(xMidPoint, yMidPoint, 'r*', 'MarkerSize', 15, 'LineWidth', 2);
	% Plot perpendicular line.  Make it green across the whole image but magenta inside the blob.
	line([1, columns], [y1, y2], 'Color', 'g', 'LineWidth', 3);	
	line([cx(firstIndex), cx(lastIndex)], [cy(firstIndex), cy(lastIndex)], 'Color', 'm', 'LineWidth', 3);
	
	% Plot the boundary over the binary image
	subplot(2, 2, 4);
	plot(x, y, 'y-', 'LineWidth', 3);
	% For this blob, put a line between the points farthest away from each other.
	line([x(index1), x(index2)], [y(index1), y(index2)], 'Color', 'r', 'LineWidth', 3);
	plot(xMidPoint, yMidPoint, 'r*', 'MarkerSize', 15, 'LineWidth', 2);
	% Plot perpendicular line.  Make it green across the whole image but magenta inside the blob.
	line([1, columns], [y1, y2], 'Color', 'g', 'LineWidth', 3);	
	line([cx(firstIndex), cx(lastIndex)], [cy(firstIndex), cy(lastIndex)], 'Color', 'm', 'LineWidth', 3);
	
	message = sprintf('The longest line is red.\nPerpendicular to that, at the midpoint, is green.\nMax distance for blob #%d = %.2f\nPerpendicular distance at midpoint = %.2f\nAverage perpendicular width = %.2f (approximately\nArea = %d', ...
		blobIndex, maxDistance, perpendicularWidth, averageWidth, measurements(blobIndex).Area);
	fprintf('%s\n', message);
	uiwait(helpdlg(message));
end
hold off;
close(hFig);
