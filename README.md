# proboci assets
This repository is used to store Probo CI assets, excluding passwords and access tokens. An advantage of storing ProboCI related templates and files in a separate repository from the .probo.yaml file is that we can update these assets across all repositories with a .probo.yaml file.

We should discuss on Friday whether we want to put more of the .probo.yaml content in this repository.  In other words, the file we add to each repository simply clones this repository and echoes a .probo.yaml file.  The advantage of this strategy would be that we could make improvements to the script, in one place, instead of across multiple repositories.

The contents of this repository are:
**.htaccess:** This is a copy of Drupal's 7.50 .htaccess file with RewriteBase / uncommented.

**.my.cnf:** This dramatically increases the capcity of MySQL.  The default settings used by Probo CI repeatedly failed to complete a product build.

**aliases.drushrc.php:** This may used by Behat.

**behat.local.yml:** 
This is used by Behat.

**configure.json:** This was used by Geppetto, but may be removed if we decide not to test Geppetto further.

**visual-monitor/:** These files are used by Shoov to run visual regression testing.  While I removed visual regression testing from the .probo.yaml file in use, these files are here for when we move forward with adding Shoov to our Probo CI tests.
