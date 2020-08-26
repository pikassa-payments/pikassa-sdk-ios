**Pikassa SDK**

## Подключение зависимостей

1. Установите CocoaPods

  ```shell
  gem install cocoapods
  ```

2. Создайте файл Podfile

  > CocoaPods предоставляет команду ```pod init``` для создания Podfile с настройками по умолчанию.

3. Добавьте зависимости в `Podfile`

  ```shell
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '11.0'
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

## Пример использования
Работа с библиотекой осуществляется через объект ```Pikassa```, у которого доступны 2 метода: ```setup(), sendPaymentData()```. 

1. Для начала необходимо вызвать метод ```setup```:
```swift
Pikassa.setup("your_api_key")
```
где ```"your_api_key"``` - ключ доступа к API.

2. После инициализации можно вызвать метод отправки данных:
```swift
func sendPaymentData(
    method: PaymentMethods,
    invoiceId: String,
    didSuccessBlock: ((PayResponse) -> Void)?,
    didFailBlock: ((Error) -> Void)?)
```

где ```method``` - один из поддерживаемых способов оплаты (далее, в п. 3) ```invoiceId``` - номер счета на оплату ```didSuccessBlock``` - результат успешной передачи карточных данных, возвращает информацию с сервера в случае успеха (```PayResponse```), ```didFailBlock``` - ошибка при передаче данных, возвращает стандартную ошибку (```Error```).

3. На данный момент поддерживаются два метода оплаты - картой (с готовой структурой ```BankCardDetails```) и с кастомным словарем полей:
```swift
public enum PaymentMethods {
    case bankCard(details: BankCardDetails)
    
    case custom(details: [String: String])
}
```

4. Описание полей ```BankCardDetails```
```pan``` - номер карты
```cardHolder``` - владелец карты;
```expYear``` - год окончания срока действия карты (формат "YY");
```expMonth``` - месяц окончания срока действия карты (формат "mm");
```cvc``` - код с обратной стороны (3 цифры);

И пример вызова:
```swift
let cardDetails: BankCardDetails = BankCardDetails(
            pan: "4444 4444 4444 4444",
            cardHolder: "CARD HOLDER",
            cvc: "999",
            expYear: "2024",
            expMonth: "11")
        
        Pikassa.sendPaymentData(
            method: PaymentMethods.bankCard(details: cardDetails),
            invoiceId: "<invoice id>",
            didSuccessBlock: { ... },
            didFailBlock: { ... })
```

5. Для вызова передачи платежных данных с кастомными полями для вызова обязательным является наличие параметра "paymentMethod" в передаваемом словаре:
```swift        
        Pikassa.sendPaymentData(
            method: PaymentMethods.custom([ "paymentMethod": "Mobile", "phone" : "+79999999999"]),
            invoiceId: "<invoice id>",
            didSuccessBlock: { ... },
            didFailBlock: { ... })
```
[Перечень методов оплаты](https://pikassa.io/docs/#74002ad38d)

6. В случае успеха выполнения отправки данных, в onSuccess приходит ответ ResponseData, структура которого выглядит следующим образом:
```swift
public struct PayResponse: Decodable {
    public let uuid: String
    public let requestId: String
    public let redirect: Redirect?
}
```
uuid - идентификатор платежа; requestId - идентификатор запроса redirect - ссылка для перенаправления пользователя. Например, для карт может потребоваться перенаправление пользователя на страницу ввода кода 3DS. Может быть нулевым, если аутентификация не нужна при платеже. В случае, если ненулевое поле, то структура следующая:
```swift
public struct Redirect: Decodable {
    public let url: String
    public let method: String             //метод оплаты
    public let params: [[String: String]] //дополнительные возвращаемые параметры
}
```
Здесь основным параметром является url, в котором хранится ссылка на редирект, по которому нужно пройти для подтверждения платежа.
