#[ProboCI Assets](https://github.com/SU-SWS/proboci_assets)
##### Version: 1.x

Maintainers: [jbickar](https://github.com/jbickar), [sherakama](https://github.com/sherakama), [kbrownell](https://github.com/kbrownell)

[Changelog.txt](CHANGELOG.txt)

[ProboCI](https://probo.ci) is a testing tool that automatically builds a site and runs through a suite of tests.  Any time someone creates a pull request in GitHub, ProboCI will run through our behat tests for that feature and return whether the code changes pass or fail.  A log of behat test results and persistent copy of the site can also be reviewed for additional details on how and what failed.

ProboCI offers a number of different LAMP and Drupal-specific plugins.  We chose not to use these plugins, and instead keep our .probo.yaml file as minimal as possible, so that we can more easily maintain and update this code across a number of different repositories.

Installation
---

1. To add ProboCI to a repository, first create an account by logging in with GitHub at [probo.ci](https://probo.ci/).
2. Click Activate Repos in the upper right corner of the ProboCI app.
3. Find the name of your repository and click the toggle switch on.
4. Then click View Project.
5. Under Build Assets, upload the machine-user keys required for accessing private repositories.  Do not upload your own keys.
6. Create a proboci-test branch to your repository.
7. Add the .probo.default.yaml file to your repository and rename it .probo.yaml.
8. On the last line, add which product you would like ProboCI to build, ie. stanford, jumpstart, jumpstart-academic, etc.
9. Save and commit this file to your proboci-test branch.
10. In the GitHub GUI, create a pull request to merge proboci-test.  This should trigger a site build in ProboCI.
11. 2-10 minutes later, check back to see whether your tests succeeded.
12. The test results should give you the option to view more details.
13. This will take you back to the ProboCI app, where you can review the build and test logs, as well as find a link to View Site, once complete.

Assets
---

**.htaccess:** This is a copy of Drupal's 7.50 .htaccess file with RewriteBase / uncommented.

**.my.cnf:** The default settings used by Probo CI repeatedly failed to complete a product build, for example the default max_allowed_packet was too low for our purposes.

**.probo.default.yaml:** This is our default template for adding ProboCI to a repository.  Rename the file .probo.yaml and update the last line to specify which product you would like to build.  Stanford is the default profile.

**aliases.drushrc.php:** Behat uses drush aliases to run a number of test.

**behat.local.yml:** Behat uses information stored in behat.local.yml for the site url and drush alias.

**behat.yml:** As wish behat.local.yml, Behat expects this file to be present and contain information about the default site url and drush alias it should use.

Troubleshooting
---

If your build fails, its sometimes worth trying to rebuild the site.  This can be done in the ProboCI app, by viewing a Project and then Build.  Above the log output, you should be able to find a Rebuild link.

Contribution / Collaboration
---

You are welcome to contribute functionality, bug fixes, or documentation to this module. If you would like to suggest a fix or new functionality you may add a new issue to the GitHub issue queue or you may fork this repository and submit a pull request. For more help please see [GitHub's article on fork, branch, and pull requests](https://help.github.com/articles/using-pull-requests)
