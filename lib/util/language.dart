class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "πΊπΈ", "en-US"),
      Language(2, "France", "π«π·", "fr"),
      Language(3, "ααΌααΊαα¬", "π²π²", "my"),
    ];
  }
}
