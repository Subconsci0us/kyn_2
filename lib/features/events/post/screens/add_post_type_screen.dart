import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:kyn_2/core/common/loader.dart';
import 'package:kyn_2/core/theme/pallete.dart';
import 'package:kyn_2/core/theme/theme.dart';
import 'package:kyn_2/core/utils.dart';
import 'package:kyn_2/features/events/post/controller/post_controller.dart';
import 'package:kyn_2/models/post_model.dart';
import 'package:location/location.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const AddPostTypeScreen(),
      );
  const AddPostTypeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  Location location = new Location();
  Map<String, dynamic>? position; // State variable for location

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? bannerFile;
  Category? selectedCategory;
  String selectedTime = "Today";
  DateTime selectedDate = DateTime.now();

  Map<String, String> categoryToBanner = {
    'Emergency': 'assets/images/emergency.jpg',
    'Service': 'assets/images/service.jpg',
    'Event': 'assets/images/events.jpg',
    'Business': 'assets/images/business.jpg',
  };

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage(false, 16, 9);

    if (res != null) {
      setState(() {
        bannerFile = res;
      });
    }
  }

  Future<void> addLocation() async {
    try {
      final GeoFirePoint geoFirePoint =
          GeoFirePoint(GeoPoint(24.847164, 67.036979));

      setState(() {
        position = geoFirePoint.data;
      });
    } catch (e) {
      showSnackBar(context, 'Failed to get location: $e');
    }
  }

  void sharePost() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      showSnackBar(context, 'Please enter the title');
      return;
    }

    if (selectedCategory == null) {
      showSnackBar(context, 'Please select a category');
      return;
    }

    // Proceed with sharing the post
    ref.read(postControllerProvider.notifier).sharePost(
          context: context,
          title: title,
          description: description,
          file: bannerFile,
          category: selectedCategory!,
          position: position!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    final theme = ref.watch(themeNotifierProvider);

    // Get the appropriate text color based on the theme
    final textColor =
        theme.brightness == Brightness.light ? Colors.black : Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Loader(color: Colors.red)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Choose Post Category
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Choose Post Category',
                      labelStyle: TextStyle(color: textColor),
                      border: const OutlineInputBorder(),
                    ),
                    items: Category.values.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name,
                            style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (Category? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Event Name
                  _buildTextField(titleController, 'Event Name', textColor),
                  const SizedBox(height: 16),

                  // Event Description
                  _buildTextField(
                      descriptionController, 'Event Description', textColor,
                      maxLines: 3),
                  const SizedBox(height: 16),

                  // Time & Date
                  Text(
                    'Time & Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TimeButton(
                          label: "Today",
                          isSelected: selectedTime == "Today",
                          onTap: () => setState(() {
                                selectedTime = "Today";
                              })),
                      _TimeButton(
                          label: "Tomorrow",
                          isSelected: selectedTime == "Tomorrow",
                          onTap: () => setState(() {
                                selectedTime = "Tomorrow";
                              })),
                      _TimeButton(
                          label: "This Week",
                          isSelected: selectedTime == "This Week",
                          onTap: () => setState(() {
                                selectedTime = "This Week";
                              })),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
                  _buildDatePicker(textColor),
                  const SizedBox(height: 16),

                  // Location
                  ElevatedButton(
                    onPressed: () {
                      print("Button pressed!");
                      addLocation();
                    },
                    child: Text(
                      position == null
                          ? 'Tap to get location'
                          : 'Lat: ${position!['latitude']}, Long: ${position!['longitude']}',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Banner Image
                  _buildBannerImage(),
                  const SizedBox(height: 16),

                  // Create Post Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sharePost,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('CREATE POST'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, Color textColor,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker(Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(
          'Choose from calendar (${selectedDate.toLocal().toString().split(' ')[0]})',
          style: TextStyle(color: textColor),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: _pickDate,
      ),
    );
  }

  Widget _buildBannerImage() {
    return GestureDetector(
      onTap: selectBannerImage,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        color: AppPallete.borderColor,
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: bannerFile == null
              ? const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                  ),
                )
              : Image.file(
                  bannerFile!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
