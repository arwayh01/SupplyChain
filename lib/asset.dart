class Asset {
  String name;
  String description;
  String descriptionProcess;
  String descriptionDistribution;
  String manufacturer;
  bool initialized;
  bool verify;



  Asset({
    required this.name,
    required this.description,
    required this.descriptionProcess,
    required this.descriptionDistribution,
    required this.manufacturer,
    required this.initialized,
    required this.verify
  });
}