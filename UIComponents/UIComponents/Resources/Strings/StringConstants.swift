// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
public enum L10n {
  public enum Componenets {

    public enum Action {
      /// Block
      public static var block: String { L10n.tr("Componenets", "Action.block") }
      /// Giriş yapmanız gereklidir.
      public static var loginWarning: String { L10n.tr("Componenets", "Action.loginWarning") }
    }

    public enum Comment {
      /// Bir şeyler yazın..
      public static var placeholder: String { L10n.tr("Componenets", "Comment.placeholder") }
    }
  }
  public enum Error {
    /// Lütfen bilgilerinizi kontrol ediniz.
    public static var checkInformations: String { L10n.tr("Error", "checkInformations") }
    /// %@ alanı boş olamaz.
    public static func empty(_ p1: String) -> String {
      return L10n.tr("Error", "empty", p1)
    }
    /// Lütfen boş alanları doldurunuz.
    public static var emptyFields: String { L10n.tr("Error", "emptyFields") }
    /// Lütfen ekranı yukarıdan aşağıya kaydırarak yenileyiniz.
    public static var refreshFromTop: String { L10n.tr("Error", "refreshFromTop") }

    public enum Key {
      /// Yorum
      public static var comment: String { L10n.tr("Error", "Key.comment") }
      /// E-posta
      public static var email: String { L10n.tr("Error", "Key.email") }
      /// Username
      public static var username: String { L10n.tr("Error", "Key.username") }
    }
  }
  public enum General {
    /// Yorum Ekle
    public static var addComment: String { L10n.tr("General", "addComment") }
    /// Yorum
    public static var comment: String { L10n.tr("General", "comment") }
    /// Yorumlar
    public static var comments: String { L10n.tr("General", "comments") }
    /// Takip Et
    public static var follow: String { L10n.tr("General", "follow") }
    /// Takipçi
    public static var follower: String { L10n.tr("General", "follower") }
    /// Takip Ediliyor
    public static var following: String { L10n.tr("General", "following") }
    /// Vazgeç
    public static var giveUp: String { L10n.tr("General", "giveUp") }
    /// Beğeni
    public static var like: String { L10n.tr("General", "like") }
    /// Giriş Yap
    public static var login: String { L10n.tr("General", "login") }
    /// Tarif
    public static var recipe: String { L10n.tr("General", "recipe") }
    /// Malzemeler
    public static var recipeIngredients: String { L10n.tr("General", "recipeIngredients") }
    /// Yapılışı
    public static var recipeSteps: String { L10n.tr("General", "recipeSteps") }
    /// Üye Ol
    public static var register: String { L10n.tr("General", "register") }
  }
  public enum Modules {

    public enum CommentEditController {
      /// Kaydet
      public static var save: String { L10n.tr("Modules", "CommentEditController.save") }
      /// YORUM DÜZENLE
      public static var title: String { L10n.tr("Modules", "CommentEditController.title") }
    }

    public enum CommentListController {
      /// YORUMLAR
      public static var title: String { L10n.tr("Modules", "CommentListController.title") }
    }

    public enum Favorites {
      /// TÜMÜNÜ GÖR
      public static var seeAllButtonTitle: String { L10n.tr("Modules", "Favorites.seeAllButtonTitle") }
    }

    public enum Home {
      /// EDİTÖR SEÇİMİ
      public static var editorChoiceRecipes: String { L10n.tr("Modules", "Home.editorChoiceRecipes") }
      /// SON EKLENENLER
      public static var lastAddedRecipes: String { L10n.tr("Modules", "Home.lastAddedRecipes") }
      /// %@ Yorum %@ Beğeni
      public static func recipeCommnetAndLikeCount(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Modules", "Home.recipeCommnetAndLikeCount", p1, p2)
      }
      /// %@ Tarif %@ Takipçi
      public static func userRecipeAndFollowerCount(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Modules", "Home.userRecipeAndFollowerCount", p1, p2)
      }
    }

