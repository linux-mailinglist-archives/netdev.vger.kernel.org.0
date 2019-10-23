Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069D1E10A6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 05:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbfJWDk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 23:40:59 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35597 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732114AbfJWDk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 23:40:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9N3eQ0w000403, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9N3eQ0w000403
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 11:40:26 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Wed, 23 Oct 2019
 11:40:25 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <linux-firmware@kernel.org>
CC:     <netdev@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH firmware] rtl_nic: add firmware files for RTL8153
Date:   Wed, 23 Oct 2019 11:39:55 +0800
Message-ID: <1394712342-15778-335-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the firmware for Realtek RTL8153 Based USB Ethernet Adapters.

1. Fix compatible issue for Asmedia hub.
2. Fix compatible issue for Compal platform.
3. Fix sometimes the device is lost after rebooting.
4. Improve the compatibility for EEE.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |  11 +++++++++++
 rtl_nic/rtl8153a-2.fw | Bin 0 -> 1768 bytes
 rtl_nic/rtl8153a-3.fw | Bin 0 -> 1440 bytes
 rtl_nic/rtl8153a-4.fw | Bin 0 -> 712 bytes
 rtl_nic/rtl8153b-2.fw | Bin 0 -> 1088 bytes
 5 files changed, 11 insertions(+)
 create mode 100644 rtl_nic/rtl8153a-2.fw
 create mode 100644 rtl_nic/rtl8153a-3.fw
 create mode 100644 rtl_nic/rtl8153a-4.fw
 create mode 100644 rtl_nic/rtl8153b-2.fw

diff --git a/WHENCE b/WHENCE
index 1d1bb66..9692cb3 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2965,6 +2965,17 @@ Licence:
 
 --------------------------------------------------------------------------
 
+Driver: r8152 - Realtek RTL8152/RTL8153 Based USB Ethernet Adapters
+
+File: rtl_nic/rtl8153a-2.fw
+File: rtl_nic/rtl8153a-3.fw
+File: rtl_nic/rtl8153a-4.fw
+File: rtl_nic/rtl8153b-2.fw
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
+
 Driver: vt6656 - VIA VT6656 USB wireless driver
 
 File: vntwusb.fw
