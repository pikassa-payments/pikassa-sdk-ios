**Pikassa SDK**

## Подключение зависимостей

1. Установите CocoaPods

  ```shell
  gem install cocoapods
  ```

2. Создайте файл Podfile\

  > CocoaPods предоставляет команду ```pod init``` для создания Podfile с настройками по умолчанию.

3. Добавьте зависимости в `Podfile`.\

  ```shell
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '8.0'
  use_frameworks!

  target 'Your Target Name' do
    pod 'PikassaSDK',
      :git => 'https://github.com/pikassa-payments/pikassa-sdk-ios.git',
      :tag => 'tag'
  end
  ```

  > `Your Target Name` - название таргета в Xcode для вашего приложения.\
  > `tag` - версия SDK. Актуальную версию можно узнать на github в разделе [releases](https://github.com/pikassa-payments/pikassa-sdk-ios/releases).

4. Выполните команду ```pod install```

## Использование

1.  Для начала работы необходимо проинициализировать SDK вызовом метода `Pikassa.SetUp(apiKey: "<API KEY>")`, где `<API KEY>` Ваш API-ключ.\
Хорошим местом для инициализации SDK будет метод AppDelegate `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`.
2.  Передача карточных данных осуществляется посредством вызова метода SDK `Pikassa.shared.sendCardData(_ cardData: BankCardDetails, invoiceId: String, didSuccessBlock: ((PayResponse) -> Void)?, didFailBlock: ((Error) -> Void)?)`.\
Здесь `cardData` - структура `BankCardDetails`, описывающая данные платёжной карты;\
`invoiceId` - идентификатор инвойса, который требуется оплатить;\
`didSuccessBlock` - блок, вызываемый в случае успеха запроса или же в случае необходимости редиректа на Web-страницу для ввода кода подтверждения операции (детали редиректа содержатся в поле `redirect` структуры `PayResponse`);\
`didFailBlock` - блок, вызываемый в случае ошибки запроса. 