    public enum LoginViewController {
      /// Hesabın mı yok?
      public static var bottomText: String { L10n.tr("Modules", "LoginViewController.bottomText") }
      /// Şifrenizi mi unuttunuz?
      public static var forgotPassword: String { L10n.tr("Modules", "LoginViewController.forgotPassword") }
      /// Giriş Yap
      public static var title: String { L10n.tr("Modules", "LoginViewController.title") }
    }

    public enum PasswordResetController {
      /// Sıfırla
      public static var reset: String { L10n.tr("Modules", "PasswordResetController.reset") }
      /// Şifre Sıfırlama
      public static var title: String { L10n.tr("Modules", "PasswordResetController.title") }
    }

    public enum RecipeDetail {
      /// Henüz yorum yapılmamıştır.
      public static var noComment: String { L10n.tr("Modules", "RecipeDetail.noComment") }
    }

    public enum RegisterViewController {
      /// Hesabın mı var?
      public static var bottomText: String { L10n.tr("Modules", "RegisterViewController.bottomText") }
      /// Üye Ol
      public static var title: String { L10n.tr("Modules", "RegisterViewController.title") }
    }

    public enum SignIn {
      /// Sign In
      public static var navigationTitle: String { L10n.tr("Modules", "SignIn.navigationTitle") }
    }

    public enum WalkThrough {
      /// Fodamy is the best place to find your favorite recipes in all around the world.
      public static var descriptionText: String { L10n.tr("Modules", "WalkThrough.descriptionText") }
      /// Welcome to Fodamy Network!
      public static var firstTitle: String { L10n.tr("Modules", "WalkThrough.firstTitle") }
      /// Share recipes with others.
      public static var fourthTitle: String { L10n.tr("Modules", "WalkThrough.fourthTitle") }
      /// İlerle
      public static var next: String { L10n.tr("Modules", "WalkThrough.Next") }
      /// Finding recipes were not that easy.
      public static var secondTitle: String { L10n.tr("Modules", "WalkThrough.secondTitle") }
      /// Başla!
      public static var start: String { L10n.tr("Modules", "WalkThrough.Start") }
      /// Add new recipe.
      public static var thirdTitle: String { L10n.tr("Modules", "WalkThrough.thirdTitle") }
    }
  }
  public enum Placeholder {
    /// E-mail Adresi
    public static var email: String { L10n.tr("Placeholder", "email") }
    /// Şifre
    public static var password: String { L10n.tr("Placeholder", "password") }
    /// Kullanıcı Adı
    public static var username: String { L10n.tr("Placeholder", "username") }
  }
  public enum Screens {
    /// Continue
    public static var `continue`: String { L10n.tr("Screens", "continue") }
    /// Privacy Policy
    public static var privacy: String { L10n.tr("Screens", "privacy") }
    /// Terms of Use
    public static var terms: String { L10n.tr("Screens", "terms") }

    public enum Alert {

      public enum Camera {
        /// You need to go to Settings and allow access to Camera to use this feature.
        public static var desc: String { L10n.tr("Screens", "Alert.camera.desc") }
        /// An error occurred while removing the background.
        public static var error: String { L10n.tr("Screens", "Alert.camera.error") }
        /// OK
        public static var ok: String { L10n.tr("Screens", "Alert.camera.ok") }
        /// Settings
        public static var settings: String { L10n.tr("Screens", "Alert.camera.settings") }
        /// Camera Unavailable
        public static var title: String { L10n.tr("Screens", "Alert.camera.title") }
      }

      public enum Welcome {
        /// Help us out! Our app is completely free and your rating will help us to keep the app free
        public static var desc: String { L10n.tr("Screens", "Alert.welcome.desc") }
        /// No, Thanks
        public static var no: String { L10n.tr("Screens", "Alert.welcome.no") }
        /// Welcome!
        public static var title: String { L10n.tr("Screens", "Alert.welcome.title") }
        /// Rate the app 🎉
        public static var yes: String { L10n.tr("Screens", "Alert.welcome.yes") }
      }
    }

