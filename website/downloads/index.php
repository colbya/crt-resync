<?php $tmpl_title = "Downloads";
      $tmpl_location = "Downloads";
      include("../header.php");

function dl_file($file)
{
    $url = $GLOBALS["ROOT"] . "/files/" . $file;
    echo "<a href=\"$url\">$file</a>";
}

function human_file_size($file, $decimals = 2)
{
   $filename = "../files/" . $file;
   $size = filesize($filename);
   $filesizename = array("Bytes", "KB", "MB", "GB", "TB", "PB", "EB",
                         "ZB", "YB");
   return round(
       $size/pow(1024, ($i = floor(log($size, 1024)))), $decimals) .
                 $filesizename[$i];
}

?>
    <h3>Downloads</h3>

    <p>
      The current version is <b><?= ver() ?></b>.
    </p>

    <table width="100%" border="1" cellspacing="0" cellpadding="5">
      <tr>
        <td class="dl-header">File&nbsp;Name</td>
        <td class="dl-header">File&nbsp;Size</td>
        <td class="dl-header">Description</td>
      </tr>
      <tr>
        <td class="dl-group" colspan="3">Binary Downloads</td>
      </tr>
      <tr>
        <td width="25%">
          <?php dl_file("simplerets-win32-" . ver() . ".zip")?>
        </td>
        <td><?= human_file_size("simplerets-win32-" . ver() . ".zip", 1) ?></td>
        <td>
          Windows binary in a zip archive.
        </td>
      </tr>
	  <tr>
        <td width="25%">
          <?php dl_file("simplerets-darwin-" . ver() . ".zip")?>
        </td>
        <td><?= human_file_size("simplerets-darwin-" . ver() . ".zip", 1) ?></td>
        <td>
          OSX (darwin) binary in a zip archive.
        </td>
      </tr>
      <tr>
        <td width="25%">
          <?php dl_file("simplerets-linux-" . ver() . ".tar.gz")?>
        </td>
        <td><?= human_file_size("simplerets-linux-" . ver() . ".tar.gz", 1) ?></td>
        <td>
          Linux binary in a tar+gzipped archive.
        </td>
      </tr>
      <tr>
        <td class="dl-group" colspan="3">Source Downloads</td>
      </tr>
      <tr>
        <td>
          <?php dl_file("simplerets-src-" . ver() . ".tar.gz")?>
        </td>
        <td><?= human_file_size("simplerets-src-" . ver() . ".tar.gz") ?></td>
        <td>Source archive, tar+gzipped</td>
      </tr>
      <tr>
        <td>
          <?php dl_file("simplerets-src-" . ver() . ".zip")?>
        </td>
        <td><?= human_file_size("simplerets-src-" . ver() . ".zip") ?></td>
        <td>Source archive, zipped</td>
      </tr>
    </table>

    <?php if (beta_ver()) : ?>
    <p>
      The current beta version is <b><?= beta_ver() ?></b>.
    </p>

    <table width="100%" border="1" cellspacing="0" cellpadding="5">
      <tr>
        <td class="dl-header">File&nbsp;Name</td>
        <td class="dl-header">File&nbsp;Size</td>
        <td class="dl-header">Description</td>
      </tr>
      <tr>
        <td class="dl-group" colspan="3">Binary Downloads</td>
      </tr>
      <tr>
        <td width="25%">
          <?php dl_file("librets-win32-" . beta_ver() . ".zip")?>
        </td>
        <td>26M</td>
        <td>
          Windows binary in a zip file. Includes headers, libraries, and a API
          documentation.
        </td>
      </tr>
      <tr>
        <td class="dl-group" colspan="3">Source Downloads</td>
      </tr>
      <tr>
        <td>
          <?php dl_file("librets-" . beta_ver() . ".tar.gz")?>
        </td>
        <td>972K</td>
        <td>Source archive, tar+gzipped</td>
      </tr>
      <tr>
        <td>
          <?php dl_file("librets-" . beta_ver() . ".zip")?>
        </td>
        <td>1.6M</td>
        <td>Source archive, zipped</td>
      </tr>
    </table>
    <?php endif; ?>

    <p>
      All versions may be downloaded from <a href="<?php
      ROOT()?>/files/">this directory</a>.
    </p>

    <?php include("../footer.php"); ?>
