import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hub_finder/pages/repo/repo_controller.dart';
import 'package:hub_finder/pages/user/user_page.dart';
import 'package:hub_finder/shared/core/app_colors.dart';
import 'package:hub_finder/shared/models/load_state.dart';
import 'package:hub_finder/shared/widgets/header_widget.dart';
import 'package:hub_finder/shared/widgets/info_widget.dart';
import 'package:hub_finder/shared/widgets/language_badge_widget.dart';
import 'package:hub_finder/shared/widgets/listtile_widget.dart';

class RepoPage extends StatelessWidget {
  final String? fullName;

  RepoPage(this.fullName);

  @override
  Widget build(BuildContext context) {
    final controller = RepoController(fullName);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('asset/images/logo_light.png', height: 32),
        centerTitle: true,
        elevation: 0,
      ),
      body: Observer(
        builder: (context) {
          switch (controller.load) {
            case LoadState.loaded:
              return Body(controller);

            case LoadState.loading:
              return Center(child: CircularProgressIndicator());

            case LoadState.error:
              return Center(child: Text('Ocurr an error'));

            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  final RepoController controller;

  Body(this.controller);

  Widget _getSubtitle() {
    if (controller.repository.description != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            controller.repository.description!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(24, 48, 24, 0),
            children: [
              HeaderWidget(
                imageUrl: controller.contributors[0].avatarUrl,
                title: controller.repository.name,
                subtitle: controller.contributors[0].login,
              ),
              _getSubtitle(),
              SizedBox(height: 16),
              LanguageBadgeWidget(
                color: language_colors[controller.repository.language],
                title: controller.repository.language,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  InfoWidget(
                    title: controller.repository.stars.toString(),
                    subtitle: 'Stars',
                  ),
                  SizedBox(width: 34),
                  InfoWidget(
                    title: controller.repository.forks.toString(),
                    subtitle: 'Forks',
                  ),
                  SizedBox(width: 34),
                  InfoWidget(
                    title: controller.repository.openIssues.toString(),
                    subtitle: 'Open Issues',
                  ),
                ],
              ),
              SizedBox(height: 48),
              Text(
                'Contributors',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 24),
              ListView.builder(
                itemCount: controller.contributors.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  final contributor = controller.contributors[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ListTileWidget(
                      imageUrl: contributor.avatarUrl,
                      title: contributor.login,
                      subtitle: '${contributor.contributions} contributions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPage(contributor.login),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Observer(builder: (context) {
          return Container(
            alignment: Alignment.center,
            child: controller.showAd ? controller.adWidget : null,
            width: MediaQuery.of(context).size.width,
            height: 50,
          );
        }),
      ],
    );
  }
}
