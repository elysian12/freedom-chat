import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freedom_chat/models/message_model.dart';

class ImageMessage extends StatelessWidget {
  final ChatMessage? message;
  const ImageMessage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: message!.text,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
        child: AspectRatio(
          aspectRatio: 1.6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: message!.text,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
