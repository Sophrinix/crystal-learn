require "./array"

module ML
  def ML.train_test_split(size, *, train_size)
    idx = (0..size-1).to_a.shuffle
    {idx.take(train_size), idx.drop(train_size)}
  end

  def ML.train_test_split(size, *, test_size)
    train_size = 1 - test_size
    train_test_split(size, train_size: train_size)
  end

  def ML.accuracy(actual, predicted)
    right = actual.zip(predicted).map {|(x,y)| x == y ? 1 : 0}.sum
    right.to_f / actual.size
  end

  def ML.load_csv(csv_file)
    xs = [] of Array(Float32)
    ys = [] of String

    f = File.open(csv_file)
    CSV.parse(f, separator: ',').each_with_index do |row, idx|
      next if idx == 0
      xs << row[0, row.size - 1].map {|x| x.to_f32}
      ys << row[row.size - 1]
    end
    {xs, ys}
  end

  def ML.load_string_csv(csv_file)
    xs = [] of Array(String)
    ys = [] of Float32

    f = File.open(csv_file)
    CSV.parse(f, separator: ',').each_with_index do |row, idx|
      next if idx == 0
      xs << row[0, row.size - 1]
      ys << row[row.size - 1].to_f32
    end
    {xs, ys}
  end


  def ML.entropy(y)
    y_frequencies = y.frequencies
    y_frequencies.map {|tag, freq| -freq * Math.log(freq, 2)}.sum
  end

  def ML.entropy(y, given x)
    categories_frequencies =  x.frequencies
    categories_frequencies.map {|categoriy, freq| freq * ML.entropy(y[x.indices_of(categoriy)])}.sum
  end

  def ML.gain(y, given x)
    ML.entropy(y) - ML.entropy(y, given: x)
  end

  def ML.std(y, given x)
    y.std
  end
end
