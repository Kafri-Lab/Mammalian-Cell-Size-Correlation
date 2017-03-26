function data = metabolic_rate(AnimalsTable, data, config)
  if strcmp(config.cellsize_type,'acinar')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Acinar) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.MetabolicRate) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Acinar;
    pretty_cellsize_type = 'Acinar';
  end
  if strcmp(config.cellsize_type,'hepatocyte')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Hepatocyte) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.MetabolicRate) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Hepatocyte;
    pretty_cellsize_type = 'Hepatocyte';
  end

  LifeSpan= AnimalsTable.Lifespan;
  AnimalSize= AnimalsTable.AdultWeight;
  Metabolic= AnimalsTable.MetabolicRate;

  section = {};
  section.title = ['Metabolic Rate (' config.cellsize_type ')'];
  images = [];
  table = [];

  row = {};
  row.row_name = 'Metabolic Rate Vs Animal Size';
  [r p] = corr(log(Metabolic), log(AnimalSize));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(log(Metabolic), log(AnimalSize), log(LifeSpan));
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), log(AnimalSize), CellSize);
  partial_correlation = {};
  partial_correlation.title = 'controlling for cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), log(AnimalSize),  [log(LifeSpan) CellSize]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span and cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row];

  
  row = {};
  row.row_name = 'Metabolic Rate Vs Life Span';
  [r p] = corr(log(Metabolic), log(LifeSpan));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(log(Metabolic), log(LifeSpan), log(AnimalSize));
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), log(LifeSpan), CellSize);
  partial_correlation = {};
  partial_correlation.title = 'controlling for cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), log(LifeSpan),  [log(AnimalSize) CellSize]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size and cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row];
  
  
  row = {};
  row.row_name = 'Metabolic Rate Vs Cell Size';
  [r p] = corr(log(Metabolic), CellSize);
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(log(Metabolic), CellSize, log(AnimalSize));
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), CellSize, log(LifeSpan));
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(log(Metabolic), CellSize,  [log(AnimalSize) log(LifeSpan)]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size and life span';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row];

  figure('Position', [400, 400, 300, 250])
  loglog(Metabolic,AnimalSize,'ok')
  [f,fresult]=fit(log(Metabolic),log(AnimalSize),'poly1');
  hold on
  plot(Metabolic,exp(f(log(Metabolic))),'r')
  xlabel('Metabolic rate per body mass (W/g)')
  ylabel('Animal Size (g)')
  saveas(gcf,['../public/img/metabolic_rate_vs_animal_size.png']);
  im  = {};
  im.title = 'Metabolic Rate vs Animal Size';
  im.filename = ['metabolic_rate_vs_animal_size.png'];
  images = [images im];

  figure('Position', [400, 400, 300, 250])
  loglog(Metabolic,LifeSpan,'ok')
  [f,fresult]=fit(log(Metabolic),log(LifeSpan),'poly1');
  hold on
  plot(Metabolic,exp(f(log(Metabolic))),'r')
  xlabel('Metabolic rate per body mass (W/g)')
  ylabel('Life Span (yrs)') 
  saveas(gcf,'../public/img/metabolic_rate_vs_life_span.png')
  im.title = 'Metabolic Rate vs Life Span';
  im.filename = 'metabolic_rate_vs_life_span.png';
  images = [images im];

  figure('Position', [400, 400, 300, 250])
  semilogy(CellSize,Metabolic,'ok')
  [f,fresult]=fit(CellSize,log(Metabolic),'poly1');
  hold on
  plot(CellSize,exp(f(CellSize)),'r')
  xlabel([pretty_cellsize_type ' Cell Volume (um^3)'])
  ylabel('Metabolic rate per body mass (W/g)','FontSize',10)
  saveas(gcf,['../public/img/metabolic_rate_vs_cell_size_' config.cellsize_type '.png'])
  im.title = ['Metabolic Rate vs Cell Size (' config.cellsize_type ')'];
  im.filename = ['metabolic_rate_vs_cell_size_' config.cellsize_type '.png'];
  images = [images im];

  section.images = images;
  section.table = table;
  data.sections = [data.sections section];
end