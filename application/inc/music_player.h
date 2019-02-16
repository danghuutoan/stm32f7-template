#ifndef __MUSIC_PLAYER_H
#define __MUSIC_PLAYER_H

void music_player_init(void);
void music_player_song_select(char *filename);
void music_player_play(void);
void music_player_process(void);
#endif /* __MUSIC_PLAYER_H */