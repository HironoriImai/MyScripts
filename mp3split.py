# encoding: utf-8

# 1つのmp3を複数のmp3に分割し，csvの情報を元にID3タグを付ける
# 詳細：https://kougen.iobb.net/hobbygardens/article.php?id=98

import sys
import csv
import os
from pydub import AudioSegment
from mutagen.easyid3 import EasyID3

# 引数の処理
args = sys.argv
if len(args)<3:
	exit('usage: python3 mp3split.py <mp3 file> <csv file> [<bitrate>]')

filename_input = args[1]
song_info_csv = args[2]
bitrate = args[3] if len(args)==4 else None

# mp3の読み込み
print('mp3の読み込み')
sound_master = AudioSegment.from_file(filename_input, format='mp3')

# 時間
time_since = 0
# CSVを読み込みながら曲を分割
with open(song_info_csv, 'r', encoding='utf-8-sig') as f:
	reader = csv.reader(f)
	# タイトル行は別に保存
	header = next(reader)
	id3_num = len(header)
	for row in reader:
		# 行（タグ）の読み込み
		tags = {}
		for i in range(id3_num):
			tags[header[i]] = row[i]

		# 時間をミリ秒に直す
		hours, minutes, seconds = tags['time'].split(':')
		time = (int(hours)*60*60 + int(minutes)*60 + int(seconds)) * 1000
		del tags['time']

		# 出力先ファイル名の作成
		directory = os.path.dirname(filename_input);
		if directory=='':
			directory = '.'
		filename_output = directory + '/' + tags['title'] + '.mp3'
		print(filename_output);
		
		# 時間で分割
		time_until = time_since + time
		sound = sound_master[time_since: time_until]
		time_since = time_until
		# 出力
		sound.export(filename_output, format='mp3', bitrate=bitrate)
		
		# ID3タグの編集
		id3tag = EasyID3(filename_output)
		for key,value in tags.items():
			id3tag[key] = value
		id3tag.save()
