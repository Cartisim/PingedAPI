import Mailgun

extension MailgunDomain {
    
    //Set to your domain on mail gun
    static var sandbox: MailgunDomain { .init("api.cartisim.io", .us)}
}
