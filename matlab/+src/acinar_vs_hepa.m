function data = acinar_vs_hepa(AnimalsTable, data, config)
  AnimalsTable = AnimalsTable(~isnan(AnimalsTable.Acinar) & ...
                              ~isnan(AnimalsTable.Hepatocyte),:);
  aCellSize = AnimalsTable.Acinar;
  hCellSize = AnimalsTable.Hepatocyte;

  figure('Position', [400, 400, 300, 250])
  scatter(aCellSize,hCellSize, 'ok')
  xlabel('Acinar Cell Volume (um^3)')
  ylabel('Hepatocyte Cell Volume (um^3)')

  saveas(gcf,'../public/img/acinar_vs_hepa.png')

  section = {};
  section.title = 'Acinar Cell Size vs Hepatocyte Cell Size';  
  section.table = [];
  section.images  = {};
  section.images.title = 'Acinar Cell Size vs Hepatocyte Cell Size';
  section.images.filename = 'acinar_vs_hepa.png'; 
  data.sections = [data.sections section];
end