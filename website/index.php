<?php $tmpl_title = "An Open Source RETS Server";
      $tmpl_header = "Variman: An Open Source RETS Server";
      $tmpl_location = "Home";
      include("header.php");
?>
    <div class="logo">
    </div>

    <div class="body">
    <h3>Introduction</h3>

    <p>
      simpleRETS is a simple command line <a href="http://www.rets.org/">RETS</a> client.
      simpleRETS is s developed under a <a
      href="LICENSE.TXT">BSD-style license</a> at the Center for
      REALTOR(R) Technology.
    </p>

    <p>
      simpleRETS is built with <a href="http://www.ruby-lang.org/">Ruby</a> 
      and uses <a href="../librets/">libRETS</a>.
    </p>

    <h3>Features</h3>

    <ul>
      <li> Simple Setup, one YAML configuration file is all you need.</li>
	  <li> Can be run from a scheduler or a cron job.</li>
	  <li> Output in CSV.  This means you can use the many CSV to database mappers out there to get you data into your database easily.</li>
	  <li> Column headers can be either the RETS System Name or user defined.</li>
	  <li> Delta queries.  SimpleRETS supports date based delta queries.</li>
    </ul>
    <para>
      The current version is <b><?php print_ver()?></b>.
    </para>

    <?php if (beta_ver()) : ?>
    <p>
      The current beta version is <b><?php print_beta_ver() ?></b></a>.
    </p>
    <?php endif; ?>
      
    <h3>News</h3>
    <ul>
      <li> <b>24 July 2009</b>: Version 1.0 released. </li>
    </ul>

    <p>
      View the <a
      href="http://code.crt.realtors.org/projects/simplerets">Trac project
      page</a> to follow development of this project as well as browse the source code.
    </p>
    </div>

<?php include("footer.php"); ?>
