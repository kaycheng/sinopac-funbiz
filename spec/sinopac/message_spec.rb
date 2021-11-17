RSpec::describe Sinopac::Funbiz::Message do
  it "can calculate iv value" do
    result = Sinopac::Funbiz::Message.iv(nonce: dummy_nonce)

    expect(result).to eq dummy_iv
  end

  it "can encrypt message" do
    result = Sinopac::Funbiz::Message.encrypt(
      content: dummy_order_content,
      key: dummy_hash_id,
      iv: dummy_iv
    )

    expect(result).to eq dummy_encrypted_message
  end

  it "can decrypt message" do
    message = dummy_request_params[:Message]
    nonce = dummy_request_params[:Nonce]
    iv = Sinopac::Funbiz::Message.iv(nonce: nonce)

    result = Sinopac::Funbiz::Message.decrypt(
      content: message,
      key: dummy_hash_id,
      iv: iv
    )

    expect(result).to eq dummy_order_content
  end

  private
  def dummy_request_params
    {
      "Version": "1.0.0",
      "ShopNo": "NA0001_001",
      "APIService": "OrderCreate",
      "Sign": "7788EE61DD450944992641B3B2F8210B81A0AE97908BC19825F2A82C0F72EA43",
      "Nonce": "NjM2NjY5MDQ3OTQwMzIuMTphZmJjODBhOTM5NzQ1NjMyNDFhZTczMjVjYzg0Mjg5ZjQxYTk2MWI2ZjNkYTA0NDdmOTRhZjU3ZTIzOWJlNDgz",
      "Message": "4FE341D3A8C30C9A50573F3008F7B1CA8DD96FB2A4346D83936E5C4FDB21E87BA9E3D36A6635C6F5EBBD5438F3CA8FE97DEBB2ADBC82F92BF3C840B3128D8F00116536E7C936D7D587F6220C52C1367DF2BE9CBB16C6A7C6242AA8B38CD2E576328CF727E50FFA49B4F9FBE5DF10986C5299F9FC26E23E956AFDFB92B731FDA84ABEF1C89E0CD0A8CA8F7C23DC2D06E12A6F916EC47CDD9B4D4F87AC0B687EE1088A19F2C35C0FD8B0C97745B926FBAA48FEEDEB826C2C22743DB46781FF220ECA409FC150908540271E60184729C08C73275C54125C3F814FF33CA79A0E1B3902D446925FCC8235809FCBAB7E372D8C29E424CEFF0AD1CBD41E843714EB365158F2FC0B2E6FB48176D5CFF6B68F4BED4D7484C1A4723ABD059DA64A6703B30B0199B170FDF059899552FA1818ABA5B0D0E21014513985A738D59851EDF0B1CFB36A7B7B727109BE7789D284C75E5D694DFC9B7060DCBFD8C7915C95C4E0F29B"
    }
  end

  def dummy_encrypted_message
    "4FE341D3A8C30C9A50573F3008F7B1CA8DD96FB2A4346D83936E5C4FDB21E87BA9E3D36A6635C6F5EBBD5438F3CA8FE97DEBB2ADBC82F92BF3C840B3128D8F00116536E7C936D7D587F6220C52C1367DF2BE9CBB16C6A7C6242AA8B38CD2E576328CF727E50FFA49B4F9FBE5DF10986C5299F9FC26E23E956AFDFB92B731FDA84ABEF1C89E0CD0A8CA8F7C23DC2D06E12A6F916EC47CDD9B4D4F87AC0B687EE1088A19F2C35C0FD8B0C97745B926FBAA48FEEDEB826C2C22743DB46781FF220ECA409FC150908540271E60184729C08C73275C54125C3F814FF33CA79A0E1B3902D446925FCC8235809FCBAB7E372D8C29E424CEFF0AD1CBD41E843714EB365158F2FC0B2E6FB48176D5CFF6B68F4BED4D7484C1A4723ABD059DA64A6703B30B0199B170FDF059899552FA1818ABA5B0D0E21014513985A738D59851EDF0B1CFB36A7B7B727109BE7789D284C75E5D694DFC9B7060DCBFD8C7915C95C4E0F29B"
  end

  def dummy_order_content
    {
      "ShopNo": "NA0001_001",
      "OrderNo": "201807111119291750",
      "Amount": 50000,
      "CurrencyID": "TWD",
      "PayType": "C",
      "ATMParam": {},
      "CardParam": {
        "AutoBilling": "N",
        "ExpMinutes": 30
      },
      "PrdtName": "信用卡訂單",
      "ReturnURL": "http://10.11.22.113:8803/QPay.ApiClient-Sandbox/Store/Return",
      "BackendURL": "https://sandbox.sinopac.com/funBIZ.ApiClient/AutoPush/PushSuccess"
    }
  end

  def dummy_hash_id
    "4DA70F5E2D800D50B43ED3B537480C64"
  end

  def dummy_iv
    "346BBE8E3F34FFEA"
  end

  def dummy_nonce
    "NjM2NjY5MDQ3OTQwMzIuMTphZmJjODBhOTM5NzQ1NjMyNDFhZTczMjVjYzg0Mjg5ZjQxYTk2MWI2ZjNkYTA0NDdmOTRhZjU3ZTIzOWJlNDgz"
  end
end