import 'package:flutter/material.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/utils/util_icons/custom_icons.dart';
import 'package:trufi_core/models/menu/social_media/social_media_item.dart';

class InstagramSocialMedia extends SocialMediaItem {
  InstagramSocialMedia(String url)
      : super(
          url: url,
          buildIcon: (context) => const Icon(CustomIcons.instagram,color: Colors.grey,),
          name: (BuildContext context) {
            final localization = TrufiLocalization.of(context);
            return localization.followOnInstagram;
          },
        );
}
