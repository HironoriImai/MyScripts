#!/usr/bin/env php
<?php
$skip = [0, 0];
if(isset($argv[1])) $skip[0] = (int)$argv[1];
if(isset($argv[2])) $skip[1] = (int)$argv[2];

foreach(glob("*.pdf") as $filename){
    echo "---------- $filename ----------".PHP_EOL;

    $result = null;
    $width = [];
    $height = [];

    exec("gm identify '$filename'", $result);
    if($skip[1] > 0) $result = array_splice($result, $skip[0], -$skip[1]);
    else             $result = array_splice($result, $skip[0]);
    $page = count($result);
    foreach($result as $row){
        if(preg_match("/$filename\[\d+?\] PDF (\d+?)x(\d+?)\+/", $row, $m)){
            $width[] = $m[1];
            $height[] = $m[2];
        }
    }
    if(count($width)!==$page || count($height)!==$page){
        echo "array num differ" . PHP_EOL;
        continue;
    }

    // 縦の平均を計算
    $width_avg = array_sum($width)/$page;
    $height_avg = array_sum($height)/$page;

    for($i=0; $i<$page; $i++){
        if(isSizeDiffer($width_avg, $width[$i]) || isSizeDiffer($height_avg, $height[$i])){
            echo "$filename [$i] {$width[$i]} x {$height[$i]} " .
                "(" . (int)(($width[$i]-$width_avg)/$width_avg*100) . "% x " .
                (int)(($height[$i]-$height_avg)/$height_avg*100) . "%)" . PHP_EOL;
        }
    }
}

// 閾値を超えているか確認（mm単位）
function isSizeDiffer($base, $test){
    if($test > $base*1.05) return true;
    if($test < $base*0.95) return true;

    return false;
}
