class ReceiptDTO {

  final String receiptId;
  final String name;
  final String amount;
  final String business;
  final String date;
  final String picture;


  ReceiptDTO(this.receiptId, this.amount, this.business, this.date, this.name, this.picture);
}