function data = growth_rate_to_weaning(AnimalsTable, data, config)
  if strcmp(config.cellsize_type,'acinar')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Acinar) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.BirthWeight) & ...
                                ~isnan(AnimalsTable.WeaningWeight) & ...
                                ~isnan(AnimalsTable.WeaningAge) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Acinar;
    pretty_cellsize_type = 'Acinar';
  end
  if strcmp(config.cellsize_type,'hepatocyte')
    AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Hepatocyte) & ...
                                ~isnan(AnimalsTable.AdultWeight) & ...
                                ~isnan(AnimalsTable.BirthWeight) & ...
                                ~isnan(AnimalsTable.WeaningWeight) & ...
                                ~isnan(AnimalsTable.WeaningAge) & ...
                                ~isnan(AnimalsTable.Lifespan),:);
    CellSize = AnimalsTable.Hepatocyte;
    pretty_cellsize_type = 'Hepatocyte';
  end

  LifeSpan = AnimalsTable.Lifespan;
  AnimalSize = AnimalsTable.AdultWeight;
  BirthWeight = AnimalsTable.BirthWeight;
  WeaningAge = AnimalsTable.WeaningAge;
  WeaningWeight = AnimalsTable.WeaningWeight;

  num_doubles = log2(WeaningWeight./BirthWeight);
  D = num_doubles;
  growth_rate_in_doubles_per_day = num_doubles ./ WeaningAge
  D_rate = growth_rate_in_doubles_per_day;

  section = {};
  section.title = ['Growth rate to weaning in doubles per day (' config.cellsize_type ')'];
  images = [];
  table = [];
  
  row = {};
  row.row_name = 'Growth rate vs animal size';
  [r p] = corr(D_rate, log(AnimalSize));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(D_rate, log(AnimalSize), log(LifeSpan));
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, log(AnimalSize), CellSize);
  partial_correlation = {};
  partial_correlation.title = 'controlling for cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, log(AnimalSize),  [log(LifeSpan) CellSize]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span and cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row];
  
  row = {};
  row.row_name = 'Growth rate vs life span';
  [r p] = corr(D_rate, log(LifeSpan));
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(D_rate, log(LifeSpan), log(AnimalSize));
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, log(LifeSpan), CellSize);
  partial_correlation = {};
  partial_correlation.title = 'controlling for cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, log(LifeSpan), [log(AnimalSize) CellSize]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size and cell size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row]; 

  row = {};
  row.row_name = 'Growth rate vs cell size';
  [r p] = corr(D_rate, CellSize);
  row.correlation = {};
  row.correlation.r = r;
  row.correlation.p = p;
  partial_correlations = [];
  [r p] = partialcorr(D_rate, CellSize, log(LifeSpan));
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, CellSize, log(AnimalSize));
  partial_correlation = {};
  partial_correlation.title = 'controlling for animal size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  [r p] = partialcorr(D_rate, CellSize, [log(LifeSpan) log(AnimalSize)]);
  partial_correlation = {};
  partial_correlation.title = 'controlling for life span and animal size';
  partial_correlation.r = r;
  partial_correlation.p = p;
  partial_correlations = [partial_correlations partial_correlation];
  row.partial_correlations = partial_correlations;
  table = [table row];

  figure('Position', [400, 400, 300, 250])
  semilogy(D_rate,AnimalSize,'ok')
  [f,fresult]=fit(D_rate,log(AnimalSize),'poly1');
  hold on
  plot(D_rate,exp(f(D_rate)),'r')
  xlabel('Growth rate in doubles per day')
  ylabel('Animal Size (g)')
  saveas(gcf,'../public/img/growth_rate_vs_animal_size.png')
  im  = {};
  im.title = 'Growth Rate vs Animal Size';
  im.filename = 'growth_rate_vs_animal_size.png'; 
  images = [images im];

  figure('Position', [400, 400, 300, 250])
  semilogy(D_rate,LifeSpan,'ok')
  [f,fresult]=fit(D_rate,log(LifeSpan),'poly1');
  hold on
  plot(D_rate,exp(f(D_rate)),'r')
  xlabel('Growth rate in doubles per day')
  ylabel('Life Span (yrs)')
  saveas(gcf,'../public/img/growth_rate_vs_life_span.png')
  im.title = 'Growth Rate vs Life Span';
  im.filename = 'growth_rate_vs_life_span.png';
  images = [images im];

  figure('Position', [400, 400, 300, 250])
  plot(D_rate,CellSize,'ok')
  [f,fresult]=fit(D_rate,CellSize,'poly1');
  hold on
  plot(D_rate,f(D_rate),'r')
  xlabel('Growth rate in doubles per day')
  ylabel([pretty_cellsize_type ' Cell Volume (um^3)'])
  saveas(gcf,['../public/img/growth_rate_vs_cell_size_' config.cellsize_type '.png'])
  im.title = ['Growth Rate vs Cell Size (' config.cellsize_type ')'];
  im.filename = ['growth_rate_vs_cell_size_' config.cellsize_type '.png'];
  images = [images im];


  section.images = images;
  section.table = table;
  data.sections = [data.sections section];
end