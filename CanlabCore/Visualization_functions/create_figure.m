function [f1, axh] = create_figure(tagname, varargin)
% :Usage:
% ::
%
%    f1 = create_figure(['tagname'], [subplotrows], [subplotcols], [do not clear existing fig], [force resize existing figure flag])
%
% checks for old figure with tag of tagname,
% clears it if it exists, or creates new one if it doesn't
%
% Defaults:
% doclear = true;    % clear if new or if old and existing
% createnew = false; % force creation of new figure (otherwise uses existing)
% doresize = false;  % force resize of figure based on how many axes it
%                      contains. Will resize anyway when creating new.


% Edit: 1/2017 by Tor Wager - set figure aspect ratio in proportion to data
% plots, when creating new figure
% 8/1/2018 Tor Wager, add [resize existing figure flag]
% 9/1/2018 doresize = false by default

axh = [];

if nargin < 1 || isempty(tagname)
    tagname = 'nmdsfig';
end

doclear = true;    % clear if new or if old and existing
createnew = false; % force creation of new figure (otherwise uses existing)
doresize = false;  % force resize of figure based on how many axes it contains

if length(varargin) > 2 
    % if true, use same figure; do not clear
    doclear = ~varargin{3};
end

if length(varargin) > 3 
    doresize = varargin{4};
end

old = findobj('Tag', tagname);
old = old( strcmp( get(old, 'Type'), 'figure' ) );

if ~isempty(old)
    % Found existing figure window with this tag
    
    if length(old) > 1
        % multiple figures with same tag!
        close(old(2:end))
        old = old(1);
    end
    
    if doclear, clf(old); end
    
    f1 = old;
    
else
    % Or create new
    
    createnew = true;

    f1 = figure; 
    
    set(f1, 'Tag', tagname, 'Name', tagname, 'color', 'white');
    hold on
    
end

% activate this figure
figure(f1);


if doclear % true for new figs or cleared ones
    
    % Create subplots, if requested; set axis font sizes
    
    if length(varargin) > 0
        i = max(1, varargin{1});
        j = max(1, varargin{2});
    else
        i = 1;
        j = 1;
    end
    
    np = max(1, i * j);
    
    % quit and return if no subplots
    if np == 1
        axh = gca;
        cla
        set(gca,'FontSize', 14)
        hold on
        return
    end
    
    for k = 1:np
        
        axh(k) = subplot(i,j,k);
        cla;
        set(gca,'FontSize', 14)
        hold on
    end
    
    axes(axh(1));
    
end % if doclear

if createnew || doresize
    
    set_figure_position(i, j);
    
end

end % function


function  set_figure_position(i, j)
figaspect = j / i;  % aspect ratio, width / height
pos = get(gcf, 'Position');
w = pos(3);
h = pos(4);
w = w .* figaspect;


screensz = get(0, 'screensize');
maxw = screensz(3) .* .8;
maxh = screensz(4) .* .8;

reducefactor = max(w ./ maxw, h ./ maxh);  % in case we go beyond screen boundaries

pos(1:2) = [30 screensz(4) - 30]; % set to top corner

pos(3) = w ./ reducefactor;
pos(4) = h ./ reducefactor;

set(gcf, 'Position', pos);

end
