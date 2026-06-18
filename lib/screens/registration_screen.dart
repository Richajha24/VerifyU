import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _branchController = TextEditingController();
  final _cityController = TextEditingController();

  int _selectedYear = 3;
  int _selectedGradYear = 2027;

  final List<String> _allInterests = [
    'AI/ML',
    'Data Science',
    'Flutter',
    'Web Development',
    'UI/UX',
    'Product',
    'Cybersecurity',
    'Cloud'
  ];

  final List<String> _selectedInterests = [];

  String _photoUrl = '';

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _branchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Top static header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set up your profile",
                    style: AppTheme.headingStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "This appears on your share card and public portfolio, so recruiters know exactly who they're verifying.",
                    style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.tan),
                  ),
                ],
              ),
            ),

            // Scrollable fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo preview/select
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Dynamic mock photo based on current name
                          final name = _nameController.text.trim();
                          setState(() {
                            _photoUrl = "https://api.dicebear.com/7.x/adventurer/svg?seed=${name.isNotEmpty ? name : 'verifyu'}";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Mock Profile Photo selected!")),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: AppColors.warmWhite,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.sand2, width: 2),
                              ),
                              child: ClipOval(
                                child: _photoUrl.isNotEmpty
                                    ? Image.network(_photoUrl, fit: BoxFit.cover)
                                    : const Icon(Icons.person, size: 40, color: AppColors.tan),
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.rose,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.ivory, width: 2),
                              ),
                              child: const Icon(Icons.edit, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Inputs
                    AppTextField(
                      label: "Full name",
                      placeholder: "e.g. Aisha Khan",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 18),

                    AppTextField(
                      label: "College / university",
                      placeholder: "e.g. VIT Vellore",
                      controller: _collegeController,
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: "Branch",
                            placeholder: "e.g. CSE",
                            controller: _branchController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Year",
                                style: AppTheme.bodyStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.warmWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.sand, width: 1.5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _selectedYear,
                                    isExpanded: true,
                                    dropdownColor: AppColors.warmWhite,
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        setState(() => _selectedYear = newValue);
                                      }
                                    },
                                    items: [1, 2, 3, 4]
                                        .map((y) => DropdownMenuItem<int>(
                                              value: y,
                                              child: Text("Year $y", style: AppTheme.bodyStyle(fontSize: 14)),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Graduation Year",
                                style: AppTheme.bodyStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.warmWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.sand, width: 1.5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _selectedGradYear,
                                    isExpanded: true,
                                    dropdownColor: AppColors.warmWhite,
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        setState(() => _selectedGradYear = newValue);
                                      }
                                    },
                                    items: List.generate(7, (index) => 2024 + index)
                                        .map((yr) => DropdownMenuItem<int>(
                                              value: yr,
                                              child: Text(yr.toString(), style: AppTheme.bodyStyle(fontSize: 14)),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: "City",
                            placeholder: "e.g. Vellore",
                            controller: _cityController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Career Interest Chips
                    Text(
                      "Career Interests",
                      style: AppTheme.bodyStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allInterests.map((interest) {
                        final isSelected = _selectedInterests.contains(interest);
                        return ChoiceChip(
                          label: Text(interest),
                          selected: isSelected,
                          selectedColor: AppColors.forest,
                          backgroundColor: Colors.transparent,
                          checkmarkColor: Colors.white,
                          labelStyle: AppTheme.bodyStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: isSelected ? AppColors.forest : AppColors.sand2,
                              width: 1.5,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(22),
              child: userProvider.isLoading
                  ? const CircularProgressIndicator(color: AppColors.forest)
                  : AppButton(
                      text: "Create My Profile",
                      type: AppButtonType.filledForest,
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        final college = _collegeController.text.trim();
                        final branch = _branchController.text.trim();
                        final city = _cityController.text.trim();

                        if (name.isEmpty || college.isEmpty || branch.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill in Name, College, and Branch")),
                          );
                          return;
                        }

                        await userProvider.registerUser(
                          name: name,
                          college: college,
                          branch: branch,
                          year: _selectedYear,
                          gradYear: _selectedGradYear,
                          city: city,
                          interests: _selectedInterests,
                          photoUrl: _photoUrl,
                        );

                        // Direct to Navigation Hub
                        Navigator.pushReplacementNamed(context, '/main');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
