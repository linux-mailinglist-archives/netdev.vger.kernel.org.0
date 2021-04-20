Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8F536591B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhDTMlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:41:09 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52809 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhDTMlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:41:08 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13KCeWv95023312, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13KCeWv95023312
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 20:40:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 20:40:31 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 20 Apr
 2021 20:40:30 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <linux-firmware@kernel.org>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH linux-firmware] rtl_nic: add new firmware for RTL8153 and RTL8156 series
Date:   Tue, 20 Apr 2021 20:40:00 +0800
Message-ID: <1394712342-15778-357-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMjAgpFekyCAwNzo1NTowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/20/2021 12:24:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163238 [Apr 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/20/2021 12:25:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/20/2021 12:28:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163238 [Apr 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/20/2021 12:30:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. rtl8153c-1 v1 03/31/21.
2. rtl8156a-2 v1 04/15/21.
3. rtl8156b-2 v1 04/15/21.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |   3 +++
 rtl_nic/rtl8153c-1.fw | Bin 0 -> 816 bytes
 rtl_nic/rtl8156a-2.fw | Bin 0 -> 3816 bytes
 rtl_nic/rtl8156b-2.fw | Bin 0 -> 5448 bytes
 4 files changed, 3 insertions(+)
 create mode 100644 rtl_nic/rtl8153c-1.fw
 create mode 100644 rtl_nic/rtl8156a-2.fw
 create mode 100644 rtl_nic/rtl8156b-2.fw

diff --git a/WHENCE b/WHENCE
index 9699246..e6497c5 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3260,6 +3260,9 @@ File: rtl_nic/rtl8153a-2.fw
 File: rtl_nic/rtl8153a-3.fw
 File: rtl_nic/rtl8153a-4.fw
 File: rtl_nic/rtl8153b-2.fw
+File: rtl_nic/rtl8153c-1.fw
+File: rtl_nic/rtl8156a-2.fw
+File: rtl_nic/rtl8156b-2.fw
 
 Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
diff --git a/rtl_nic/rtl8153c-1.fw b/rtl_nic/rtl8153c-1.fw
new file mode 100644
index 0000000000000000000000000000000000000000..5c3d1c468e5307c588ff347b57f7d0ca719f8341
GIT binary patch
literal 816
zcmdPOu{px|I9c_6N9e*uoA1xklHTAX$Fiw<e~7u2Nq=onQAv)4p{a4QuAxGip@M<2
zzOkXcks$*dFacQ)7#SEM7#N<Z{b5+(@rRv3;}0{#IfYv>CLC~OSQ*#PGlm8`#Rnvo
zBxl4s=clB`7nkK38=IIjbpIE4Q2Ai`gP9LzKbZSq{)2@N7C%_}VEKcU4^}@|`(XWp
zjSm>NFmGYm!n%chOUkhW2~8dcI^vH<9D6d4U+!7ov$FS||2{q{eo(SQ>4w@4RS)G1
zbq_U=YPK!z#~vyFvt*EAkYy0&`LMy0<s&2OM%7=>cNm*Gs~LjWU!JpVVBN6JQPt4s
zXpSSx2G%V`$F+~KupyiMpzMX}3*{f`3P<xDH!FA>_&E9+NFVcaoTzxyfOSKV(qcp5
z<J*C_+)?Q8J%fZ)f#VN)AI)P2n#;0*c?07HrUMK+t|>4aaAf$;P!9~bs>>XAUR;5=
zQ2GEv=?zcb4<ZLdjxxw`%;T9Wc#LaazYJdwU&(o(zt|6g+{Xeo<4(+j(+qc1o-{C-
zTxL4Nu*-=9WU`eXK9Yd}BugC0zyOR|1`bI4{s6{rgT)_tVEnQ&JkwsIeMQ@bLj;rn
zaDZ#)nF4$qG2++M035$U4@4hGJy3mM_`vvq=>zizmJh5S*gmj-;P}A#f$IaNV+{M=
z=uGhh(d)EX4=@ygSl6@_UT_>vNWI|6_VGa}(_x0)b{tzSgXlPpoRTA@PaO|=vVLGc
g#wc^3=U@-h5r#ctOfxTI4-Mi%01{RZ4}y|20ArdW<p2Nx

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8156a-2.fw b/rtl_nic/rtl8156a-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..eec923b2cc01b8927f727c381508e00b61dbbe37
GIT binary patch
literal 3816
zcmb7Gdsr0L6+bgOEGsO_EH4*9Sad~<vF;KzXtZ5Kbk`^)53NmYdFp5KSpy2R{hBX~
z2nHX3O>D9dF|&qGO=^@T8-tJN%<x!~Sj7NYAEX%)Vkg$fY#$~~(CwL7B$&q^x!-s0
z@1DoK_uO;NoZX^^m4Dq|6!H0=>z<M;Li)d&xlUJfsqXVhZ&2qSk4?+$*;uwd!!~<P
z!Hjfsh0Sc8HPbeGX1WbV2dS*I0ILD6rVaz^7!FjX4M#%nT-W^h({3bYOg)}5oO645
zVd2_H7ws^vH;VKVk-_c0^VEt*7Uq={lohSZD|)hcO<uY+-DbVdX3eXZ1v>(?m?ka|
zYs5y;Ble14iROX118WBUGH`t0?7$}j+{Y#k$}c(%GR@JQkfhtIZ#Hy=?QKXj>@<{}
zci#4AOC$$v@`KQC8Kedoa#l~EJ%8gt-0?;G7Xl=%+jFzyi9PF^8WK0`+@S8bSE4vl
zfa6W`nf6p^vNuJz-URVCw%sUw3D3KRbBughl}U}8N9FIU5|>$OtQwVR+m&;EI&GN*
z{m=^@$`j(zdQPLqmz?9}x41U+c->^h=c-YE4{@(`8owjewuZD)t<cH@SoOUTvWs)6
z?|lJZt8f11z34j+$6%tl_sr0C#nu7Myf-%JZ__va&fu?)@t#sWoi~;1wG48#NnKn?
z14gL9v99Y~m(g^_6~~=*HJHxTo<sR<f4I213s4%4(#@k%CC(>P>^<heWrDrb<!E%+
z8yy0~yUdQpiTpB*OU||&HHHgN>S(-<vdyEi@Vhv&REgZ}93^K{Mo&u_Iql|Mr^TtK
zb>6jq@GdTR8syCCf&K+USTUIY2-(OPai^|P-(=v!8XFP}I}Dpn<LiRiFD@j{D>b83
z%)RaTC5-cyJhgpoKI0%AYiq$#g>wSR$9L4aVz`~IEvEX~dNn$QCEHyQD5)Nm=-SB+
zIJquz{b$ghD_QwDJq!)N^rl{1BrMI`ZC=R50c^5&tj^q#8E(qx;%fQE6lpdGo8ERr
zn5+u_V!SkiBR9=<7))s@Z<Ic2|FDbDB-wBK&8T@3H3_PQlE^MNb(97V;UPU558ZAM
z3QFyb`S}LNLf68QdVHg%m24%{dg6K;-h0)X1iQS+x5H??98QPH5wuP=&|29-Q!?p=
z)2ociTxh(`k>!1O&p(uVn!ASvkzaxQM=F12NU^Fn#&IW7j!l8mXnfm_OpB>o(Ka3%
z3gdL8X{L8n?)4$1TIL%sdbb3EUMk;4R>vZ43BNhvZ&EgwB~&N8Bdy{fp-W=cT$%J?
zswOtdznq(c`nRQ}oQ<zdI3_LO9LT>ZQIO4N3k?aal7&m-?-356<fr^p;UMC4e!9?t
zI1Q0SOyyIBJ%|=QMQ|ae@X5k%#0mUFVVAT()b-DoVkGzy>;MEb^-v-yhKqV}ia3;f
zut9laMeN#G)*0e&al)y0Cy-s@gmcl1_?{?AY5mclGcIHdqSjMgVY642>ZQ$=WJh(Q
zPGX!IKU2yCY6_mW-12K%!MHwhR$|(426oCb6HY}_aFxF%{2V>`g#Sc%5K-bqVF@D7
ze<)-jUg56@KSR94UlJZb^zlC7e#Achh;Sd`JA9uo6Y(5>PMD5(7ICU7?-V8@vOFs!
zBktw*3JHjN_$>+JrPCbG^BB7*l(g~B;VMEp${oeHj+2zG6Ref|l2_W{M74`)tZLf2
zV{7?GSVc@g$)XY^fI*zF|9^@7pUD^=4{5_8AcTvWHtliE>zZJ%|GxQy^V-~Hncvg@
zGx93tVE+#h!^8}6p7;wfM6g#V-_Zx*NyF1R+22j?VE3eUvc*J9xJ<^3lZjBjQ!A%<
z#d>3sSRW&f?}TLbrD(Kd%N9G9IM_YLPPS~3BMVo$PWC0T6W+e2QRbVPMCsKY-COG=
zvjl9$pdve~?ZqA)-`P^kJ45|(c#qey*un19iZrg5IJ$7HAGu4ZiCRjTPia>7%h&<m
zck28-&K3S%XOh3qneAULKIRoSV$H~pA|7!X{Ev786U3&6gu$j<;c63s>*cs!it9z*
zPwQdgr*&2_!z-3wb|%ZS5&NA9{&d7X^lC2RMaLz_WyckV*nAIiSFpDJjy-LXcd)$M
zInJNld9~R%aj=dO<Gp~0F_|dVg^H1Adl~l_yo2>>EH%n3sPkh~l$0asJ~Ly_YvOVw
z7^JbH86(M9X%AOdYykr%5E~aHG3qZqC}~xA3qx!L%oY9xP<eA3qt-+y@&~alav_F|
zV*#R&QrS?Ah0Tte#4gdA*?A#a_Nj1+)rXPn^EzPNMjZ<QQn#VVI#Lq0xmH_xMqc@*
zLf8c+ngP=eqz0ttkX}G)Msg#)%9wnA%)e|m$d?x;$tK^g3V>c219S`0$rzLGCwYnT
zw<VVENbdcPWR@K7Gi6eJ#zRCOagJ_*bI|vPB~)MJA>uIf0lg^Zj>RO^!mL{SGJCAW
z<dHKLsTOwCVs6%0i>MKcTGfJ4E#mRkZ*Cz}&rH5Uc?}&vC&W;FN;D=!dAd(r0Fz4>
zL_=6{_jcr;4o|cbebhm!7EBL>Kp*ikm>gPjC$W$4&6u({PUq9w!L&FIOgfDY^Hhx#
z%oDBVsh$l4b|P&@szut0RE<={)&ax*6Lzs0LdlcuPM$Js*7Uh!^AxLi_q{~E2DFa^
z)8`PW9~S~V<`b0q8izj6SXx0p%&H#-_ccQAenlJR-X5xRzpv4{E47q+jh1wyF%s<_
z2E~u`Q9rC1>9(<c#Gnr*Bn#3*NGp&wBK0$P0*+gOJ4kE^V|Hz3tEg)I0dlu~o4uC7
zsBO^x={@ij+2>v$W%~ttH|2@cLj=%bD7~L{v-_wP%2#7&+*AuwMfrYhHy;2xD->us
z6ntfQ%9`{Ytqh(^<98CNC)C}_$*V3b?*>z^=HzbuGt8C<JRRr`+~>*L<ql&RJlnj_
zI!4Nz=(teUO}tF`9?aLj0;ZKA&#Jz~p>OeMr}44*nS~!0ZCUfEO!$%t2;XJ9tfwPr
z*8a>)S=Q%9(2V`SJ!5ocRhNRgd{vh?MrT!Z(Wom?b%rrIyQ&L89i!@imM|V8@Av&D
zPsdWe#deYn#^UQxjql0IoXQ!M`pPgyR^x~E=u0p@Z&nh%-gzrSFg_TS|6XunRIU?Y
zn3zLIx$tz`Q*G87B~QO;dqb1o76=p~6(cFKvE%n`1Q1mDn0l~TZ6p1o=E#xx*)=$4
zXV+BSfd6R-&5<wP+Aj_Ov7Z={S23*nezH35aE<#g={Azj=nvN_t59+qc{uT~M;s_D
z@(_=E20ul-o1=!6`qiT&B}fm$uC{0Kcd@>08#mUsA6k=8Tu@e!x3S>2BSl<cO%GOZ
zZvKY64LG7U#6-o#CX7!^NKQ^MTP9i5q1;!9q}*5EX5xP6{BO&N(fjUvHFqxjSJ={s
z)W|yHzhfR7&&8)E*1f3g9oyHH&QBpJJwv&FAJW6{#%6>cF@EU1S#SV8fa`D*zJ^;6
ZfD^C^ra?4z1`3p$f9weQuk2F%{XYxTqTm1k

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8156b-2.fw b/rtl_nic/rtl8156b-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..7bf4dda806e30772949ddd10ed30703d89b2a833
GIT binary patch
literal 5448
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
WY=BL04#J<o&o0bS{}mLC?|%a~eNV6e

literal 0
HcmV?d00001

-- 
2.26.3

