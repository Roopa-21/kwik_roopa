import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_event.dart';
import 'package:kwik/bloc/Auth_bloc/auth_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/kiwi_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  const OtpVerificationPage({super.key, required this.verificationId});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go("/home");
        } else if (state is AuthFailureState) {
          _focusNode.unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/image2.jpeg',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: deviceheight * 0.55,
                ),
                SizedBox(height: deviceheight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: devicewidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OTP Verification",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: deviceheight * 0.03),
                        child: Text(
                          'OTP has been sent on mobile number\nPlease enter OTP to verify the number',
                          style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColors.textColorGrey,
                              fontWeight: FontWeight.w400,
                              height: devicewidth * 0.0035,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: deviceheight * 0.03),
                        child: PinCodeTextField(
                          cursorColor: AppColors.kgreyColorlite,
                          autoDisposeControllers: false,
                          appContext: context,
                          length: 6,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          enableActiveFill: false,
                          autoFocus: true,
                          enablePinAutofill: false,
                          errorTextSpace: 16,
                          showCursor: true,
                          obscureText: false,
                          hintCharacter: '●',
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 45,
                              borderWidth: 0.5,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              shape: PinCodeFieldShape.box,
                              activeColor: AppColors.buttonColorOrange,
                              inactiveColor: AppColors.kgreyColorlite,
                              selectedColor: AppColors.buttonColorOrange),
                          controller: _otpController,
                          onChanged: (_) {},
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      KiwiButton(
                        text: 'Verify & Login',
                        onPressed: () {
                          String otpCode = _otpController.text.trim();
                          if (otpCode.isEmpty || otpCode.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid OTP code'),
                              ),
                            );
                            return;
                          }

                          if (state is! AuthLoading) {
                            BlocProvider.of<AuthBloc>(context).add(
                              VerifySentOtp(
                                otpCode: otpCode,
                                verificationId: widget.verificationId,
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
