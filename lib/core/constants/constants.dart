import 'package:kyn_2/models/post_model.dart';

class Constants {
  static const List<String> topics = [
    'Technology',
    'Business',
    'Programming',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Politics',
    'Education',
    'Environment',
  ];

  static const noConnectionErrorMessage = 'Not connected to a network!';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const eventDefault =
      'https://firebasestorage.googleapis.com/v0/b/ikyn-1326b.firebasestorage.app/o/default_images%2Fevent.jpg?alt=media&token=1e7409c5-ab53-4ebd-8ee8-868d7f19e624';

  static const emergencyDefault =
      'https://firebasestorage.googleapis.com/v0/b/ikyn-1326b.firebasestorage.app/o/default_images%2Femergency.jpg?alt=media&token=2f4daf92-ef90-4194-8ac7-596669809bad';

  static const serviceDefault =
      'https://firebasestorage.googleapis.com/v0/b/ikyn-1326b.firebasestorage.app/o/default_images%2Fservice.jpg?alt=media&token=87b2e7d0-af94-4b8e-bb3f-7adb2062d272';

  static const businessDefault =
      'https://firebasestorage.googleapis.com/v0/b/ikyn-1326b.firebasestorage.app/o/default_images%2FBusiness.jpg?alt=media&token=867a9c8f-5233-44fd-929a-3d50a787c3e7';

  String getDefaultImageForCategory(Category category) {
    switch (category) {
      case Category.Event:
        return eventDefault;
      case Category.Emergency:
        return emergencyDefault;
      case Category.Services:
        return serviceDefault;
      case Category.Business:
        return businessDefault;
      default:
        return eventDefault; // Default to event if no match
    }
  }
}
