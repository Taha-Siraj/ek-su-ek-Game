import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../services/audio_manager.dart';
import '../widgets/player_profile_card_dialog.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showUserProfile(BuildContext context, String targetUid, AudioManager audio) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
        ),
      ),
    );

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(targetUid).get();
      // Dismiss loading indicator
      Navigator.of(context).pop();

      if (doc.exists) {
        final data = doc.data()!;
        if (!context.mounted) return;

        showDialog(
          context: context,
          builder: (context) => PlayerProfileCardDialog(
            targetUid: targetUid,
            playerName: data['playerName'] ?? "Player",
            avatarUrl: data['avatarUrl'],
            avatarCode: data['avatarCode'] ?? Icons.face_retouching_natural.codePoint,
            xp: data['xp'] ?? 0,
            totalGames: data['totalGames'] ?? 0,
            totalWins: data['totalWins'] ?? 0,
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: MidnightNeonTheme.danger,
            content: Text("User profile not found"),
          ),
        );
      }
    } catch (e) {
      // Dismiss loading indicator if not already done
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MidnightNeonTheme.danger,
            content: Text("Error fetching profile: $e"),
          ),
        );
      }
    }
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query.trim();
    });

    try {
      // Query users where playerName starts with query
      // Standard Firestore prefix query
      final results = await FirebaseFirestore.instance
          .collection('users')
          .where('playerName', isGreaterThanOrEqualTo: _searchQuery)
          .where('playerName', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
          .limit(20)
          .get();

      final currentUid = FirebaseAuth.instance.currentUser?.uid;

      setState(() {
        // Filter out current user from search results
        _searchResults = results.docs.where((doc) => doc.id != currentUid).toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MidnightNeonTheme.danger,
            content: Text("Search error: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MidnightNeonTheme.bgSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MidnightNeonTheme.primaryContainer),
          onPressed: () {
            audio.playClick();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "SOCIAL NETWORK",
          style: MidnightNeonTheme.headlineMd.copyWith(
            fontSize: 20,
            color: MidnightNeonTheme.primaryContainer,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MidnightNeonTheme.primaryContainer,
          labelColor: MidnightNeonTheme.primaryContainer,
          unselectedLabelColor: MidnightNeonTheme.textSecondary,
          labelStyle: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "FRIENDS", icon: Icon(Icons.people)),
            Tab(text: "REQUESTS", icon: Icon(Icons.mark_email_unread)),
            Tab(text: "ADD FRIEND", icon: Icon(Icons.person_add_alt_1)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsTab(audio),
                _buildRequestsTab(audio),
                _buildAddFriendTab(audio),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(AudioManager audio) {
    return StreamBuilder<QuerySnapshot>(
      stream: audio.streamFriends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
            ),
          );
        }

        final friendsDocs = snapshot.data?.docs ?? [];

        if (friendsDocs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: MidnightNeonTheme.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "NO FRIENDS YET",
                    style: MidnightNeonTheme.headlineMd.copyWith(
                      fontSize: 18,
                      color: MidnightNeonTheme.textSecondary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Search for other players in the 'ADD FRIEND' tab or tap a player on the leaderboard to send them a request!",
                    textAlign: TextAlign.center,
                    style: MidnightNeonTheme.bodyMd.copyWith(
                      fontSize: 13,
                      color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
          itemCount: friendsDocs.length,
          itemBuilder: (context, index) {
            final friend = friendsDocs[index].data() as Map<String, dynamic>;
            final String targetUid = friend['uid'] ?? '';
            final String name = friend['playerName'] ?? 'Player';
            final String? avatarUrl = friend['avatarUrl'];
            final int avatarCode = friend['avatarCode'] ?? Icons.face_retouching_natural.codePoint;
            final IconData avatarIcon = IconData(avatarCode, fontFamily: 'MaterialIcons');

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: MidnightNeonTheme.primaryContainer.withOpacity(0.1),
                          radius: 22,
                          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                          child: avatarUrl == null
                              ? Icon(avatarIcon, color: MidnightNeonTheme.primaryContainer, size: 22)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "FRIEND",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 9,
                                color: MidnightNeonTheme.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        audio.playClick();
                        audio.triggerHaptic();
                        _showUserProfile(context, targetUid, audio);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MidnightNeonTheme.primaryContainer,
                        foregroundColor: MidnightNeonTheme.bgPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusSmall),
                        ),
                      ),
                      child: Text(
                        "DOSSIER",
                        style: MidnightNeonTheme.labelCaps.copyWith(
                          fontSize: 9,
                          color: MidnightNeonTheme.bgPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestsTab(AudioManager audio) {
    return StreamBuilder<QuerySnapshot>(
      stream: audio.streamPendingRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
            ),
          );
        }

        final requestDocs = snapshot.data?.docs ?? [];

        if (requestDocs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 64,
                    color: MidnightNeonTheme.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "NO PENDING REQUESTS",
                    style: MidnightNeonTheme.headlineMd.copyWith(
                      fontSize: 18,
                      color: MidnightNeonTheme.textSecondary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Any inbound friend requests will appear here. Stay connected!",
                    textAlign: TextAlign.center,
                    style: MidnightNeonTheme.bodyMd.copyWith(
                      fontSize: 13,
                      color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
          itemCount: requestDocs.length,
          itemBuilder: (context, index) {
            final request = requestDocs[index].data() as Map<String, dynamic>;
            final String targetUid = request['uid'] ?? '';
            final String name = request['playerName'] ?? 'Player';
            final String? avatarUrl = request['avatarUrl'];
            final int avatarCode = request['avatarCode'] ?? Icons.face_retouching_natural.codePoint;
            final IconData avatarIcon = IconData(avatarCode, fontFamily: 'MaterialIcons');

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        audio.playClick();
                        audio.triggerHaptic();
                        _showUserProfile(context, targetUid, audio);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: MidnightNeonTheme.primaryContainer.withOpacity(0.1),
                            radius: 22,
                            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                            child: avatarUrl == null
                                ? Icon(avatarIcon, color: MidnightNeonTheme.primaryContainer, size: 22)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "INCOMING REQUEST",
                                  style: MidnightNeonTheme.labelCaps.copyWith(
                                    fontSize: 9,
                                    color: MidnightNeonTheme.primaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: MidnightNeonTheme.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              audio.playClick();
                              audio.triggerHaptic();
                              await audio.acceptFriendRequest(
                                targetUid: targetUid,
                                targetName: name,
                                targetAvatarUrl: avatarUrl,
                                targetAvatarCode: avatarCode,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MidnightNeonTheme.primaryContainer,
                              minimumSize: const Size(0, 36),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusSmall)),
                            ),
                            child: Text(
                              "ACCEPT",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                color: MidnightNeonTheme.bgPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              audio.playClick();
                              audio.triggerHaptic();
                              await audio.declineFriendRequest(targetUid);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: MidnightNeonTheme.danger),
                              minimumSize: const Size(0, 36),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusSmall)),
                            ),
                            child: Text(
                              "DECLINE",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                color: MidnightNeonTheme.danger,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddFriendTab(AudioManager audio) {
    return Padding(
      padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: MidnightNeonTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
              border: Border.all(color: MidnightNeonTheme.borderGlass),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintText: "SEARCH PLAYERS BY NAME...",
                hintStyle: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.textSecondary.withOpacity(0.4),
                  fontSize: 12,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: MidnightNeonTheme.primaryContainer),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: MidnightNeonTheme.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch("");
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Search Results
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
                    ),
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? "ENTER A NAME TO BEGIN SEARCH"
                              : "NO MATCHING PLAYERS FOUND",
                          style: MidnightNeonTheme.labelCaps.copyWith(
                            color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final userDoc = _searchResults[index];
                          final data = userDoc.data() as Map<String, dynamic>;
                          final String targetUid = userDoc.id;
                          final String name = data['playerName'] ?? 'Player';
                          final String? avatarUrl = data['avatarUrl'];
                          final int avatarCode = data['avatarCode'] ?? Icons.face_retouching_natural.codePoint;
                          final IconData avatarIcon = IconData(avatarCode, fontFamily: 'MaterialIcons');

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      audio.playClick();
                                      audio.triggerHaptic();
                                      _showUserProfile(context, targetUid, audio);
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MidnightNeonTheme.primaryContainer.withOpacity(0.1),
                                          radius: 22,
                                          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                                          child: avatarUrl == null
                                              ? Icon(avatarIcon, color: MidnightNeonTheme.primaryContainer, size: 22)
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "LEVEL ${1 + ((data['xp'] ?? 0) ~/ 8000)}",
                                              style: MidnightNeonTheme.labelCaps.copyWith(
                                                fontSize: 9,
                                                color: MidnightNeonTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      audio.playClick();
                                      audio.triggerHaptic();
                                      _showUserProfile(context, targetUid, audio);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MidnightNeonTheme.primaryContainer,
                                      foregroundColor: MidnightNeonTheme.bgPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusSmall),
                                      ),
                                    ),
                                    child: Text(
                                      "VIEW PROFILE",
                                      style: MidnightNeonTheme.labelCaps.copyWith(
                                        fontSize: 9,
                                        color: MidnightNeonTheme.bgPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