    public enum Edit {
      /// Color
      public static var color: String { L10n.tr("Screens", "Edit.Color") }
      /// Done
      public static var done: String { L10n.tr("Screens", "Edit.Done") }
      /// Filter
      public static var filter: String { L10n.tr("Screens", "Edit.Filter") }
      /// Ok
      public static var ok: String { L10n.tr("Screens", "Edit.Ok") }
      /// Resize
      public static var resize: String { L10n.tr("Screens", "Edit.Resize") }
      /// Edit Your Photo
      public static var title: String { L10n.tr("Screens", "Edit.title") }

      public enum Instructions {
        /// Tap here when you are done.
        public static var _1: String { L10n.tr("Screens", "Edit.instructions.1") }
        /// You can pinch with your fingers to zoom in and out the photo.
        public static var _2: String { L10n.tr("Screens", "Edit.instructions.2") }
        /// Tap here for more detailed and custom resizing.
        public static var _3: String { L10n.tr("Screens", "Edit.instructions.3") }
      }
    }

    public enum Export {
      /// Congratulations! Your photo is ready.\nNow, choose how you want to export
      public static var desc: String { L10n.tr("Screens", "Export.desc") }
      /// Download
      public static var download: String { L10n.tr("Screens", "Export.download") }
      /// Print
      public static var print: String { L10n.tr("Screens", "Export.print") }
      /// Share
      public static var share: String { L10n.tr("Screens", "Export.share") }
      /// Export Photo
      public static var title: String { L10n.tr("Screens", "Export.title") }

      public enum Download {
        /// Download to gallery
        public static var desc: String { L10n.tr("Screens", "Export.download.desc") }

        public enum Alert {
          /// Your photo has been successfully saved to the gallery.
          public static var desc: String { L10n.tr("Screens", "Export.download.alert.desc") }
          /// Photo Downloaded!
          public static var title: String { L10n.tr("Screens", "Export.download.alert.title") }
        }
      }

      public enum Print {
        /// Print with your Printer
        public static var desc: String { L10n.tr("Screens", "Export.print.desc") }
      }

      public enum Share {
        /// Share with your Friends
        public static var desc: String { L10n.tr("Screens", "Export.share.desc") }
      }
    }

    public enum Home {
      /// Let’s start with selecting your photo
      public static var desc: String { L10n.tr("Screens", "Home.desc") }
      /// Passport Photo
      public static var title: String { L10n.tr("Screens", "Home.title") }

      public enum Gallery {
        /// Import a photo from iPhone Gallery
        public static var desc: String { L10n.tr("Screens", "Home.gallery.desc") }
        /// Gallery
        public static var title: String { L10n.tr("Screens", "Home.gallery.title") }
      }

      public enum Icloud {
        /// Import a photo from iCloud Gallery
        public static var desc: String { L10n.tr("Screens", "Home.icloud.desc") }
        /// iCloud
        public static var title: String { L10n.tr("Screens", "Home.icloud.title") }
      }

      public enum Photo {
        /// Take a photo from camera
        public static var desc: String { L10n.tr("Screens", "Home.photo.desc") }
        /// Take Photo
        public static var title: String { L10n.tr("Screens", "Home.photo.title") }
      }
    }

    public enum Language {
      /// Change Language
      public static var title: String { L10n.tr("Screens", "Language.title") }
    }

    public enum Paywall {
      /// week
      public static var week: String { L10n.tr("Screens", "Paywall.week") }
      /// Weekly Plan
      public static var weekly: String { L10n.tr("Screens", "Paywall.weekly") }
      /// 3 Days Free
      public static var yearly: String { L10n.tr("Screens", "Paywall.yearly") }

