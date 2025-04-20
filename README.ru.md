relux-sample

Пример проекта, демонстрирующий использование Relux — архитектуры в стиле Redux с поддержкой асинхронности, написанной на чистом Swift.

🔧 Технологии

Язык: Swift 6

Архитектура: unidirectional data flow (Redux-like)

Навигация: построена на тех же принципах через экшены

IoC: асинхронный dependency injection (SwiftIoC)

UI: SwiftUI с дополнительными фичами через SwiftUI-Relux

📦 Основные идеи

📚 Модульные неймспейсы

Все части приложения организованы через неймспейсы на базе enum'ов — например, SampleApp.UI.Root, Auth.UI, Notes.UI, Account.UI, Navigation.UI. Это обеспечивает чистое разделение, масштабируемость и поддержку scoped-архитектуры.

🔁 Архитектура в стиле Redux

Проект использует движок Relux и реализует поток данных в духе Redux:

State → источник истины

Relux.State: базовый протокол

HybridState: для простых случаев, где бизнес и UI логика живут вместе

BusinessState и UIState: разделение логики для сложных кейсов

Позволяет переиспользовать бизнес-стейт в нескольких UI

Возможны маппинги и зависимости между состояниями

Action → намерения от пользователя или системы

Enum-подобные типы, реализующие Relux.Action

Типобезопасные и расширяемые

Reducer → асинхронное изменение состояния

Это mutating метод внутри состояния: mutating func reduce(action: Action) async

Может вызывать await и мутировать self

Не является чистой функцией, работает внутри контекста текущего стора

Saga → асинхронные побочные эффекты

Используют async/await

Подходят для API-запросов, таймеров, цепочек действий

Effect → триггеры сайд-эффектов в сагах

Реализуют Relux.Effect

Используются как сигналы внутри саг, чтобы запускать действия вне стора

Relux полностью построен на Swift Concurrency и поддерживает structured concurrency. Вся обработка — от эффекта до редюса данных в стейте — асинхронная и безопасна по отношению к состоянию.

🧭 Навигация через Redux

Навигация реализуется как экшены — состояние маршрута такое же состояние, как и всё остальное:

Поддерживает диплинки, тестирование, инспекцию

Работает как на iOS 16 (через бэкпорт), так и на iOS 17+

📌 Два способа навигации:

1. Через модификатор:

Text("Go to Profile")
    .navigate(to: .profile)

2. Через Relux.NavigationLink:

Relux.NavigationLink(page: .profile) {
    Text("Profile")
}

Под капотом используется AsyncButton, который защищает от повторных тапов, пока идёт анимация.

🧵 Асинхронный Redux и IoC

В Relux всё асинхронное — редьюсеры, сайд-эффекты, IoC. Именно поэтому используется SwiftIoC:

resolve() и getAsync() работают через await

Поддержка жизненных циклов .container и .transient

Встроенные блокировки гарантируют безопасность при доступе из разных тасков

🧼 Интеграция с SwiftUI через SwiftUI-Relux

Relux.Resolver оборачивает splash/root view и асинхронно резолвит инстанс Relux

UI-стейты автоматически пробрасываются в SwiftUI через .passingObservableToEnvironment()

Есть поддержка Container-протокола и модификаторов для навигации

Пример:

Relux.Resolver(
    splash: {
        SplashScreenView()
    },
    content: { relux in
        SampleApp.UI.Root.Container()
            .passingObservableToEnvironment(fromStore: relux.store)
    },
    resolver: {
        await Relux.Registry.resolve(Relux.self)
    }
)

☂️ Библиотека swiftui-relux

Даёт плюшки для SwiftUI-интеграции:

Relux.Resolver — загрузка и передача стейта в корневую вью

.passingObservableToEnvironment() — проброс UI-объектов

Container — протокол для корневых экранов

📁 Структура проекта

Modules/
  SampleApp/           — корневой модуль приложения (Root + Main UI)
  Auth/                — экран аутентификации
  Account/             — управление аккаунтом
  Notes/               — модуль заметок
  Navigation/          — логика навигации
  Logger/              — логгер для экшенов
Utils/                 — утилиты и экстеншены (GCD, Sequence, и т.п.)

🧩 Зависимости

darwin-relux

swift-ioc

swiftui-relux

swiftui-reluxrouter

Дополнительные зависимости

darwin-foundationplus

darwin-logger

swift-algorithms

swift-stdlibplus

swiftui-plus

🪪 Лицензия

MIT

