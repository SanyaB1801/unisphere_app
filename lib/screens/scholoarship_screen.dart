import 'package:flutter/material.dart';

class ScholarshipScreen extends StatelessWidget {
  final List<Map<String, dynamic>> scholarships = [
    {
      'title': 'Vidya Samarth Scholarship',
      'provider': 'Ministry of Education, India',
      'eligibility': 'UG students with family income below ₹2.5 LPA',
      'amount': '₹25,000 per year',
      'deadline': '30th June 2025',
      'renewable': 'Yes, based on annual academic performance',
      'link': 'vidya-samarth.gov.in',
    },
    {
      'title': 'Inspire Talent Grant',
      'provider': 'Inspire Foundation',
      'eligibility': 'Top 5% scorers in 12th Science Stream',
      'amount': '₹50,000 one-time',
      'deadline': '15th May 2025',
      'renewable': 'No',
      'link': 'inspire.org/apply',
    },
  ];

  final List<String> filters = [
    'Annual Family Income',
    'Amount',
    'Provider',
    'Deadline',
    'Stream / Course',
    'Female Quota',
  ];

  final Map<String, List<String>> filterOptions = {
    'Provider': ['Govt', 'Pvt', 'NGO'],
    'Amount': ['< ₹50,000', '₹50,000 - ₹1 Lakh', '> ₹1 Lakh'],
    'Deadline': ['Before June 2025', 'After June 2025'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarships'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the home page
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scholarships',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF0E5FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Find Scholarships...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filters.map((filter) {
                        return _buildDropdownChip(filter, context);
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Scholarship Cards
              Expanded(
                child: ListView.builder(
                  itemCount: scholarships.length,
                  itemBuilder: (context, index) {
                    final scholarship = scholarships[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.pink.shade100),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scholarship['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            infoText('Provider', scholarship['provider']),
                            infoText('Eligibility', scholarship['eligibility']),
                            infoText('Amount', scholarship['amount']),
                            infoText('Deadline', scholarship['deadline']),
                            infoText('Renewable', scholarship['renewable']),
                            infoText('Application Link', scholarship['link'],
                                isLink: true),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownChip(String filter, BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (selectedValue) {
        // Handle the selected filter option here
        print('Selected $filter: $selectedValue');
      },
      itemBuilder: (BuildContext context) {
        // Show dropdown options for specific filters
        return filterOptions.containsKey(filter)
            ? filterOptions[filter]!.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList()
            : [];
      },
      child: FilterChip(
        label: Text(filter),
        onSelected: (_) {},
        selectedColor: Colors.blue.shade200,
      ),
    );
  }

  Widget infoText(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                    style: isLink
                        ? TextStyle(color: Colors.blue, decoration: TextDecoration.underline)
                        : TextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
