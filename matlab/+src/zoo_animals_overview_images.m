function data = growth_rate_to_weaning(AnimalsTable, data, config)
  section = {};
  section.title = 'Animals Samples';  
  section.table = [];
  im  = {};
  images = [];

  for i=1:height(AnimalsTable)
    im.title = AnimalsTable{i,'Colloquial'};
    im.filename = AnimalsTable{i,'PictureURL'};
    images = [images im];
  end

  section.images = images;
  data.sections = [data.sections section];
end
