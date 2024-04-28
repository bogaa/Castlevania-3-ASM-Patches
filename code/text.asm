
textmap 1...9 41		; TextMapMainGame
textmap A...Z 50
textmap a...z e0
textmap space 00

textmap .,!?-' dbdcfafbfcda			;' ;textmap .=-"'?!, 4b4c4d4e4f6a6b78		; "  	

bank $1e                                                    
base $c000                                                      			  
org $D929							; 3d929
	introText:
	db $00,$80,$00,$80,$06
	
	db "During 15th Century",$00,$80
	db "Europe, there lived",$00,$80
	db "a person named  Dracula.",$00,$80
	db "He practiced sorcery",$00,$80
	db "in order to create",$00,$80
	db "a bad world filled",$00,$80
	db "with evil.",$80,$81
	
	db $00,$80,$00,$80,$06
	
	db "He began taking over",$00,$80
	db "the Continent of",$00,$80
	db "Europe, changing",$00,$80
	db "countries from good",$00,$80
	db "to bad.",$00,$80
	db "The good people of",$00,$80
	db "Europe tried to",$00,$80
	db "fight off Dracula,",$00,$80
	db "but no one was able",$00,$80
	db "to survive.",$80,$81
	
	db $00,$80,$00,$80,$06
	
	db "Finally, the Belmont",$00,$80
	db "family was summoned",$00,$80
	db "to battle Dracula's",$00,$80
	db "vile forces.",$00,$80
	db "The Belmont",$00,$80
	db "family has",$00,$80
	db "a long  history of",$00,$80
	db "fighting",$00,$80
	db "evil.",$80,$81
	
	db $00,$80,$00,$80,$06
	
	db "The townspeople be-",$00,$80
	db "came afraid of the",$00,$80
	db "Belmonts super-human",$00,$80
	db "power and asked them",$00,$80
	db "to leave the country.",$00,$80
	db "Fortunately",$00,$80  
	db "the people",$00,$80
	db "found a",$00,$80
	db "mighty",$00,$80
	db "Belmont, ca-",$00,$80
	db "lled Trevor.",$80,$81
	
	db $00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$06
	
	db "The curse of",$00,$80
	db "Dracula has begun.",$00,$80
	db "The fate of Europe",$00,$80
	db "lies with Trevor.",$00,$80

bank $15                                                      
base $a000
org  $bac0                                                      			  
	endingTEXT:
	;"Trevor.made.many.sacrifices..
	;The.long.fight.is.over..
	;Dracula.is.dead.and.all.other.spirits.are.asleep....
	;After.this.fight.the.Belmont.name.shall.be.honored.by.all.people..
	;In.the.shadows,.a.person.watches.the.castle.fall....
	;Trevor.must.go.for.now.but.he.hopes.someday.he.will.get.the.respect.that.he.deserves....
	;Syfa,.the.Vampire.Killer.has.had.a.bad.life,.but.since.she.met.Trevor.she.is.beginning.to.feel.more.comfortable.with.herself....
	;Both.feel.their.friendship.is.stronger.since.they.worked.together.to.rid.Wallachia.city.of.evil..
	;Grant.will.start.to.rebuild.the.destroyed.areas.of.the.city....
	;The.battle.was.won.by.Trevor.and.Alucard.but.Alucard.feels.quilty.because.he.killed.his.real.father....
	;Trevor.realizes.this.as.he.stands.there.thinking.about.Alucard...
	;............................................................"
	
	
