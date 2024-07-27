String formatDateTime(DateTime datetime) {
  String format(int value) {
    return value.toString().padLeft(2, '0');
  }

  return '${format(datetime.day)}/${format(datetime.month)}/${datetime.year} '
      '${format(datetime.hour)}:${format(datetime.minute)}';
}
