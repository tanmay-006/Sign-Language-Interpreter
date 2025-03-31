import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(LessonsApp());
}

class LessonsApp extends StatefulWidget {
  const LessonsApp({super.key});

  @override
  _LessonsAppState createState() => _LessonsAppState();
}

class _LessonsAppState extends State<LessonsApp> {
  List<Map<String, String>> downloadedVideos = [];

  void addDownloadedVideo(Map<String, String> video) {
    setState(() {
      downloadedVideos.add(video);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonsPage(
        downloadedVideos: downloadedVideos,
        addDownloadedVideo: addDownloadedVideo,
      ),
      routes: {
        '/downloads': (context) => DownloadsPage(downloadedVideos: downloadedVideos),
      },
    );
  }
}

class LessonsPage extends StatefulWidget {
  final List<Map<String, String>> downloadedVideos;
  final Function(Map<String, String>) addDownloadedVideo;

  const LessonsPage({super.key, required this.downloadedVideos, required this.addDownloadedVideo});

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  // Dummy list of videos
  final List<Map<String, String>> videos = [
    {
      'title': 'Happy Birthday in BSL',
      'thumbnail': 'https://images.pond5.com/british-sign-language-z-looping-footage-038443032_iconl.jpeg',
      'url': 'https://videos.pond5.com/happy-birthday-british-sign-language-footage-038442903_main_xxl.mp4',
    },
    {
      'title': 'A to Z Alphabets in ASL',
      'thumbnail': 'https://images.pond5.com/asl-american-sign-language-alphabet-footage-043046786_iconl.jpeg',
      'url': 'https://videos.pond5.com/asl-american-sign-language-alphabet-footage-043046786_main_xxl.mp4',
    },
    {
      'title': 'Ask for Water in ASL',
      'thumbnail': 'https://images.pond5.com/british-sign-language-z-looping-footage-038443032_iconl.jpeg',
      'url': 'https://videos.pond5.com/how-say-water-sign-language-footage-225818658_main_xxl.mp4',
    },
    {
      'title': 'Saying Good Morning in ASL',
      'thumbnail': 'https://images.pond5.com/greeting-good-morning-sign-language-footage-225818665_iconl.jpeg',
      'url': 'https://videos.pond5.com/greeting-good-morning-sign-language-footage-225818665_main_xxl.mp4',
    },
  ];

  // Function to handle video download
  void _downloadVideo(Map<String, String> video) async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      // Proceed with download
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory!.path}/${video['title']}.mp4';

      final taskId = await FlutterDownloader.enqueue(
        url: video['url']!,
        savedDir: directory.path,
        fileName: '${video['title']}.mp4',
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        widget.addDownloadedVideo(video.cast<String, String>()..putIfAbsent('path', () => savePath));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${video['title']} downloaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission denied. Please grant permission in app settings.'),
          duration: Duration(seconds: 2),
        ),
      );
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              Navigator.pushNamed(context, '/downloads');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refreshing the video list
            await Future.delayed(Duration(seconds: 2));
            setState(() {});
          },
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          video['thumbnail']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _downloadVideo(video),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Download'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DownloadsPage extends StatefulWidget {
  final List<Map<String, String>> downloadedVideos;

  const DownloadsPage({super.key, required this.downloadedVideos});

  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  VideoPlayerController? _controller;

  void _playVideo(String path) {
    print("Attempting to play video from path: $path"); // Debug print
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {}); // Ensure the video player is visible
        _controller!.play();
        print("Video initialized and playing."); // Debug print
      }).catchError((error) {
        print("Error initializing video player: $error"); // Debug print
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: widget.downloadedVideos.isEmpty
            ? Center(
          child: Text(
            'No videos downloaded yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: widget.downloadedVideos.length,
          itemBuilder: (context, index) {
            final video = widget.downloadedVideos[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    video['thumbnail']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  video['title']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  if (video.containsKey('path')) {
                    _playVideo(video['path']!);
                  } else {
                    print("Video path not found for: ${video['title']}"); // Debug print
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: _controller != null && _controller!.value.isInitialized
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
      bottomSheet: _controller != null && _controller!.value.isInitialized
          ? SizedBox(
        height: 200,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      )
          : null,
    );
  }
}