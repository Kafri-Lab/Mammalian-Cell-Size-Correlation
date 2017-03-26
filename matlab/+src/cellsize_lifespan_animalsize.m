function data = cellsize_lifespan_animalsize(AnimalsTable, data, config)
  if strcmp(config.cellsize_type,'acinar')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Acinar) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Acinar;
    CellSize4 = AnimalsTable.Acinar([1 2 3 10]);
    pretty_cellsize_type = 'Acinar';
  end
  if strcmp(config.cellsize_type,'hepatocyte')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Hepatocyte) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Hepatocyte;
    CellSize4 = AnimalsTable.Hepatocyte([1 2 3 10]);
    pretty_cellsize_type = 'Hepatocyte';
  end

  AnimalNames = AnimalsTable.Colloquial;
  LifeSpan = AnimalsTable.Lifespan;
  AnimalSize = AnimalsTable.AdultWeight;

  % four animals that will be highlighted
  AnimalNames4 = AnimalsTable.Colloquial([1 2 3 10]);
  LifeSpan4 = AnimalsTable.Lifespan([1 2 3 10]);
  AnimalSize4 = AnimalsTable.AdultWeight([1 2 3 10]);

  section = {};
  section.title = ['Cell size vs life span vs animal size (' config.cellsize_type ')'];
  table = [];

  row = {};
  row.row_name = 'Cell size vs animal size';
  [r p] = corr(CellSize, log(AnimalSize));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  [r p] = partialcorr(CellSize, log(AnimalSize), LifeSpan);
  row.partial_correlation = {};
  row.partial_correlation.title = 'controlling for life span';
  row.partial_correlation.r = r;
  row.partial_correlation.p = p;
  table = [table row];
  
  row = {};
  row.row_name = 'Animal size vs life span';
  [r p] = corr(log(AnimalSize), log(LifeSpan));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  [r p] = partialcorr(log(AnimalSize), log(LifeSpan), CellSize);
  row.partial_correlation = {};
  row.partial_correlation.title = 'controlling for cell size';
  row.partial_correlation.r = r;
  row.partial_correlation.p = p;
  table = [table row];
  
  row = {};
  row.row_name = 'Cell size vs life span';
  [r p] = corr(CellSize, log(LifeSpan));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  [r p] = partialcorr(CellSize, log(LifeSpan), log(AnimalSize));
  row.partial_correlation = {};
  row.partial_correlation.title = 'controlling for animal size';
  row.partial_correlation.r = r;
  row.partial_correlation.p = p;
  table = [table row];
  
  section.table = table;

  images = []; % Used to store images of figures for HTML display

  %% Cell size versus animal size
  % figure('Position', [400, 400, 400, 400])
  figure('Position', [400, 400, 300, 250])
  semilogy(CellSize,AnimalSize,'ok')
  [f,fresult]=fit(CellSize,log(AnimalSize),'poly1');
  hold on
  plot(CellSize,exp(f(CellSize)),'r')
  xlabel([pretty_cellsize_type ' Cell Volume (um^3)'])
  ylabel('Animal Size (g)')
  % text(CellSize, AnimalSize, AnimalNames);
  saveas(gcf,['../public/img/cell_size_' config.cellsize_type '_vs_animal_size.png']);
  im  = {};
  im.title = ['Cell Size (' config.cellsize_type ') vs Animal Size'];
  im.filename = ['cell_size_' config.cellsize_type '_vs_animal_size.png'];
  images = [images im];
  

  %% Life span versus animal size
  % figure('Position', [400, 400, 400, 400])
  figure('Position', [400, 400, 300, 250])
  loglog(AnimalSize,LifeSpan,'ok')
  set(gca,'ytick',[0 3 6 12 25 50 100])
  [f,fresult]=fit(log(AnimalSize),log(LifeSpan),'poly1');
  hold on
  loglog(AnimalSize,exp(f(log(AnimalSize))),'r')
  xlabel('Animal Size (g)')
  ylabel('Life Span (yrs)')
  % text(AnimalSize,LifeSpan, AnimalNames);
  saveas(gcf,'../public/img/animal_size_vs_life_span.png');
  im  = {};
  im.title = 'Animal Size vs Life Span';
  im.filename = 'animal_size_vs_life_span.png';
  images = [images im];
  

  %% Life span versus cell size
  % figure('Position', [400, 400, 400, 400])
  figure('Position', [400, 400, 300, 250])
  semilogy(CellSize,LifeSpan,'ok')
  set(gca,'ytick',[0 3 6 12 25 50 100])
  [f,fresult]=fit(CellSize,log(LifeSpan),'poly1');
  hold on
  plot(CellSize,exp(f(CellSize)),'r')
  xlabel([pretty_cellsize_type ' Cell Volume (um^3)'])
  ylabel('Life Span (yrs)')
  % text(CellSize, LifeSpan, AnimalNames);
  saveas(gcf,['../public/img/cell_size_' config.cellsize_type '_vs_life_span.png']);
  im  = {};
  im.title = ['Cell Size (' config.cellsize_type ') vs Life Span'];
  im.filename = ['cell_size_' config.cellsize_type '_vs_life_span.png'];
  images = [images im];
  


  %% cell size versus life span (with 4 animals highlighted)
  figure('Position', [400, 400, 300, 250])
  semilogy(CellSize,LifeSpan,'ok')
  set(gca,'ytick',[0 3 6 12 25 50 100])
  hold on
  semilogy(CellSize4,LifeSpan4,'o','MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red')
  [f,fresult]=fit(CellSize,log(LifeSpan),'poly1');
  hold on
  plot(CellSize,exp(f(CellSize)),'r')
  xlabel([pretty_cellsize_type ' Cell Volume (um^3)'])
  ylabel('Life Span (yrs)')
  dx = 110; dy = 1.1;
  text(CellSize4+dx, LifeSpan4+dy, AnimalNames4);
  saveas(gcf,['../public/img/cell_size_' config.cellsize_type '_vs_life_span4.png']);
  im  = {};
  im.title = ['Cell Size (' config.cellsize_type ') vs Life Span'];
  im.filename = ['cell_size_' config.cellsize_type '_vs_life_span4.png'];
  images = [images im];


  %% Life span versus animal size (with 4 animals highlighted)
  figure('Position', [400, 400, 300, 250])
  loglog(AnimalSize,LifeSpan,'ok')
  set(gca,'ytick',[0 3 6 12 25 50 100])
  hold on
  loglog(AnimalSize4,LifeSpan4,'o','MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red')
  [f,fresult]=fit(log(AnimalSize),log(LifeSpan),'poly1');
  hold on
  loglog(AnimalSize,exp(f(log(AnimalSize))),'r')
  xlabel('Animal Size (g)')
  ylabel('Life Span (yrs)')
  dx = 0; dy = 0;
  text(AnimalSize4+dx, LifeSpan4+dy, AnimalNames4);
  saveas(gcf,'../public/img/animal_size_vs_life_span4.png');
  im  = {};
  im.title = 'Animal Size vs Life Span';
  im.filename = 'animal_size_vs_life_span4.png';
  images = [images im];


  % %% cell size versus life span (4 animals)
  % figure('Position', [100, 100, 300, 300])
  % semilogy(CellSize4,LifeSpan4,'o','MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red')
  % set(gca,'ytick',[0 3 6 12 25 50 100])
  % xlabel('cell volume (Um^3)')
  % ylabel('Life Span (yrs)')
  % dx = 0; dy = 0;
  % text(CellSize4+dx, LifeSpan4+dy, AnimalNames4);
  % saveas(gcf,['../public/img/cell_size_' config.cellsize_type '_vs_life_span4H.png']);
  % im  = {};
  % im.title = ['Cell Size (' config.cellsize_type ') vs Life Span'];
  % im.filename = ['cell_size_' config.cellsize_type '_vs_life_span4H.png'];
  % images = [images im];

  % %% Life span versus animal size (4 animals)
  % figure('Position', [400, 400, 300, 300])
  % loglog(AnimalSize4,LifeSpan4,'o','MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red')
  % % set(gca,'ytick',[0 3 6 12 25 50 100])
  % xlabel('Animal Size (g)')
  % ylabel('Life Span (yrs)')
  % dx = 0; dy = 0;
  % text(AnimalSize4+dx, LifeSpan4+dy, AnimalNames4);
  % saveas(gcf,'../public/img/animal_size_vs_life_span4H.png');
  % im  = {};
  % im.title = 'Animal Size vs Life Span';
  % im.filename = 'animal_size_vs_life_span4H.png';
  % images = [images im];


  %% isolating the influence of cell size from other ...
  figure('Position', [100, 100, 400, 350])
  CellSize_p=nchoosek(CellSize,4);
  AnimalSize_p=nchoosek(log(AnimalSize),4);
  LifeSpan_p=nchoosek(log(LifeSpan),4);
  X1=corr(CellSize_p',LifeSpan_p');x1=diag(X1);
  X2=corr(AnimalSize_p',LifeSpan_p');x2=diag(X2);
  plot(x1,x2,'ok', 'MarkerFaceColor', [0.5,0.5,0.5], 'MarkerSize', 3)
  xlabel('correlation of cell size vs life span')
  ylabel('correlation of animal size vs life span')
  % title('isolating the influence of cell size from other')
  % annotation('textbox',...
  %     [1 0.65 0.3 0.15],...
  %     [0 0 0.1 0.1],...
  %     'String','A',...
  %     'FontSize',14,...
  %     'FontName','Arial',...
  %     'EdgeColor',[1 1 0],...
  %     'LineWidth',2,...
  %     'BackgroundColor',[1  1 1],...
  %     'Color',[0 0 0]);

  % text('Parent',Parent1,'BackgroundColor',[1 1 1],'FontWeight','bold',...
  %     'FontSize',12,...
  %     'String','C',...
  %     'Position',[-0.95 0.690196078431373 0]);

  text(-.97,.95,'A', 'FontWeight', 'bold', 'FontSize', 9, 'Color', 'black', 'BackgroundColor',[1 1 1])
  text(-.77,.95,'B', 'FontWeight', 'bold', 'FontSize', 9, 'Color', 'black', 'BackgroundColor',[1 1 1])
  text(-.97,.75,'C', 'FontWeight', 'bold', 'FontSize', 9, 'Color', 'black', 'BackgroundColor',[1 1 1])
  text(-.77,.75,'D', 'FontWeight', 'bold', 'FontSize', 9, 'Color', 'black', 'BackgroundColor',[1 1 1])
  hold on
  plot([-.8,-.8],[-1,1],'r')
  hold on
  plot([-1,1],[.8,.8],'r')
  h=gcf;
  set(h.Children,'Xlim',[-1 0]);
  set(h.Children,'Ylim',[0 1]);
  saveas(gcf,['../public/img/partial_correlation_plot_' config.cellsize_type '.png']);
  im  = {};
  im.title = 'Partial Correlation Plot';
  im.filename = ['partial_correlation_plot_' config.cellsize_type '.png'];
  images = [images im];

  section.images = images;
  section.table = table;
  data.sections = [data.sections section];
end