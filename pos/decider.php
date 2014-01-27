<?php

$link = mysqli_connect("localhost","root","root","pos") or die("Error " . mysqli_error($link));

// process request
if (isset($_GET['id']) && isset($_GET['status'])) {
    $query = "update Words set status = '" . $_GET['status'] . "' where id = '" . $_GET['id'] . "'";
    $result = $link->query($query);
}

// get counts

$query = "select count(*) as count from Words where status = 'not_reviewed' and classification = 'noun'";
$result = $link->query($query);

foreach ($result as $r) {
    $not_reviewed_nouns_count = $r['count'];
}

$query = "select count(*) as count from Words where status = 'not_reviewed' and classification = 'adjective'";
$result = $link->query($query);

foreach ($result as $r) {
    $not_reviewed_adjectives_count = $r['count'];
}

$query = "select count(*) as count from Words where status = 'approved'";
$result = $link->query($query);

foreach ($result as $r) {
    $approved_count = $r['count'];
}

$query = "select count(*) as count from Words where status = 'denied'";
$result = $link->query($query);

foreach ($result as $r) {
    $denied_count = $r['count'];
}

// get the next word to review
$classification = (rand(0,1) === 0) ? 'noun' : 'adjective';
$offset = ($classification == 'noun') ? rand(0, (int) $not_reviewed_nouns_count) : rand(0, (int) $not_reviewed_adjectives_count);
$query = "select * from Words where status = 'not_reviewed' and classification = '" . $classification . "' limit " .$offset . ",1";
$result = $link->query($query);

foreach ($result as $r) {
    $next = $r;
}

?>
<table>
    <tr>
        <td><?php echo ((int) $not_reviewed_nouns_count) + ((int) $not_reviewed_adjectives_count); ?></td>
        <td>Not Reviewed</td>
    </tr>
    <tr>
        <td><?php echo $approved_count; ?></td>
        <td>Approved</td>
    </tr>
    <tr>
        <td><?php echo $denied_count; ?></td>
        <td>Denied</td>
    </tr>
</table>

<h1><?php echo htmlentities($next['classification']); ?>: <?php echo htmlentities($next['value']); ?></h1>
<h2><a href="?id=<?php echo $next['id']; ?>&status=approved">Approve</a> | <a href="?id=<?php echo $next['id']; ?>&status=denied">Deny</a></h2>