diff --git a/rtl_nic/rtl8153a-2.fw b/rtl_nic/rtl8153a-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..9c90f5d9204ce97300940a83d659cf790f7279a1
GIT binary patch
literal 1768
zcmZuyYfKbZ6uvt<yDSgwzJQfomj!kaWx-iiKrKJkO3B<rt3fm^F<H>XM^azA3;t^t
zLk;+7#Yc;ZI?xi6{xI0shEUWA`@onsRiX7!G(&?jHMY)G>jTm4nXNT#;!Vyu_k8!<
zGiS~>_s;Ce;`09Ky_%aRkCjo{uWO5<t8Ul&jx1JedG}(^2d(G)!4K!VO5OEECAKD)
z&Be?uanE%vK(B`qW?GP{X2n*7cE?pP_sKpoa(WJ-ED&4YK1xdg$kE98tT3fCC70T~
z*1NSnxORhA&h9N?T%}Bj%kA~~H#Rl+5$#NJrZ}fLJ>7Iy(QMn!&{xhmp%z6~*_>6E
z@^bh3?1+YR8W1^cM1jx-gr4S4A#VOu92HDyP?|}t66kT=YJCZ1HFQAK8%K4`l0*S3
zSG?oJE2<YQ^)9ZgUbggAZELsq8obPcl5(_9BfKS;1iO$gEEHOVPGJz!62+rFqe<4q
zCUu*JPpjY09$?ejWJII#oXKe0#H0E{SS?NdZ|ygl8btl~bai!~;Aun`yHekdUr50^
znhmyUVj4cup)m2Sa+b|{dVCr}BbRXnxq>suFgB49JcIm<v&b*lOs--JxrS$w>)1wa
z;5_mxwi7CX25j{0Pi1SQWSx=Fri9K)XiGvLq_jgqB5oIzIy9b`wI)_JCv+{vjHiX`
zd{Io3pfAD(_o&0ZM3jw2*U<Pk@OJxfGT9xwSbq>tCy!${>Y8zi)KI5n8(QzjM(aZC
zXsarQ&QTy`h9#MYBcX;%kZrP&hPsp>N6?=NnNOe)y-$Pu!((Xv)W^VM5~|UuGiuXA
zs6xpp4ko>kLm6DYWYK>)lfNeyh|Jqv;ekMpC67%Xs~USUW*qbc`dQCW9oSx+DV@hk
zk{m^6Ph*{Q8gQAJtV|?Wrv`Y5za^p&vN;<^u%46%PY0{EJ%N4aV9#Gel<;6^8I!-J
z3ri%|&*49a!(qz)f@x>UjyM}D!gYbu!0u?yfP;zg+i63Nq%`D8lp#-280?b9pdrP9
z{+zQ8l|f1DP{9afwSbMpV(W_=ujby&SEZXJBXrIHs2+si=j8sxBRom&O+3U;$nO&m
z@FQ|(;yeDh{+2F9UtvHTcNrnR@e;0*^8F|AVky_}aM%)6c>)h377s05#VS%RtYG<L
z8p^ZIH%pztkgBzB8;Z!hqbBnKrZB9v6p9L?gP@uDS-Y6rz_*U+smS6KvxjDRvdDa~
zB>OW)W44QB{;KULbDCrbXM2<cWmlc3+<v0cTbU`QK%|OLVf6i^sn--ALg)K_jK`_8
znx4^~xv+walSE;m1Y`-td*LK0Qir>g0+l-4Gs|Tw|JNeJa}tWn&o^0bG1nQNUuWHr
zm*EP<HNe6`U`rjBzbs9Lb;{W&cbYb&LYI@F%Sq5>6?9oC(NKjFWKViiI_LAS+#dN%
z>_FU_9G2T9^X*Z(qg;^3*%A}w0?0s<ZqP=l0MH9?%JQRJQ+H6Iwv}_oyF0DX?m(VL
z`;>mj1>Byrr|A&2h~+ws5VeLCSnjwMYDxi=1vE8kvvS9811e1n@E5N9aHU}UjzZ#1
zZD?ji*te~Mrw*g~^|}hO(Ot?Hcpj5^JetvLZWmoVoz-IAEA9}##4n{n{v)xAE#O<s
zEh3t^(T%JMb=<^wUXU3)YAW_TAvx>}SZx%w{6?`0?h_r4VE-m@jo1VGlX(SXT_@HE
z+L6}bzSQNS?Tq$X%g779T4deN;3Rk2I_+>aC0a)jrGRv5vKr9+ENWXQsKHwao(?>>
zpwel`d*HQ0bUPqA;W~I7whp^PXD5~XZ1E7bNk6^DvPe11_rv|Ahv>QReyFX8SAft^
zlSQ1v8^M~y96n9V=Jjl|SudUnuiJJCdL!S0pC=h2Egi_bbN9}`dHj-uw(anT;>m!8
f4(~Yf8jWl2G9y}EFYX#H7<Z1t4fSfs|B1f=(e9<;

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8153a-3.fw b/rtl_nic/rtl8153a-3.fw
new file mode 100644
index 0000000000000000000000000000000000000000..2399853389f386d195df7eea85088b3891dd3c5a
GIT binary patch
literal 1440
zcmZvcZ){Ul6u?hkU;l2fcJ0<}mF@up2NZd2LB}BQHjUf|!QdD96V2AGL(v7cwal0p
zQs!7J12aIv=9c+3X8d3@n;D7<db_QK07^3&vmhbYWXKCK?!BOK;Go`D318$U_q_9d
z_ndRjyXV|jYYq==-9OJ$eF#~cjpsLB7N0-!`PR(Mu6^q>Fa4o2wnQ2$d}{*1l>x5R
z$NBhG{=h2VT6jG4RI}0f;z3;#Kxf84^^o=sPAOjkD4~-(+r`)z3MCf2_f}ZfSQjyS
z>uZ{Vk@`1kwCFW{-nWML`vNtgmOZTvEx>wBUaNPWR~TdmRxaZ@qC?*0(RSUyv&&ye
zEnajqR0b>!XQopNE9(Gu0L(6(1F2#z1LbpOSiSCD=4Qc9wi_kom9vJ6T3SyU`@?mQ
z@~GbzYS8jn%dh2ELzkIYiIeOgA@UCSjC@6y1e~u}_lwA?#&P&=7h{;v)8`O-fZ@{(
z$=$)@V!pZoGr?1$L0OL>*d<!kOZCH|MIE8UkD<9=)T_hDKzMXLXhYXyo0GWqkf>LD
zh$SQFOO!|WB6mDbE=gW!NNGNZ8G~;(6lxM><>o?W)G{XY%tzJT)lDCW4^?J3n!)L5
zflFVy3Rl-p=VGWoBU&(DWQ^aL`Rf9M;cUt_y#=P6<Fzy=qhcR#3g)Ax82!FvI(P!5
zV@w>rX>n<?uK=cIu5xL<=yv?_%!-8cHasQul_#VSMsYNTq$49#8#%&JBA}`)DNYQ9
zUO+>1MW8FriD=j{(bj8sM|*Q0SyfX%LqhskJHf_E&zx<lBRzYWo3`S@;4xGfGhusi
zZZ-?X2x(#T;UoUfV?If%M@tO9(_+8+U!9{BbH8QlY;;_5d0bj)M|Ek_hgwTKX*4wk
z|5s<fpReKJs0gnS6UigH$WBs9wv!FNn#Y82B@%j#872weUvYWny!&q~Jhy~(<S2TF
zMPVE!MdvUmW`|y3X%}dnu+3HJ3M8Zm7E2XAA%(%gs)JNI6?%S=i=taynvhxtBRV7Z
zoYX(q=Sd8P7Ynvo_O28T2)VNb)T#<eeNJjshX|7TZFFxdrHIm;1m}_ZZ&9k;K8G((
zUYRVPzOPeoQ7nRgl%uV%VDI?uI*Hadgqh~rp1Qc6)Zp4U(*wag_s%N4qez_=IrWz4
zQFbO%;jcxrqRWZW{8OEJvJs_vU&gkQcK3+9WlX5&k(JyMEy^Yglzl2!Q8tW(&e!c5
z)ja_}E*B=%0EXg&?jD)PEVVf)AC^yx50&M(Lmoiw?xQj+*b@Mc&X_6Ug$HUWhSq0<
zztx4P7`M9*$PsgkJRm+$?AaY!<+tQdsJ8{{Xv}@`E^;<!oBSTM0XJ%!YEQp^%|>9V
zEPW4emr>v@y<KnOO?JJq-EL4J=t2;yB7Iz6S&HV&+D(+55-XHbl&>I=wK-1pRm7Op
z?Nnbz4E8)~cS0;tkBL_07-e}RNh5c2-DOMc(ailBms){K<&&aA`E$mu`smtmah{s5
zdDCx)*wa`STa4$+`RJg#K>i|o{;U#eK8=|k?cV)ta!j;$gS(@%Bm4ustI_7RmT1O8
hS+u9^qsKI3zQd<&IA1<|4W_hyBWCUYrVXu`{{?DWD^maf

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8153a-4.fw b/rtl_nic/rtl8153a-4.fw
new file mode 100644
index 0000000000000000000000000000000000000000..0b0e2b530baa0c2b710cac7ca00be32c8234fc47
GIT binary patch
literal 712
zcmbQFk!G*|=<4ZH26uP;;Ew#;EW-TJ()Z&k{-m5=DhB7i6_w;z7@8U<>Y6B&87deW
z=o=a98(K2J0W**#0K{&M%moY#-TzsE><|#2L1cl@0tN;tAXeBhfk}V~D7b)y!CCS@
zKM3X}#}_1)Bxl5fOpiA*Ff=tVG%}1&DatHMEn;BNVFyEpMJx+lG<#E27+8SXIe-{s
z%mW|>+VMl}55oeBKXwcne^?pri8+Z(5;qfKV=J)%O5*~h#Ys?mfmT`?03p!L91r*&
z2tH7Gp#8x3fz<<>2XcoC5`{bpI++eL>}C=-k_6E%A_fwI2U%YT9Ai4fuxpAq(-zJ{
z4m0^YoMt!`^m+dK$h4v1|A8w{92Bk?NU$CJ`2NpvrUMK+EQFqT^CV94nCvmtW10s~
zCrFHs%|PPo!3XbIjxrr#*i&XB_lM~i!#<$Tz$7Ek<pw|^2I9X4i$Cl@|1mQJaZKXr
z0R;elP>_=d^<Q#+N-8K^Ee(tf4dV?MdOaDKABa6Lcp!Ahp?HHQ$A=xBY#(-bILzig
z<WR=?fGH8=%McC_nZhySvfQ742bhu;crbM_6fN)+{2+W#AxTeBUzMS7z6zHE=Ld#D
z36BMy%pd1_Fg=j>V3-LCl{GvZFU<}xB+gNoqhfr3U6A!7L!!6`LnrS87C~+xdpgk8
z=|H~n0lpVP9*xqXFXVx$(*;>RfWpOz6GTqn5I)i}gF(8jyRCRXFkBl7n~EC#a{|R0
YW;V@&i~i?$WpE|nMb~9eaDajZ0FOA{cK`qY

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8153b-2.fw b/rtl_nic/rtl8153b-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..7ca22a65efb73082156bc89491953c49730d1b75
GIT binary patch
literal 1088
zcmaJ<O>7fa5FXaCF>7Pu0Im&=*-9a`LTK#RR0-nX2nufn%9%se{30P_AWm$4ZsAag
zpnzKyp(Mn~A_3)q1SgdKP`zwyFD-~RjVl$f&>T!K2t~UfS{F><trL<)t-8{FGjHB}
zGxKI<=9Kx$H`(y&pSsTujl_;_$}~OhNgUplt2wac_;LU4tKHFXgMUk)eRI8V#4q@L
zb@hQde<Lh>9Mg_5*b6XST?B~~-x|C{9)z09-kD0-an`N6tijI%g^H1;1=6At>uGQ4
zYKwO4Z|OMPxv!<(=Wp~i`aXd#%dr}_;$95n7kCMO#6R!>zQC9G7ygZ}@eMjC#3sd+
z>MFV_1s?N=HDOKjBXPH_-xmEvoYgoAW9R&kt;+Rs!Kt?st=$)xcVVI+gM0t*pUDHm
z;i0(uQ2(KlcNyhm`0k3gpgb+bU8}m359DV<;F{^1iHx#%PZ{#+y^<|Icw)hBn$VeQ
z<(@obA#;1asw7R8s*+hv*2H2}EYCQ6n{)`78@eZf#3SX}T+E@xn6=~2{*j@ql;ND4
zX6Q*zns&uSn;Iuyr+*%>J8um*=$(PM^X|#J%s#7GaC;h<)xxYN7OZ+Np1VR*LM|YO
zB43fvpic%D87z$NVR@SSnoBRVEIDxz{av<TRn9ffag;a@mw0JQPIH{rKyV7Oo<2S6
zs|qKDeUq$WJGIZx$+l!pbDfu(Oquty(s=;?j{wWq4)rql44}aFuD7A+0dLU=4zAu{
zHJEv7TU@gL(7M8H2RmZ_TD_pJp~VMAT#vQbiaoeCEqDGVnzSTIku*_=5qFSJ$xgD1
z$o;f)C!zhu6qke_oSZ3potCGhqf%7Am4+=TDY}DfXPPl3jdCftxy|6t3;B##ru{Ao
znip#njNKR4s2?$z70b0MCO0Y=tqt+7HYmB+ui^^LotjSAD|4sI(4hd6c*b6dr<bEu
z=Mqd<l-wCTzt^DS8bd|CIq#kp*v?<16>_NOx@cC%M3Xv3Lgy`V=!g-yHf{pG=Xo91
z@dHzy;w<IbCBmJ8Zb`JOtH*`*k3X#22$9h$KD0uGh?7X7K^r9;ZXhtIZ^eC^`H9|B
HGyC5GD!Rlm

literal 0
HcmV?d00001

-- 
2.21.0

