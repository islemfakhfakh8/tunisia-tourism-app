
import 'package:flutter/material.dart';
import '../models/review.dart';

class ReviewForm extends StatefulWidget {
  final Function(Review) onSubmit;

  const ReviewForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController authorController =
      TextEditingController();

  final TextEditingController commentController =
      TextEditingController();

  int rating = 5;

  @override
  void dispose() {
    authorController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void submitReview() {
    if (authorController.text.trim().isEmpty ||
        commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
        ),
      );
      return;
    }

    Review review = Review(
      author: authorController.text.trim(),
      rating: rating,
      comment: commentController.text.trim(),
      date: DateTime.now(),
    );

    widget.onSubmit(review);

    authorController.clear();
    commentController.clear();

    setState(() {
      rating = 5;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre avis a été ajouté avec succès !'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donner votre avis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            // NOM DU CLIENT
            const Text(
              'Votre nom',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: authorController,
              decoration: InputDecoration(
                hintText: 'Entrez votre nom',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // NOTE
            const Text(
              'Votre note',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 32,
                  ),
                );
              }),
            ),

            Text('Note : $rating / 5'),

            const SizedBox(height: 16),

            // COMMENTAIRE
            const Text(
              'Votre commentaire',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Partagez votre expérience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOUTON ENVOYER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitReview,
                icon: const Icon(Icons.send),
                label: const Text('Publier mon avis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE85D4A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
