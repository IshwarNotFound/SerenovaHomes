import 'package:flutter/material.dart';
import 'package:real_estate_app/models/property.dart';

class InquiryFormScreen extends StatefulWidget {
  final Property property;

  const InquiryFormScreen({super.key, required this.property});

  @override
  State<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends State<InquiryFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  
  late AnimationController _animationController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme, isDesktop),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
                padding: EdgeInsets.all(isDesktop ? 40.0 : 24.0),
                child: Column(
                  children: [
                    _buildPropertyCard(theme, isDesktop),
                    SizedBox(height: isDesktop ? 40 : 32),
                    _buildForm(theme, isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, bool isDesktop) {
    return SliverAppBar(
      expandedHeight: isDesktop ? 180.0 : 140.0,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF5B9BD5)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A4D8C).withValues(alpha: 0.3),
                const Color(0xFF5B9BD5).withValues(alpha: 0.15),
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _animationController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: const Color(0xFF5B9BD5),
                      size: isDesktop ? 56 : 48,
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      'Property Inquiry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8 : 6),
                    Text(
                      'We\'ll get back to you shortly',
                      style: TextStyle(
                        color: const Color(0xFF5B9BD5).withValues(alpha: 0.8),
                        fontSize: isDesktop ? 14 : 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCard(ThemeData theme, bool isDesktop) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B9BD5).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: Image.network(
                  widget.property.imageUrl,
                  height: isDesktop ? 280 : 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isDesktop ? 24.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.property.type,
                            style: TextStyle(
                              color: const Color(0xFF5B9BD5),
                              fontWeight: FontWeight.bold,
                              fontSize: isDesktop ? 13 : 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF5B9BD5),
                          size: isDesktop ? 24 : 20,
                        ),
                        SizedBox(width: isDesktop ? 8 : 6),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: const Color(0xFF5B9BD5),
                            fontWeight: FontWeight.w600,
                            fontSize: isDesktop ? 14 : 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      widget.property.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 24 : 20,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 12 : 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: const Color(0xFF5B9BD5),
                          size: isDesktop ? 20 : 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.property.address,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: isDesktop ? 14 : 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, bool isDesktop) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _animationController,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_rounded,
                theme: theme,
                isDesktop: isDesktop,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'your.email@example.com',
                icon: Icons.email_rounded,
                theme: theme,
                isDesktop: isDesktop,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '+91 98765 43210',
                icon: Icons.phone_rounded,
                theme: theme,
                isDesktop: isDesktop,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              _buildTextField(
                controller: _messageController,
                label: 'Message',
                hint: 'Tell us about your requirements...',
                icon: Icons.message_rounded,
                theme: theme,
                isDesktop: isDesktop,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              SizedBox(height: isDesktop ? 40 : 32),
              _buildSubmitButton(theme, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required bool isDesktop,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF5B9BD5),
              fontWeight: FontWeight.w600,
              fontSize: isDesktop ? 15 : 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B9BD5).withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: isDesktop ? 16 : 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF5B9BD5),
                size: isDesktop ? 24 : 22,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: isDesktop ? 20 : 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme, bool isDesktop) {
    return Container(
      height: isDesktop ? 64 : 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5B9BD5),
            Color(0xFF4A8BC2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: isDesktop ? 24 : 22,
                  ),
                  SizedBox(width: isDesktop ? 12 : 10),
                  Text(
                    'Submit Inquiry',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF5B9BD5),
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Inquiry Submitted!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for your interest. Our team will contact you within 24 hours.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B9BD5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