bank $02
base $8000
org $8A26	
;	           textGroups: dw textPointersGrant_00              ;018A26|        |018A42;
;                       dw textPointersGrant_01              ;018A28|        |018A4A;
;                       dw textPointert_02                   ;018A2A|        |018A52;
;                       dw textPointert_03                   ;018A2C|        |018A5A;
;                       dw textPointert_04                   ;018A2E|        |018A62;
;                       dw textPointert_05                   ;018A30|        |018A6A;
;                       dw textPointert_06                   ;018A32|        |018A72;
;                       dw textPointert_07                   ;018A34|        |018A7A;
;                       dw textPointert_08                   ;018A36|        |018A82;
;                       dw textPointert_09                   ;018A38|        |018A8A;
;                       dw textPointert_0a                   ;018A3A|        |018A92;
;                       dw textPointert_0b                   ;018A3C|        |018A9A;
;                       dw textPointert_0c                   ;018A3E|        |018AA2;
;                       dw textPointert_0d                   ;018A40|        |018AAA;
;                                                            ;      |        |      ;
; textPointersGrant_00: dw textDataGrant_00                  ;018A42|        |018AB2;
;                       dw textDataGrant_01                  ;018A44|        |018AC4;
;                       dw textDataGrant_02                  ;018A46|        |018AD4;
;                       dw $FFFF                             ;018A48|        |      ;
;                                                            ;      |        |      ;
; textPointersGrant_01: dw DATA8_018AE9                      ;018A4A|        |018AE9;
;                       dw DATA8_018AFD                      ;018A4C|        |018AFD;
;                       dw DATA8_018B11                      ;018A4E|        |018B11;
;                       dw $FFFF                             ;018A50|        |      ;
;                                                            ;      |        |      ;
;      textPointert_02: dw DATA8_018B24                      ;018A52|        |018B24;
;                       dw DATA8_018B36                      ;018A54|        |018B36;
;                       dw DATA8_018B4B                      ;018A56|        |018B4B;
;                       dw $FFFF                             ;018A58|        |      ;
;                                                            ;      |        |      ;
;      textPointert_03: dw DATA8_018B5F                      ;018A5A|        |018B5F;
;                       dw DATA8_018B6E                      ;018A5C|        |018B6E;
;                       dw DATA8_018B7E                      ;018A5E|        |018B7E;
;                       dw $FFFF                             ;018A60|        |      ;
;                                                            ;      |        |      ;
;      textPointert_04: dw DATA8_018B8C                      ;018A62|        |018B8C;
;                       dw DATA8_018B9F                      ;018A64|        |018B9F;
;                       dw DATA8_018BB2                      ;018A66|        |018BB2;
;                       dw $FFFF                             ;018A68|        |      ;
;                                                            ;      |        |      ;
;      textPointert_05: dw DATA8_018BC4                      ;018A6A|        |018BC4;
;                       dw DATA8_018BD4                      ;018A6C|        |018BD4;
;                       dw DATA8_018BE5                      ;018A6E|        |018BE5;
;                       dw $FFFF                             ;018A70|        |      ;
;                                                            ;      |        |      ;
;      textPointert_06: dw DATA8_018BF7                      ;018A72|        |018BF7;
;                       dw textDataSympha_00                 ;018A74|        |018C0A;
;                       dw DATA8_018C1D                      ;018A76|        |018C1D;
;                       dw $FFFF                             ;018A78|        |      ;
;                                                            ;      |        |      ;
;      textPointert_07: dw DATA8_018C2D                      ;018A7A|        |018C2D;
;                       dw DATA8_018C3B                      ;018A7C|        |018C3B;
;                       dw DATA8_018C4B                      ;018A7E|        |018C4B;
;                       dw $FFFF                             ;018A80|        |      ;
;                                                            ;      |        |      ;
;      textPointert_08: dw DATA8_018C54                      ;018A82|        |018C54;
;                       dw DATA8_018C63                      ;018A84|        |018C63;
;                       dw DATA8_018C74                      ;018A86|        |018C74;
;                       dw $FFFF                             ;018A88|        |      ;
;                                                            ;      |        |      ;
;      textPointert_09: dw DATA8_018C82                      ;018A8A|        |018C82;
;                       dw DATA8_018C95                      ;018A8C|        |018C95;
;                       dw DATA8_018CA8                      ;018A8E|        |018CA8;
;                       dw $FFFF                             ;018A90|        |      ;
;                                                            ;      |        |      ;
;      textPointert_0a: dw DATA8_018CB4                      ;018A92|        |018CB4;
;                       dw DATA8_018CC6                      ;018A94|        |018CC6;
;                       dw DATA8_018CDA                      ;018A96|        |018CDA;
;                       dw $FFFF                             ;018A98|        |      ;
;                                                            ;      |        |      ;
;      textPointert_0b: dw DATA8_018CEB                      ;018A9A|        |018CEB;
;                       dw DATA8_018CF9                      ;018A9C|        |018CF9;
;                       dw DATA8_018D09                      ;018A9E|        |018D09;
;                       dw $FFFF                             ;018AA0|        |      ;
;                                                            ;      |        |      ;
;      textPointert_0c: dw DATA8_018D12                      ;018AA2|        |018D12;
;                       dw DATA8_018D23                      ;018AA4|        |018D23;
;                       dw DATA8_018D34                      ;018AA6|        |018D34;
;                       dw $FFFF                             ;018AA8|        |      ;
;                                                            ;      |        |      ;
;      textPointert_0d: dw DATA8_018D49                      ;018AAA|        |018D49;
;                       dw DATA8_018D5C                      ;018AAC|        |018D5C;
;                       dw DATA8_018D6F                      ;018AAE|        |018D6F;
;                       dw $FFFF                             ;018AB0|        |      ;
;                                                            ;      |        |      ;
;     textDataGrant_00: db $CC,$F8,$00,$ED,$E0,$EC,$E4,$00   ;018AB2|        |      ;
;                       db $E8,$F2,$00,$C6,$F1,$E0,$ED,$F3   ;018ABA|        |      ;
;                       db $DB,$FF                           ;018AC2|        |      ;
;                                                            ;      |        |      ;
;     textDataGrant_01: db $C8,$00,$E3,$F1,$E4,$E0,$EC,$E4   ;018AC4|        |      ;
;                       db $E3,$00,$C8,$00,$F6,$E0,$F2,$FF   ;018ACC|        |      ;
;                                                            ;      |        |      ;
;     textDataGrant_02: db $F3,$F4,$F1,$ED,$E4,$E3,$00,$E8   ;018AD4|        |      ;
;                       db $ED,$F3,$EE,$00,$E0,$00,$E6,$E7   ;018ADC|        |      ;
;                       db $EE,$F2,$F3,$DB,$FF               ;018AE4|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018AE9: db $CF,$EB,$E4,$E0,$F2,$E4,$00,$F3   ;018AE9|        |      ;
;                       db $E0,$EA,$E4,$00,$EC,$E4,$00,$F6   ;018AF1|        |      ;
;                       db $E8,$F3,$E7,$FF                   ;018AF9|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018AFD: db $F8,$EE,$F4,$DB,$00,$00,$CC,$F8   ;018AFD|        |      ;
;                       db $00,$E5,$E0,$EC,$E8,$EB,$F8,$00   ;018B05|        |      ;
;                       db $F6,$E0,$F2,$FF                   ;018B0D|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B11: db $EA,$E8,$EB,$EB,$E4,$E3,$00,$E1   ;018B11|        |      ;
;                       db $F8,$00,$C3,$F1,$E0,$E2,$F4,$EB   ;018B19|        |      ;
;                       db $E0,$DB,$FF                       ;018B21|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B24: db $D6,$E7,$E0,$F3,$00,$F6,$E8,$EB   ;018B24|        |      ;
;                       db $EB,$00,$F8,$EE,$F4,$00,$E3,$EE   ;018B2C|        |      ;
;                       db $FB,$FF                           ;018B34|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B36: db $00,$00,$D3,$E0,$EA,$E4,$00,$E7   ;018B36|        |      ;
;                       db $E8,$EC,$00,$F6,$E8,$F3,$E7,$00   ;018B3E|        |      ;
;                       db $F8,$EE,$F4,$FB,$FF               ;018B46|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B4B: db $00,$00,$CB,$E4,$E0,$F5,$E4,$00   ;018B4B|        |      ;
;                       db $E7,$E8,$EC,$00,$E1,$E4,$E7,$E8   ;018B53|        |      ;
;                       db $ED,$E3,$FB,$FF                   ;018B5B|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B5F: db $C8,$00,$E2,$E0,$ED,$00,$E7,$E4   ;018B5F|        |      ;
;                       db $EB,$EF,$00,$F8,$EE,$F4,$FF       ;018B67|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B6E: db $E0,$00                           ;018B6E|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B70: db $EB,$EE,$F3,$00                   ;018B70|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B74: db $E1,$E4,$E2,$E0,$F4,$F2,$E4,$00   ;018B74|        |      ;
;                       db $C8,$FF                           ;018B7C|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B7E: db $E0,$EC,$00,$F5,$E4,$F1,$F8,$00   ;018B7E|        |      ;
;                       db $E5,$E0,$F2,$F3,$DB,$FF           ;018B86|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B8C: db $D3,$E7,$E0,$ED,$EA,$F2,$00,$E5   ;018B8C|        |      ;
;                       db $EE,$F1,$00,$E7,$E4,$EB,$EF,$E8   ;018B94|        |      ;
;                       db $ED,$E6,$FF                       ;018B9C|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018B9F: db $EC,$E4,$DB,$00,$00,$C8,$00,$E7   ;018B9F|        |      ;
;                       db $EE,$EF,$E4,$00,$F6,$E4,$00,$F2   ;018BA7|        |      ;
;                       db $E4,$E4,$FF                       ;018BAF|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018BB2: db $E4,$E0,$E2,$E7,$00,$EE,$F3,$E7   ;018BB2|        |      ;
;                       db $E4,$F1,$00,$E0,$E6,$E0,$E8,$ED   ;018BBA|        |      ;
;                       db $DB,$FF                           ;018BC2|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018BC4: db $CC,$F8,$00,$E9,$EE,$E1,$00,$E8   ;018BC4|        |      ;
;                       db $F2,$00,$E3,$EE,$ED,$E4,$DC,$FF   ;018BCC|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018BD4: db $F2,$EE,$00,$F8,$EE,$F4,$00,$F2   ;018BD4|        |      ;
;                       db $E7,$EE,$F4,$EB,$E3,$00,$E6,$EE   ;018BDC|        |      ;
;                       db $FF                               ;018BE4|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018BE5: db $F6,$E8,$F3,$E7,$00,$E7,$E8,$EC   ;018BE5|        |      ;
;                       db $00,$E5,$EE,$F1,$00,$ED,$EE,$F6   ;018BED|        |      ;
;                       db $DB,$FF                           ;018BF5|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018BF7: db $D3,$E7,$E0,$ED,$EA,$F2,$00,$E5   ;018BF7|        |      ;
;                       db $EE,$F1,$00,$E7,$E4,$EB,$EF,$E8   ;018BFF|        |      ;
;                       db $ED,$E6,$FF                       ;018C07|        |      ;
;                                                            ;      |        |      ;
;    textDataSympha_00: db $EC,$E4,$DB,$00,$00,$C8,$DA,$EC   ;018C0A|        |      ;
;                       db $00,$D2,$F8,$E5,$E0,$DC,$00,$F3   ;018C12|        |      ;
;                       db $E7,$E4,$FF                       ;018C1A|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C1D: db $D5,$E0,$EC,$EF,$E8,$F1,$E4,$00   ;018C1D|        |      ;
;                       db $C7,$F4,$ED,$F3,$E4,$F1,$DB,$FF   ;018C25|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C2D: db $C8,$00,$F6,$E8,$EB,$EB,$00,$E5   ;018C2D|        |      ;
;                       db $EE,$EB,$EB,$EE,$F6,$FF           ;018C35|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C3B: db $F8,$EE,$F4,$00,$E8,$E5,$00,$F8   ;018C3B|        |      ;
;                       db $EE,$F4,$00,$ED,$E4,$E4,$E3,$FF   ;018C43|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C4B: db $EC,$F8,$00,$E7,$E4,$EB,$EF,$DB   ;018C4B|        |      ;
;                       db $FF                               ;018C53|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C54: db $C8,$00,$E7,$EE,$EF,$E4,$00,$E0   ;018C54|        |      ;
;                       db $00,$CC,$E0,$E6,$E8,$E2,$FF       ;018C5C|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C63: db $D2,$EF,$E8,$F1,$E8,$F3,$00,$F6   ;018C63|        |      ;
;                       db $E8,$EB,$EB,$00,$E6,$E8,$F5,$E4   ;018C6B|        |      ;
;                       db $FF                               ;018C73|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C74: db $F4,$F2,$00,$F3,$E7,$E4,$00,$EF   ;018C74|        |      ;
;                       db $EE,$F6,$E4,$F1,$DB,$FF           ;018C7C|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C82: db $CF,$EB,$E4,$E0,$F2,$E4,$00,$E1   ;018C82|        |      ;
;                       db $E4,$00,$E2,$E0,$F1,$E4,$E5,$F4   ;018C8A|        |      ;
;                       db $EB,$DB,$FF                       ;018C92|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018C95: db $C8,$00,$E7,$EE,$EF,$E4,$00,$F8   ;018C95|        |      ;
;                       db $EE,$F4,$00,$F6,$E8,$EB,$EB,$00   ;018C9D|        |      ;
;                       db $E1,$E4,$FF                       ;018CA5|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CA8: db $F5,$E8,$E2,$F3,$EE,$F1,$E8,$EE   ;018CA8|        |      ;
;                       db $F4,$F2,$DB,$FF                   ;018CB0|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CB4: db $C8,$DA,$EC,$00,$F2,$F4,$F1,$EF   ;018CB4|        |      ;
;                       db $F1,$E8,$F2,$E4,$E3,$00,$F8,$EE   ;018CBC|        |      ;
;                       db $F4,$FF                           ;018CC4|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CC6: db $E1,$E4,$E0,$F3,$00,$EC,$E4,$DB   ;018CC6|        |      ;
;                       db $00,$00,$C8,$DA,$F5,$E4,$00,$E1   ;018CCE|        |      ;
;                       db $E4,$E4,$ED,$FF                   ;018CD6|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CDA: db $F6,$E0,$E8,$F3,$E8,$ED,$E6,$00   ;018CDA|        |      ;
;                       db $E5,$EE,$F1,$00,$F8,$EE,$F4,$DB   ;018CE2|        |      ;
;                       db $FF                               ;018CEA|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CEB: db $C8,$00,$ED,$E4,$E4,$E3,$00,$F8   ;018CEB|        |      ;
;                       db $EE,$F4,$00,$F3,$EE,$FF           ;018CF3|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018CF9: db $E7,$E4,$EB,$EF,$00,$EC,$E4,$00   ;018CF9|        |      ;
;                       db $E3,$E4,$F2,$F3,$F1,$EE,$F8,$FF   ;018D01|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D09: db $C3,$F1,$E0,$E2,$F4,$EB,$E0,$DB   ;018D09|        |      ;
;                       db $FF                               ;018D11|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D12: db $C8,$DA,$EC,$00,$E6,$EB,$E0,$E3   ;018D12|        |      ;
;                       db $00,$F3,$EE,$00,$E7,$E4,$E0,$F1   ;018D1A|        |      ;
;                       db $FF                               ;018D22|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D23: db $F3,$E7,$E0,$F3,$DB,$00,$00,$CB   ;018D23|        |      ;
;                       db $E4,$F3,$DA,$F2,$00,$E6,$E4,$F3   ;018D2B|        |      ;
;                       db $FF                               ;018D33|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D34: db $E7,$E8,$EC,$00,$DB,$00,$00,$C8   ;018D34|        |      ;
;                       db $00,$E0,$EC,$00,$C0,$EB,$F4,$E2   ;018D3C|        |      ;
;                       db $E0,$F1,$E3,$DB,$FF               ;018D44|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D49: db $D6,$E4,$EB,$EB,$DC,$00,$C8,$DA   ;018D49|        |      ;
;                       db $EB,$EB,$00,$E7,$E0,$F5,$E4,$00   ;018D51|        |      ;
;                       db $F3,$EE,$FF                       ;018D59|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D5C: db $E5,$E8,$ED,$E3,$00,$F2,$EE,$EC   ;018D5C|        |      ;
;                       db $E4,$EE,$ED,$E4,$00,$E4,$EB,$F2   ;018D64|        |      ;
;                       db $E4,$DB,$FF                       ;018D6C|        |      ;
;                                                            ;      |        |      ;
;         DATA8_018D6F: db $CF,$EB,$E4,$E0,$F2,$E4,$00,$E1   ;018D6F|        |      ;
;                       db $E4,$00,$E2,$E0,$F1,$E4,$E5,$F4   ;018D77|        |      ;
;                       db $EB,$FA,$FF                       ;018D7F|        |      ;