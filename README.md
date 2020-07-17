**Pikassa SDK**

1.  Для начала работы необходимо проинициализировать SDK вызовом метода `Pikassa.SetUp(apiKey: "<API KEY>")`, где `<API KEY>` Ваш API-ключ.\
Хорошим местом для инициализации SDK будет метод AppDelegate `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`.
2.  Передача карточных данных осуществляется посредством вызова метода SDK `Pikassa.shared.sendCardData(_ cardData: BankCardDetails, invoiceId: String, didSuccessBlock: ((PayResponse) -> Void)?, didFailBlock: ((Error) -> Void)?)`.\
Здесь `cardData` - структура `BankCardDetails`, описывающая данные платёжной карты;\
`invoiceId` - идентификатор инвойса, который требуется оплатить;\
`didSuccessBlock` - блок, вызываемый в случае успеха запроса или же в случае необходимости редиректа на Web-страницу для ввода кода подтверждения операции (детали редиректа содержатся в поле `redirect` структуры `PayResponse`);\
`didFailBlock` - блок, вызываемый в случае ошибки запроса. 