      public enum Advantage {
        /// Unlimited Passport Photo
        public static var _1: String { L10n.tr("Screens", "Paywall.advantage.1") }
        /// Resize Photos
        public static var _2: String { L10n.tr("Screens", "Paywall.advantage.2") }
        /// Edit Photos
        public static var _3: String { L10n.tr("Screens", "Paywall.advantage.3") }
        /// Cancel anytime
        public static var _4: String { L10n.tr("Screens", "Paywall.advantage.4") }
      }

      public enum Title {
        /// Unlimited Access
        public static var _1: String { L10n.tr("Screens", "Paywall.title.1") }
        /// to All Features
        public static var _2: String { L10n.tr("Screens", "Paywall.title.2") }
      }

      public enum Weekly {
        /// %@/week
        public static func price(_ p1: String) -> String {
          return L10n.tr("Screens", "Paywall.weekly.price", p1)
        }
      }

      public enum Yearly {
        /// then %@/year
        public static func price(_ p1: String) -> String {
          return L10n.tr("Screens", "Paywall.yearly.price", p1)
        }
      }
    }

    public enum Processing {
      /// We're working on remove your photo background. Please wait a few moments.
      public static var desc: String { L10n.tr("Screens", "Processing.desc") }
      /// Processing
      public static var title: String { L10n.tr("Screens", "Processing.title") }
    }

    public enum Rating {
      /// Great!
      public static var great: String { L10n.tr("Screens", "Rating.great") }
      /// Next Time
      public static var next: String { L10n.tr("Screens", "Rating.next") }
      /// Sure!
      public static var sure: String { L10n.tr("Screens", "Rating.sure") }

      public enum Download {
        /// You’ve downloaded the photo. Now you can see your photo from “Photos” app.
        public static var desc: String { L10n.tr("Screens", "Rating.download.desc") }
        /// Photo Downloaded 🎉
        public static var title: String { L10n.tr("Screens", "Rating.download.title") }
      }

      public enum Onboard {
        /// Can you show us some love?
        public static var desc: String { L10n.tr("Screens", "Rating.onboard.desc") }
        /// Please help us to grow 🙏
        public static var title: String { L10n.tr("Screens", "Rating.onboard.title") }
      }

      public enum Print {
        /// You’ve successfully printed your passport photo!
        public static var desc: String { L10n.tr("Screens", "Rating.print.desc") }
        /// Photo Printed 🎉
        public static var title: String { L10n.tr("Screens", "Rating.print.title") }
      }

      public enum Ready {
        /// Your passport photo is ready! Now you can download, share and print. Please take a moment to rate us
        public static var desc: String { L10n.tr("Screens", "Rating.ready.desc") }
        /// Your Photo is Ready 🎉
        public static var title: String { L10n.tr("Screens", "Rating.ready.title") }
      }

      public enum Share {
        /// You’ve successfully shared your passport photo!
        public static var desc: String { L10n.tr("Screens", "Rating.share.desc") }
        /// Photo Shared 🎉
        public static var title: String { L10n.tr("Screens", "Rating.share.title") }
      }
    }

    public enum Settings {
      /// Customer Support
      public static var contact: String { L10n.tr("Screens", "Settings.contact") }
      /// Share Your Love
      public static var rate: String { L10n.tr("Screens", "Settings.rate") }
      /// Share Us
      public static var share: String { L10n.tr("Screens", "Settings.share") }
      /// Settings
      public static var title: String { L10n.tr("Screens", "Settings.title") }
      /// Unlock Premium
      public static var unlock: String { L10n.tr("Screens", "Settings.unlock") }
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    guard let bundle = LocalizableManager.bundle else {
        fatalError("Cannot find bundle!")
    }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    let locale = Locale(identifier: LocalizableManager.lang)
    return String(format: format, locale: locale, arguments: args)
  }
}

private final class BundleToken {}
