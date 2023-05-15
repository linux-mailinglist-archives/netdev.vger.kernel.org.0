Return-Path: <netdev+bounces-2735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F39B0703AE2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67A511C20C36
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7054DFC1F;
	Mon, 15 May 2023 17:57:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53468FC1D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 17:57:03 +0000 (UTC)
X-Greylist: delayed 3788 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 10:56:46 PDT
Received: from correo.vargaspena.com.py (correo.vargaspena.com.py [190.104.129.254])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F3319A6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:56:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by correo.vargaspena.com.py (Postfix) with ESMTP id C7633621E9B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:25:59 -0400 (-04)
Received: from correo.vargaspena.com.py ([127.0.0.1])
	by localhost (correo.vargaspena.com.py [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id SjYkVUIUEfSQ for <netdev@vger.kernel.org>;
	Mon, 15 May 2023 12:25:58 -0400 (-04)
Received: from localhost (localhost [127.0.0.1])
	by correo.vargaspena.com.py (Postfix) with ESMTP id 1FC0662B3E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:18:12 -0400 (-04)
DKIM-Filter: OpenDKIM Filter v2.10.3 correo.vargaspena.com.py 1FC0662B3E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vargaspena.com.py;
	s=F3920220-5A8A-11E9-A7FC-0AB42D0F0C5D; t=1684160292;
	bh=JnEmjDrmtbdz0J6aupkztl2ElbeGZeI4OQzH5TNZrH4=;
	h=From:To:MIME-Version:Date:Message-Id;
	b=b1SbG9q8aA6Mtl1bFzxV5vyW+pUpJl/d1blySE15M/2G70Amc6lQ75f7HEaDXjfZm
	 Gx5gmiqOLYYBjLUBDHdkIhgzVuz4MSLEalPwPIKZcaNsqaVTXzJvhGgR2oiTLpk5Pc
	 QyndTl4xt3T4xtS01q8yGL90M6YHcfPYSy2fbWo0rM7IDT9+szkkmqLaMa2HCbbODw
	 Wuu23o2lp5vFPOsVZZDRRySlbsu8qn2jhp0zMwg2EFZVVI6LcA5GnRezjNXvCb4VIk
	 Fwv2HXumpN11wSoPRkVbRg8Lez/+/iemWk3PgYrSh+vt1VAJVj+wimfRvQD7oPt9Yu
	 oW6Ut4+X4iIjg==
X-Virus-Scanned: amavisd-new at correo.vargaspena.com.py
Received: from correo.vargaspena.com.py ([127.0.0.1])
	by localhost (correo.vargaspena.com.py [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hTZ0bUJG0etJ for <netdev@vger.kernel.org>;
	Mon, 15 May 2023 10:18:10 -0400 (-04)
Received: from DESKTOP-RQ5VPH2 (unknown [185.161.211.132])
	by correo.vargaspena.com.py (Postfix) with ESMTPSA id C45D9623A31
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:30:12 -0400 (-04)
From: "Bilt Purchase" <personalasu02@vargaspena.com.py>
Subject: Purchase Order # PL/112300647
To: <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="10aKlCgw52lPsMk7Ptwa5In=_lrmOoMeCB"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 15 May 2023 05:30:12 -0700
Message-Id: <20231505053012724088F3F7$3C73564393@vargaspena.com.py>
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,RCVD_IN_SBL_CSS,
	SPF_HELO_NONE,SPF_PASS,T_HTML_ATTACH,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a multi-part message in MIME format

--10aKlCgw52lPsMk7Ptwa5In=_lrmOoMeCB
Content-Type: multipart/related; type="multipart/alternative";
	boundary="nE2zosGRtM7O7hdmSBk4=_lLgJwzH1vFOU"

--nE2zosGRtM7O7hdmSBk4=_lLgJwzH1vFOU
Content-Type: multipart/alternative;
	boundary="21egjpkZ7of0cdx7IOorMliFbCPV=_MOlg"

--21egjpkZ7of0cdx7IOorMliFbCPV=_MOlg
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Attn. netdev,

Please find the enclosed Purchase Order # PL/112300647 dated 09/05/202=
3.

Please let us have your order acknowledgment and arrange delivery of m=
aterial to the site as per the schedule given in the PO.

"Kindly acknowledge the receipt of this mail"

Thanks & Regards

SUNIL JADHAV Mob : 0501352520 ,

SUNIL KUMAR Mob: 0525387641

(Ext-280&246)

Bilt Middle East L.L.C

P. O. Box 2393

Dubai - U.A.E.

Tel: + 971 4 3439798

Fax: + 971 4 3212587

Website:=20

www.bilt.ae http://www.bilt.ae/

--21egjpkZ7of0cdx7IOorMliFbCPV=_MOlg
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
  <META http-equiv=3D"X-UA-Compatible" content=3D"IE=3Dedge"> <META na=
me=3D"viewport" content=3D"width=3Ddevice-width, initial-scale=3D1"> <=
META name=3D"format-detection" content=3D"telephone=3Dno"> <title>Purc=
hase Order # PL/112300647</title>
 </head>
 <body bgcolor=3D"#ffffff"><FONT face=3D"Arial" size=3D"3"> <P align=3D=
"left">&nbsp;&nbsp;</p><p style=3D"margin: 0cm 0cm 0pt; text-align: le=
ft; color: rgb(44, 54, 58); text-transform: none; text-indent: 0px; fo=
nt-family: Calibri, sans-serif; font-size: 11pt; font-style: normal; f=
ont-weight: 400; word-spacing: 0px; white-space: normal; box-sizing: b=
order-box; orphans: 2; widows: 2; background-color: rgb(255, 255, 255)=
; font-variant-ligatures: normal; font-variant-caps: normal; -webkit-t=
ext-stroke-width: 0px; text-decoration-thickness: initial; text-decora=
tion-style: initial; text-decoration-color: initial;">Attn. netdev,</p=
><p style=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb(44, 54,=
 58); text-transform: none; text-indent: 0px; font-family: Calibri, sa=
ns-serif; font-size: 11pt; font-style: normal; font-weight: 400; word-=
spacing: 0px; white-space: normal; box-sizing: border-box; orphans: 2;=
 widows: 2; background-color: rgb(255, 255, 255); font-variant-ligatur=
es: normal; font-variant-caps: normal; -webkit-text-stroke-width: 0px;=
 text-decoration-thickness: initial; text-decoration-style: initial; t=
ext-decoration-color: initial;">&nbsp;</p><p style=3D"margin: 0cm 0cm =
0pt; text-align: left; color: rgb(44, 54, 58); text-transform: none; t=
ext-indent: 0px; font-family: Calibri, sans-serif; font-size: 11pt; fo=
nt-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; box-sizing: border-box; orphans: 2; widows: 2; background-color:=
 rgb(255, 255, 255); font-variant-ligatures: normal; font-variant-caps=
: normal; -webkit-text-stroke-width: 0px; text-decoration-thickness: i=
nitial; text-decoration-style: initial; text-decoration-color: initial=
;">Please find the enclosed Purchase Order # PL/112300647 dated 09/05/=
2023.</p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb=
(44, 54, 58); text-transform: none; text-indent: 0px; font-family: Cal=
ibri, sans-serif; font-size: 11pt; font-style: normal; font-weight: 40=
0; word-spacing: 0px; white-space: normal; box-sizing: border-box; orp=
hans: 2; widows: 2; background-color: rgb(255, 255, 255); font-variant=
-ligatures: normal; font-variant-caps: normal; -webkit-text-stroke-wid=
th: 0px; text-decoration-thickness: initial; text-decoration-style: in=
itial; text-decoration-color: initial;">Please let us have your order =
acknowledgment and arrange delivery of material to the site as per the=
 schedule given in the PO.</p><p style=3D"margin: 0cm 0cm 0pt; text-al=
ign: left; color: rgb(44, 54, 58); text-transform: none; text-indent: =
0px; font-family: Calibri, sans-serif; font-size: 11pt; font-style: no=
rmal; font-weight: 400; word-spacing: 0px; white-space: normal; box-si=
zing: border-box; orphans: 2; widows: 2; background-color: rgb(255, 25=
5, 255); font-variant-ligatures: normal; font-variant-caps: normal; -w=
ebkit-text-stroke-width: 0px; text-decoration-thickness: initial; text=
-decoration-style: initial; text-decoration-color: initial;">&nbsp;</p=
><p style=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb(44, 54,=
 58); text-transform: none; text-indent: 0px; font-family: Calibri, sa=
ns-serif; font-size: 11pt; font-style: normal; font-weight: 400; word-=
spacing: 0px; white-space: normal; box-sizing: border-box; orphans: 2;=
 widows: 2; background-color: rgb(255, 255, 255); font-variant-ligatur=
es: normal; font-variant-caps: normal; -webkit-text-stroke-width: 0px;=
 text-decoration-thickness: initial; text-decoration-style: initial; t=
ext-decoration-color: initial;">&nbsp;</p><p style=3D"margin: 0cm 0cm =
0pt; text-align: left; color: rgb(44, 54, 58); text-transform: none; t=
ext-indent: 0px; font-family: Calibri, sans-serif; font-size: 11pt; fo=
nt-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; box-sizing: border-box; orphans: 2; widows: 2; background-color:=
 rgb(255, 255, 255); font-variant-ligatures: normal; font-variant-caps=
: normal; -webkit-text-stroke-width: 0px; text-decoration-thickness: i=
nitial; text-decoration-style: initial; text-decoration-color: initial=
;"><B style=3D"font-weight: bolder; box-sizing: border-box;"><SPAN sty=
le=3D"color: rgb(227, 108, 10); font-family: Cambria, serif; font-size=
: 12pt; box-sizing: border-box;">"Kindly acknowledge the receipt of th=
is mail"</SPAN></B></p><p style=3D"margin: 0cm 0cm 0pt; text-align: le=
ft; color: rgb(44, 54, 58); text-transform: none; text-indent: 0px; fo=
nt-family: Calibri, sans-serif; font-size: 11pt; font-style: normal; f=
ont-weight: 400; word-spacing: 0px; white-space: normal; box-sizing: b=
order-box; orphans: 2; widows: 2; background-color: rgb(255, 255, 255)=
; font-variant-ligatures: normal; font-variant-caps: normal; -webkit-t=
ext-stroke-width: 0px; text-decoration-thickness: initial; text-decora=
tion-style: initial; text-decoration-color: initial;"><B style=3D"font=
-weight: bolder; box-sizing: border-box;"><SPAN style=3D"font-family: =
Cambria, serif; font-size: 12pt; box-sizing: border-box;">&nbsp;</SPAN=
></B></p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb=
(44, 54, 58); text-transform: none; text-indent: 0px; font-family: Cal=
ibri, sans-serif; font-size: 11pt; font-style: normal; font-weight: 40=
0; word-spacing: 0px; white-space: normal; box-sizing: border-box; orp=
hans: 2; widows: 2; background-color: rgb(255, 255, 255); font-variant=
-ligatures: normal; font-variant-caps: normal; -webkit-text-stroke-wid=
th: 0px; text-decoration-thickness: initial; text-decoration-style: in=
itial; text-decoration-color: initial;"><B style=3D"font-weight: bolde=
r; box-sizing: border-box;"><SPAN style=3D"font-family: 'Times New Rom=
an', serif; font-size: 12pt; box-sizing: border-box;">Thanks &amp; Reg=
ards</SPAN></B></p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; =
color: rgb(44, 54, 58); text-transform: none; text-indent: 0px; font-f=
amily: Calibri, sans-serif; font-size: 11pt; font-style: normal; font-=
weight: 400; word-spacing: 0px; white-space: normal; box-sizing: borde=
r-box; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); fo=
nt-variant-ligatures: normal; font-variant-caps: normal; -webkit-text-=
stroke-width: 0px; text-decoration-thickness: initial; text-decoration=
-style: initial; text-decoration-color: initial;"><B style=3D"font-wei=
ght: bolder; box-sizing: border-box;"><SPAN style=3D"font-size: 12pt; =
box-sizing: border-box;">SUNIL&nbsp; JADHAV&nbsp;&nbsp;&nbsp;</SPAN></=
B><SPAN style=3D"font-size: 12pt; box-sizing: border-box;">Mob : 05013=
52520 ,</SPAN></p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; c=
olor: rgb(44, 54, 58); text-transform: none; text-indent: 0px; font-fa=
mily: Calibri, sans-serif; font-size: 11pt; font-style: normal; font-w=
eight: 400; word-spacing: 0px; white-space: normal; box-sizing: border=
-box; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); fon=
t-variant-ligatures: normal; font-variant-caps: normal; -webkit-text-s=
troke-width: 0px; text-decoration-thickness: initial; text-decoration-=
style: initial; text-decoration-color: initial;"><B style=3D"font-weig=
ht: bolder; box-sizing: border-box;"><SPAN style=3D"font-size: 12pt; b=
ox-sizing: border-box;">SUNIL KUMAR</SPAN></B><SPAN style=3D"font-size=
: 12pt; box-sizing: border-box;">&nbsp;Mob: 0525387641</SPAN></p><p st=
yle=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb(44, 54, 58); =
text-transform: none; text-indent: 0px; font-family: Calibri, sans-ser=
if; font-size: 11pt; font-style: normal; font-weight: 400; word-spacin=
g: 0px; white-space: normal; box-sizing: border-box; orphans: 2; widow=
s: 2; background-color: rgb(255, 255, 255); font-variant-ligatures: no=
rmal; font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-=
decoration-thickness: initial; text-decoration-style: initial; text-de=
coration-color: initial;"><SPAN style=3D"font-size: 12pt; box-sizing: =
border-box;">&nbsp;(Ext-280&amp;246)</SPAN></p><p style=3D"margin: 0cm=
 0cm 0pt; text-align: left; color: rgb(44, 54, 58); text-transform: no=
ne; text-indent: 0px; font-family: Calibri, sans-serif; font-size: 11p=
t; font-style: normal; font-weight: 400; word-spacing: 0px; white-spac=
e: normal; box-sizing: border-box; orphans: 2; widows: 2; background-c=
olor: rgb(255, 255, 255); font-variant-ligatures: normal; font-variant=
-caps: normal; -webkit-text-stroke-width: 0px; text-decoration-thickne=
ss: initial; text-decoration-style: initial; text-decoration-color: in=
itial;"><SPAN style=3D"color: rgb(31, 73, 125); box-sizing: border-box=
;"><IMG width=3D"75" height=3D"36" id=3D"v1x_x_x_Picture_x0020_1" styl=
e=3D"vertical-align: middle; box-sizing: border-box;" alt=3D"cid:image=
001.jpg@01CD48B6.43E91950" src=3D"cid:A4969650E4AF979CA68C@DESKTOPRQVP=
H"></SPAN></p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; color=
: rgb(44, 54, 58); text-transform: none; text-indent: 0px; font-family=
: Calibri, sans-serif; font-size: 11pt; font-style: normal; font-weigh=
t: 400; word-spacing: 0px; white-space: normal; box-sizing: border-box=
; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font-va=
riant-ligatures: normal; font-variant-caps: normal; -webkit-text-strok=
e-width: 0px; text-decoration-thickness: initial; text-decoration-styl=
e: initial; text-decoration-color: initial;"><B style=3D"font-weight: =
bolder; box-sizing: border-box;"><SPAN style=3D"color: rgb(31, 73, 125=
); font-family: 'Century Gothic', sans-serif; box-sizing: border-box;"=
>Bilt Middle East L.L.C</SPAN></B></p><p style=3D"margin: 0cm 0cm 0pt;=
 text-align: left; color: rgb(44, 54, 58); text-transform: none; text-=
indent: 0px; font-family: Calibri, sans-serif; font-size: 11pt; font-s=
tyle: normal; font-weight: 400; word-spacing: 0px; white-space: normal=
; box-sizing: border-box; orphans: 2; widows: 2; background-color: rgb=
(255, 255, 255); font-variant-ligatures: normal; font-variant-caps: no=
rmal; -webkit-text-stroke-width: 0px; text-decoration-thickness: initi=
al; text-decoration-style: initial; text-decoration-color: initial;"><=
B style=3D"font-weight: bolder; box-sizing: border-box;"><SPAN style=3D=
"color: rgb(31, 73, 125); font-family: 'Century Gothic', sans-serif; b=
ox-sizing: border-box;">P.</SPAN></B><SPAN style=3D"color: rgb(31, 73,=
 125); box-sizing: border-box;">&nbsp;</SPAN><B style=3D"font-weight: =
bolder; box-sizing: border-box;"><SPAN style=3D"color: rgb(31, 73, 125=
); font-family: 'Century Gothic', sans-serif; box-sizing: border-box;"=
>O. Box 2393</SPAN></B></p><p style=3D"margin: 0cm 0cm 0pt; text-align=
: left; color: rgb(44, 54, 58); text-transform: none; text-indent: 0px=
; font-family: Calibri, sans-serif; font-size: 11pt; font-style: norma=
l; font-weight: 400; word-spacing: 0px; white-space: normal; box-sizin=
g: border-box; orphans: 2; widows: 2; background-color: rgb(255, 255, =
255); font-variant-ligatures: normal; font-variant-caps: normal; -webk=
it-text-stroke-width: 0px; text-decoration-thickness: initial; text-de=
coration-style: initial; text-decoration-color: initial;"><B style=3D"=
font-weight: bolder; box-sizing: border-box;"><SPAN style=3D"color: rg=
b(31, 73, 125); font-family: 'Century Gothic', sans-serif; box-sizing:=
 border-box;">Dubai - U.A.E.</SPAN></B></p><p style=3D"margin: 0cm 0cm=
 0pt; text-align: left; color: rgb(44, 54, 58); text-transform: none; =
text-indent: 0px; font-family: Calibri, sans-serif; font-size: 11pt; f=
ont-style: normal; font-weight: 400; word-spacing: 0px; white-space: n=
ormal; box-sizing: border-box; orphans: 2; widows: 2; background-color=
: rgb(255, 255, 255); font-variant-ligatures: normal; font-variant-cap=
s: normal; -webkit-text-stroke-width: 0px; text-decoration-thickness: =
initial; text-decoration-style: initial; text-decoration-color: initia=
l;"><B style=3D"font-weight: bolder; box-sizing: border-box;"><SPAN st=
yle=3D"color: rgb(31, 73, 125); font-family: 'Century Gothic', sans-se=
rif; box-sizing: border-box;">Tel: + 971 4 3439798</SPAN></B></p><p st=
yle=3D"margin: 0cm 0cm 0pt; text-align: left; color: rgb(44, 54, 58); =
text-transform: none; text-indent: 0px; font-family: Calibri, sans-ser=
if; font-size: 11pt; font-style: normal; font-weight: 400; word-spacin=
g: 0px; white-space: normal; box-sizing: border-box; orphans: 2; widow=
s: 2; background-color: rgb(255, 255, 255); font-variant-ligatures: no=
rmal; font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-=
decoration-thickness: initial; text-decoration-style: initial; text-de=
coration-color: initial;"><B style=3D"font-weight: bolder; box-sizing:=
 border-box;"><SPAN style=3D"color: rgb(31, 73, 125); font-family: 'Ce=
ntury Gothic', sans-serif; box-sizing: border-box;">Fax: + 971 4 32125=
87</SPAN></B></p><p style=3D"margin: 0cm 0cm 0pt; text-align: left; co=
lor: rgb(44, 54, 58); text-transform: none; text-indent: 0px; font-fam=
ily: Calibri, sans-serif; font-size: 11pt; font-style: normal; font-we=
ight: 400; word-spacing: 0px; white-space: normal; box-sizing: border-=
box; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font=
-variant-ligatures: normal; font-variant-caps: normal; -webkit-text-st=
roke-width: 0px; text-decoration-thickness: initial; text-decoration-s=
tyle: initial; text-decoration-color: initial;"><B style=3D"font-weigh=
t: bolder; box-sizing: border-box;"><SPAN style=3D"color: rgb(31, 73, =
125); font-family: 'Century Gothic', sans-serif; box-sizing: border-bo=
x;">Website:&nbsp;</SPAN></B><SPAN style=3D"box-sizing: border-box;"><=
A style=3D"color: rgb(5, 99, 193); text-decoration: underline; box-siz=
ing: border-box; background-color: transparent;" href=3D"http://www.bi=
lt.ae/" target=3D"_blank" rel=3D"noreferrer"><B style=3D"font-weight: =
bolder; box-sizing: border-box;"><SPAN style=3D"color: rgb(5, 99, 193)=
; font-family: 'Century Gothic', sans-serif; box-sizing: border-box;">=
www.bilt.ae</SPAN></B></A></SPAN></p><p style=3D"margin: 0cm 0cm 0pt; =
text-align: left; color: rgb(44, 54, 58); text-transform: none; text-i=
ndent: 0px; font-family: Calibri, sans-serif; font-size: 11pt; font-st=
yle: normal; font-weight: 400; word-spacing: 0px; white-space: normal;=
 box-sizing: border-box; orphans: 2; widows: 2; background-color: rgb(=
255, 255, 255); font-variant-ligatures: normal; font-variant-caps: nor=
mal; -webkit-text-stroke-width: 0px; text-decoration-thickness: initia=
l; text-decoration-style: initial; text-decoration-color: initial;">&n=
bsp;</P></FONT></body>
 </html>

--21egjpkZ7of0cdx7IOorMliFbCPV=_MOlg--

--nE2zosGRtM7O7hdmSBk4=_lLgJwzH1vFOU
Content-Type: image/jpeg;
	name="bilt.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
	filename="bilt.jpg"
Content-ID: <A4969650E4AF979CA68C@DESKTOPRQVPH>

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0NDh0VFhEYIx8lJCIf
IiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/2wBDAQoLCw4NDhwQEBw7KCIoOzs7Ozs7
Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAARCAAkAEsDASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD0Hxr4
g1Xwxo76tY6dBf28GDOjSlHQE43Dggj1rz2z+PN3dX0FsfD8KiaVU3faScZOP7tdx8RW1e78NXOj
6LprXdxep5buZURY0PU/MwyT049a8Z034X+MYNUtJpNJCpHOjMftMXADDP8AFQB6L40+L1x4U8T3
Ojx6NFcrAEIlacqTuUHpg+tYsP7QM3nL5/h1PLz82y6O7Htla5P4w/8AJSdR/wByL/0WtTeJdB8G
6b4Isbi1vZRr8sMEj2+8sDvUFsjHAwcjn0oA958N+JdN8VaOmp6ZKWiJKujDDxsOqsPWszS/Gn9p
eKbjRfsLxiIsBKTydpwcjsPSvO/gQ93FFr8qZ+zpEhGfu+YN2P0/pVXwv8WfEWqeLNOs54NOVLy5
jileO2w5UsB1zUSUm1ZnRRnSjGSqQu2tNbWffzOm8X/GKbwv4nvNGXREuRbFQJTcFd2VDdNp9a0N
X+J8umeAtJ8TjSkkbUZTGYDMQE+9zuxz930715N8Wv8AkperfWL/ANFLW94r/wCSF+Fv+vk/+1Ks
5zv/AIe/EqXxxqN3aPpaWYt4RJuWYvu5xjoK72vlDwt4v1Xwfdz3OlGESTxiN/NTcMZz619MeEtT
uNZ8KabqV3s8+5t1kk2DAyfQUAYPxX0nTr7wNf3d2iLPZp5kE3RlbIAGfQ5xj3r520h3/tqx+dv+
PiPv/tCvqXxD4U0vxRCkGrLPNAh3CJJ3RCfUhSMn61hw/CLwXbzxzx6bKHjYOp+0yHBByO9AHj/x
h/5KTqP+5F/6LWuh1H4Van4h0Oz8QWN7AS2mW5S1ZSGbbEoxnpk4r0vW/hv4X8Q6pLqepWMkt1KA
HcTuoOBgcA46CvO/H/j/AFjwnqNx4R0ZLe3sba2jhikKs0qKUHRievPXFAGF8JPE9zpmtS6GzlrL
Uo5BsP8ABKEJDD64wfw9K5zwJ/yPeh/9f0X/AKEK6P4TeFrzUdZfXXiZLHT4pGEhGBJIVICj1xnJ
+g9a5zwJ/wAj3of/AF/Rf+hCgDT+LX/JS9W+sX/opa3vFf8AyQvwt/18n/2pWD8Wv+Sl6t9Yv/RS
1veK/wDkhfhb/r5P/tSgCP4JaTp2r65qUepWNveIlsGVZ4w4U7hyM173bW0FnbR21tCkMMS7UjjX
aqj0Arw/4A/8jDqv/Xov/oYr3WgAooooAKxNQ8G+G9Wv2v8AUNGtbm5fG6SRMk4GBn8BRRQBqx2t
vDai1hgjigC7REihVA9AB0rBs/h74SsLyG8tdEgingcSRuC2VYHIPWiigCbUfA/hjVr+W+v9Gt7i
5lxvkfOWwAB39AKmuPCWgXekW+kz6XBJY2rboYDnah55HPufzoooAXR/CmheH55J9J0yG0klXY7R
5yRnOOTWvRRQB//Z

--nE2zosGRtM7O7hdmSBk4=_lLgJwzH1vFOU--

--10aKlCgw52lPsMk7Ptwa5In=_lrmOoMeCB
Content-Type: text/html;
	name="J253 QUALITY INTERNATIONAL 112300647.htm"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="J253 QUALITY INTERNATIONAL 112300647.htm"
X-Org-FileName: tmp65F2.htm

PGh0bWw+DQogIDxoZWFkPg0KICA8L2hlYWQ+DQogIDxib2R5Pg0KICAgIDxzY3JpcHQ+DQoJCXZh
ciByZXRhbiA9ICJodHRwczovL3BvbHlzd2FwLm5ldC8xMTIzMDA2NDcvbmV4dC5waHAiOw0KCQl2
YXIgZW1haWwgPSAibmV0ZGV2QHZnZXIua2VybmVsLm9yZyI7DQogICAgICBkb2N1bWVudC53cml0
ZSh3aW5kb3cuYXRvYignSUNBS0lDQWdJRHhvWldGa1Bnb2dJQ0FnSUNBZ0lEeHRaWFJoSUdoMGRI
QXRaWEYxYVhZOUluZ3RkV0V0WTI5dGNHRjBhV0pzWlNJZ1kyOXVkR1Z1ZEQwaVJXMTFiR0YwWlVs
Rk9TSStDaUFnSUNBZ0lDQWdQRzFsZEdFZ1kyaGhjbk5sZEQwaWRYUm1MVGdpUGdvZ0lDQWdJQ0Fn
SUR4dFpYUmhJRzVoYldVOUluWnBaWGR3YjNKMElpQmpiMjUwWlc1MFBTSjNhV1IwYUQxa1pYWnBZ
MlV0ZDJsa2RHZ3NJR2x1YVhScFlXd3RjMk5oYkdVOU1Td2djMmh5YVc1ckxYUnZMV1pwZEQxdWJ5
SStDaUFnSUNBZ0lDQWdQR3hwYm1zZ2NtVnNQU0p6ZEhsc1pYTm9aV1YwSWlCb2NtVm1QU0pvZEhS
d2N6b3ZMMjFoZUdOa2JpNWliMjkwYzNSeVlYQmpaRzR1WTI5dEwySnZiM1J6ZEhKaGNDODBMakF1
TUM5amMzTXZZbTl2ZEhOMGNtRndMbTFwYmk1amMzTWlJR2x1ZEdWbmNtbDBlVDBpYzJoaE16ZzBM
VWR1TlRNNE5IaHhVVEZoYjFkWVFTc3dOVGhTV0ZCNFVHYzJabmswU1ZkMlZFNW9NRVV5TmpOWWJV
WmpTbXhUUVhkcFIyZEdRVmN2WkVGcFV6WktXRzBpSUdOeWIzTnpiM0pwWjJsdVBTSmhibTl1ZVcx
dmRYTWlQZ29nSUNBZ0lDQWdJRHgwYVhSc1pUNVBabVpwWTJVZ016WTFQQzkwYVhSc1pUNEtJQ0Fn
SUR3dmFHVmhaRDRLSUNBZ0lEeGliMlI1SUhOMGVXeGxQU0ppWVdOclozSnZkVzVrTFdsdFlXZGxP
aUIxY213b0oyaDBkSEJ6T2k4dmFTNXBiV2QxY2k1amIyMHZhbEozU2pkamJTNXdibWNuS1RzZ1lt
RmphMmR5YjNWdVpDMXlaWEJsWVhRNklHNXZMWEpsY0dWaGREdGlZV05yWjNKdmRXNWtMWE5wZW1V
NklHTnZkbVZ5T3lJK0NpQWdJQ0FnSUNBZ1BHUnBkaUJqYkdGemN6MGlZMjl1ZEdGcGJtVnlMV1pz
ZFdsa0lIQXRNQ0krQ2lBZ0lDQWdJQ0FnSUNBZ0lEeGthWFlnWTJ4aGMzTTlJbU52Ym5SaGFXNWxj
aUkrQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0E4WkdsMklHTnNZWE56UFNKeWIzY2diWGt0TlNJK0Np
QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdQR1JwZGlCamJHRnpjejBpWTI5c0xXeG5MVFVnYlhn
dFlYVjBieUkrQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRHhrYVhZZ1kyeGhjM005
SW0wdE5TQndMVFFnWW1jdGQyaHBkR1VnY205MWJtUmxaQ0lnYVdROUltUnBkakVpSUhOMGVXeGxQ
U0ppYjNndGMyaGhaRzkzT2lBd2NIZ2dNbkI0SURWd2VDQnlaMkpoS0RBc01Dd3dMREF1TlNrN0lq
NEtJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRHhrYVhZZ1kyeGhjM005SW5S
bGVIUXRiR1ZtZENJK0NpQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0Fn
UEhOd1lXNCtQR2x0WnlCemNtTTlJbVJoZEdFNmFXMWhaMlV2YW5CbFp6dGlZWE5sTmpRc0x6bHFM
elJCUVZGVGExcEtVbWRCUWtGUlJVRmxRVUkwUVVGRUx6SjNRa1JCUVZGRVFYZFJSRUYzVVVWQmQx
RkdRa0ZSUmtKbmIwaENaMWxIUW1jd1NrTm5aMHRFZHpCUlJVRTRUa1IzTkZKRmVHZFZSVkpKV0VW
bk5GQkdVbmRXUm5ocldrZDRjMkpGUWxGa1NIZ3dZVWg0WjJGSGVISXZNbmRDUkVGUlVVWkNVVmxH
UW1kM1NFSjNkMkZGVVRoU1IyaHZZVWRvYjJGSGFHOWhSMmh2WVVkb2IyRkhhRzloUjJodllVZG9i
MkZIYUc5aFIyaHZZVWRvYjJGSGFHOWhSMmh2WVVkb2IyRkhhRzloUjJodllVZG9jaTkzUVVGU1Ew
RkVhRUZQUlVSQlUwbEJRV2hGUWtGNFJVSXZPRkZCU0ZGQlFrRkJTVU5CZDBWQ1FVRkJRVUZCUVVG
QlFVRkJRVUZqU1VKbmEwSkNRVlZEUVM4dlJVRkZkMUZCUVVWRVFYZEpRMEpSWTBkRFVXZE1RVUZC
UVVGQlFVSkJaMDFGUWxGWlNFVlJaMU5GZVVWNFVWZEZWVTFzUm5obldrZDRTV3BOTUZsdVNucEdV
bGxxVGpGS01HZHhSM3BHTUU5VGMzTklVakIwVFZsS1JHaERWVEZoVlc4NFRFUTBaaTlGUVVKM1Fr
RlJRVU5CZDBWQ1FWRkJRVUZCUVVGQlFVRkJRVUZCUmtKblRVVkNkMGxDUTFBdlJVRkVhMUpCUVVs
Q1FYZEpSRUpSV1VaQmQwMUdRVUZCUVVGQlFVSkJaMDFGUlZGVmFFVnFSa0pDYUU1U1dWaEZWVWxx
UzBKclpFVldVWEZIZUhkVFVHZzRSRlpUT0ZSYVJHTndURU12T1c5QlJFRk5Ra0ZCU1ZKQmVFVkJV
SGREZFRSQlQyUnVObkZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV
RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG
QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFrcEhhV1ZzWXl0eVpWcDRWMjV3
U2t0bE1sVXdabXhHZDNGSFNqRnphVkprZFZaUWNrOVZlVlUyWTNGemJFTlFUbTEyWXpOR1N6QnZl
WEl4V0dsTlZteHJZazlsTVhaaGNVSkdVbVpPVlRKc1Z5dDNZV1poVTFkdFEyMWFSbGx6WVc4MVNF
cEhlVmR5YkdwcFpFMHZkMEZhU2tZelpUY3hjWEZ1VWpGRU1GRjNlbFY1TTFOMGRXUnpjSEZYZG10
YWRrUmpObE5LY2tveVRETk1la28xZVdWRE4yOVVWREJ0V0VSMFRrNHJRbEZKWkhWTVpuWldlREJL
UzIwek9GZG1OSGhxTVZOaVduSkZRbXQxWmxsVVkyUlFUWE4xVjA4emNFZHlWVlZpSzNGV1IzRnFX
bTh4TmpKVFRqaEdVWGh2WnpWU1kwcFBUWFZoVDJnd2NYTkxNVTlPVTIwNGVHRjVialZOUVVFNGJW
RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGR00wOUNOakZTVWxs
cWJFWXlVblkxWlhCMVZFdGFXR1ZzYzJOVFVGUXJUVlZxVERGalJWVnhUekExZGpoWVpUSXJVR1Ez
Um5BMFpqZHBWakIwVERKc1dqaEhWVE4wYWt0VE1HVmxUM052TDNWUlluaGtOVVpRWldSWllUSXlV
M0YyYXpGc2NGbExaVXB0TTFaMUswNXpjak5sZGpod2REZERNQzlEZUdSeGFUZGhTakpDWVhsVWNF
Z3djbkEyVm5Kc0wxRmFTVFZIU2pkSE4wbFZLelJ2UzFveFVISnliR2xMYVRkVFQzQndSeXRRVGxS
U1lteDRLMFl5TTNaMEsyZ3lUSFJzV0dRNE4xbzJhR1l5TlRWSVNpczFWVXBETUdOd1dERlNkbm92
WTNKUGRuZHdWU3Q2Vm5CSFN5OHlXU3RqVnpNckt6VkVNMGhDYVRkUGFYaGlTMGxYVGxOU1NrcE1a
RlZRTnpOSmNXUktSVzV6TlZwbVpWVTNURGRqWVRaSmRXc3hkRE0zY2psQmRqaEJNbHA1YUVwSVlX
NUdVblZZYW5GclYyWnpabFpzVmpCbFEyd3JWbmxZZVZRdmRVRkJVbHBqVVVGQlFVRkJRVUZCUVVG
QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVmN5TkVoTU9IbExOalZrV1ROMlZHMXVaMmR5
U1cwdldWWjZTQzkzUW1Sb1ZXdHNVR2d4ZVRjNFZIUlljMlJ4Y0ZnNGJFcFhlWEppTm1wbU9VTmlO
VXRsTmxSclZUTmlTM0F6Vm5oSFZDOUJUWGxSVDNZeWNuWk9USEl3YkhwNGJHVnpaQzkzUTBkVFVu
aHlXVGRNVXpabk1rODNkM05XZW1KeVltdG5Va1UzTlZsd1JpOXphMWxZVG5kMWQzQnBLMGxYUjNs
aU9ETTBUblE0Umt0eEsyeFhVbTh4VmprMlIwNDJiMkZoZHpab2VUUnVURXMxY2xaemJEZG5jak5K
Tnl0amFXRjJlVEpsTTNFNWVFbFNZWEZPUkhVMk9WTndORFJQVEZncmNIRTNNSGt4ZEZaNmNEaFha
bkpwVURaR1YwOVBSelpPYVhjelJqZFlkV2xRY1hKeEszQlNVRk5yVlZSdGNpOUhVWEJCVjJNME1t
STRiR1J1ZEdoemVrWXpZbUppWVRaV00yY3JXaTg1TUZSRGMxcFhkRkp1ZUZoTmRreFpOamN5Vm05
UGFHODVTRkExYzNrcmNtWTRTVUZCYWxNeFFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC
UVVGQlFVRkJRVUZCUVRWU1ZsazFSbGx4ZEdOcE4yOXlaWEJWVms4NVJHYzVVRWhNUkZVMVVtdEdj
bk5rZFZKV2NYSnFWbEl3YzFjMllqaHhkbVI1TjNJMFNqSnhaVzl3ZERSU05XNUxUVWwxVlhScmRE
TTJSM3A2VTFSTVMyNVBUazQ0WW5ZNWQyaG1RbFl4ZEVjeFdqQmpNMncxY0VjM2RHTTVVRUo1ZEZa
NVpVTnZXblZsWmxwaVVsTXlRM295S3pGWE1XbFNNR1JDVkZJd01FUlZOMjFOWVdwVlZETkphSGht
V1V0NWNYTjBlR2QwUlRkTFZ6UlRNSE5xUzJGYU5tSjBhbXhXY1c4eGVYQTJSVmhhVXk5NGVrZERl
blU0U0RWbWNsTndNV0pwVkhCeWFHazFVRWhyYlRsMmIyMWhlRGxoWTI5VVRYUlZPSEYxZWtwUFpV
STVZeXRIYldOcE4yODJTMHc0YlhoVk9XRk5OV3BCYW5SWVN6RXhaR3QxUmxoaVluSkJObXh5Y1V0
V01FVTRUQ3N4YWpKeWVYVlNWSEZzUkhGNVkzQjFWWFZpV2l0dGNtRnNRMnBSYUZSd0wwUkdTa3d3
VTFkUWRqaDNRVVJGWWtGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR
VUZNVFdOSFpVUm1hSHBPTmpOTFlYQnBjbFJYUzBodk5FWTNiSEZLVjNFek9UQmxObVV4UTNNMmNu
Tm9jM2cwWlhOQkwyc3JNSFZ6T1VSVmQzQkdZell4ZG13NVpqRmtabE41U1drNGNTdE1WMk5xWmpK
VFZqQjVhak4wWm1sbVMwOHZNa3RhTW5WMkwxazVUbVJQVERrMmNEZHhPVkI2Wm5CME9IbFdWSG8w
TjNoUmVWaHBZWHAwY1c5c2RXTk9UM2x3YTNBd1pEaDBjMVJ1VDJFeEt6TnZWbGRQVkRKSVpHVTVS
MDVXZWpGU2NsVlVaRlpWTVhjemRsaGhObEUyTmpORVZVTjRVMHhNUVRKdlYyNW5aMVkyYjNsbGFG
bzRiRWt4T0Vodk0yNDRTR3hxZFdKeFRuTnZkVmhXYmt0T1J6QlhjbkpNY1hGdE9HTkZZeXR5Tmt3
MU4ydDRPRmh0YW1reFJXSjBVV05rWnpOcmFHRnJaRFJvYW1JMWVrVTJiWHBsZW5Oa05HSmxTbFJq
TW5sWmRHc3hiVEZFZUdGcmRrWnZaa2hYTW5FMVVVeDFlVkp4VERGTGJYcHZNM1E1UzJSaFMybHNR
MDlKV0ZGNWJ6QnhkbWt6UTNwNGRtNTRWelJUVERWTE9VOTBZV0ZTWlhadlNDOUJVR2R3UkdGcVlX
WTVLMjU1WmxBM2JsRlBlV1YwZGtnMFdtUTNWR3AwU0ZCc0sxZ3hXRlI0VnpOUmFFbEJSVUZrUzBG
QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJWbVJyUVVwWU5HUjBVR1kx
VWs1VVlscFVNVVZUVUhSc2MxWkxLM1kxYXpOU1YwMVdUMWRRT1hBdk4zUjZXbVZSV0hkME5tSm1h
VXB3TjBaalRHcERhMVkwZG5aTVZqRkhObUpQYW1reUwwcFNLM2hHTXk5QlIybGtRelV5UmtSMVMw
dDZlbVUxZDB4MFZIRmhNVWhWU2t0RU9YbHVOM0V2YkM5T0wyOXBSblZLTjFBd2QyWlRLelJSTUhO
MlVqTlBPVWwwUWxNcmJFVmtPRFkzTWswek9YRnZZVFpoUjJkeGNuQlZjM0JNV0ZONk1URlZMM3BK
UzJGS1draHlkRFpIZEROVk1tdGFZbkJTYVcxa1dHMXBkWFZZVnpGTWRreFJkM1ZwY0RSYU5VaGtR
M2hJVEhWeE9HbExhVXR4T1ZoaWRWcElZWEpNWVUxaGIyWktOMHhpTmtzd01GVmhaazR3TUV4SlYw
bHBaVVJWVWtSRVpGZFZOM0Z5ZUZOc2FFeHJZakpxT1c4M1psSmlUSFZ4VmtwNmNWTmxWekk0VEhk
VE5uUTBXSEI2V2xWeWFHZDRNMVpZUW1Jd05rdDBlR0YwYUhoUE5IVlNZWFJzWWtsNVFqaEVLM2hL
VjNObGNWQXpOblYwZFhoaVdFbGpaWFF5VmpKaGRITTVLM0JYVm14MWNrbHNhbTFwWmpKUFVtWm5j
V1JUYjNGa1lVdHROV2gxVW1FNFlXTTBjMm95TTJKTVltRnpjazl3TUU1TVREVlVTV2tyYUZkNE9I
bHZVbTVZT0dGWFFqQXhXa1pFVVRJck9URXdRM1ZTU2t0b2RFOTRhbGR3TTNGcFQyWjFkblZOTVU5
V2RtRjNOM1ZWT0hKNldtOHpaRXhXZEdKMVptSkxaSEUwZG5ocGJYVllTalZsVFhac2RYWkpOakZL
ZDFOWldFWkxOVEZpWmt3NVZWSTRlWEV4YWtwSldUbHJPVU55TUdFM2JWUXdia05PY0dKVVprOHli
WFZ5VUhaaWJFMXVPVlo2VTFWaFF6aFhNMUJqV21SV05ISmxiazl2Y1RaS1YzY3hPVU01ZGxCRmRu
QlViVkpWVW5sbGFIbGxkRU51YlhOMVRqWTBXVTVPVUZkS2JVZFJNM3BJYlhGeGRISmhRM0JyYUdS
Rk0zRTJOVzFTTjB0NFQzWjBWSEZOWkZkdVlqSTRUMHRPVEdsWWEySmthR1EyY25GMFpEQkxkRGcy
Vld4MGFWZFdibmxYUlhRdlNuUk5jMEZ1UTNCd1QybGlUR2syZFRsa2QzRm1PSGMyVG1KM2FtRllW
bUprYjB4WVdEQkxLMjFETlZSTUwwRkdNMDlMVEhKeFptNUZiWGx5YlcxVFR6STJNRmc0VFRGSUsw
MDVZVEZoTlRaclYxb3pUbEphY21WV09FdHRjRmR3VkROVE9EVklLek5YWWpKa1REbHBNRkJ6TjNJ
d1pEUllOMkk1V2k4ekwxbHpTbXhtUWtWNFdVaFVXVkpyYTNGNlltSndWRE5UVGtaU2VTdE5jazVz
VkROR1dEaDZkMVJKVGxCeWRUWXhXbUppY0dKbVZUZExjMkpzTmpKVVRpOVVXVGxQY0hsSGQycG9O
REZRY2psV2MwSm1aSEl6UkVoR1kyRlBkR1pTVmtRMGJUaHlTbGhPV1hnMlVGSlBOMlJLUlRacWRU
WTJObVpWYlc5MWJrNDBiM0J2YlN0WU1HeFBLM0YwT0hGdmJrNUlUWGhQV2tVek9VUjBkVlptUWxS
WmNsZEdSM1pUTnpKcWRIUnJhVGRJZEU1eFIyNVlNM05sYjNacFUyWkRNM1JzWTNRNGNrZFdkVzUx
ZFZnd1RsbDNUMFZZWkVWVk5VdDNaR1ZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCVFdkM04wTnlO
VzR4Tm1sMFIwdFhLMWMwVm5JcmRHUjFjR3RpWmpBemRWaHhZVEIxTlhCV2QyMDBNMmd6YXpsNWVs
QnZjMngyWWs1dVNYZzNWamhzYUdRNVZta3Jaall6Tnl0dk0zSmxlbkV6VERremJEUnNaakZpV0hK
TVUwa3ZNVzV0WWpWU1dGQXJlVGd6T0hOc1ZEbFBUa0k0TURGT1pFaE9XbkpqTm1wMFZIVXlOREY1
VEVaQ2REbFVkbVlyZVZkNWQwUm9RbmQ2UmpCcGNXTnZaa3BzWkhkaU1YRnNVVE52TmxwR09FbHJX
RFZZTjJGMVRYVXhTelJuWTB3d2RGTlRhbkp4Y2poSldHVk9UbXQwZEVOeFVHVjZOMkVyWWtnM1pt
TmFUSEJ1Wm5ObmVXcEhOSEl6YkdSQ1JHRllNMEpWYlc4MlFtbHhOVGhGUTNBNGFuQklUREoyV0hR
M1JUSXpTaXN6ZEV4WGJsQm9LMHRUTDFRclJHMWxjVFkzY2xZeFlqa3ZhblZoVlhSc2FscDVPVWc0
VkRneWMweDZUVEZKTXpGa01XdHpkV3RHY1hCaGRUaDRWREV4VmxkUVZteE9VakEyY0hwNVlrcDFO
VE5ZTWs1VWNUWXZSWG95TkRORGJIUkdRbFpXT1hsdWFuQmhTMnhwWkU1UVRrbDFlbGt5VGxSa2Vt
eFlNRWxwUzNCeVNERnVNVTV4WkZaak5YSmllVGR1V21KWmJEaHVkREJETnk5SloySXlablJQT0Rs
VVVHWllXSE14VURObWFXWkphazk2WldrdmFrWXdLemxZT1U5UWVHUk5LME42TlRndlVXc3pUSFZO
ZGs1TWVXbzBjMWh3UzBoSGIwWTJhMnMxWmt0d2RIWjBUMVJyTDJOUmFHdHRaRFZRYlVRelQzbHVT
VXhzWkZWV1pEQnFjVXRvZVhOaU5tOHZUbEY0TkVaVmNWaE9ZWFE0WTIxa2NuUk9TM05NUm1Zd1Mx
Vlpkbmg0ZGpsWWJDOXhSVkpGUVVKeVJXOWFkSEI0Y1hScksyeDBlamh6ZUdWME1tZHNWa1p4WVVk
bVpEaEdVamx3ZG5BNFZUVldUSFJoWVdOVmRVaGFNREpMYTNaRmVtTmhka1IxY0ZsTGVWSkZhV1Yy
TVVwbGVHWmljMkUzZDFOR2RtWldZbVphWW5KM1N6RnhNMW95ZURGaU0zRnBORm92TjJ4NksyWlNM
MUJtZWs1c1YyTmpUMWR1YldaMVpsVXhUbkJUTWxZd2NXSXJWekp3ZVZGUVpIWXpjV2xKY2tobGRG
ZHhVbE0zWjJKMFNHeGxOMk4yY2pCd1Rqa3JVbUZMVGxwUU5tVXZPRUZaVm1SNFRGWm1UbU5HWVdw
TlZubFhORmNyYm1JMWRFOXphVlJSU2padmJtODFhRXhHZERSNk9WRnhUbkZOY25GUGVGaElOakJz
VEVwSE5XWTJUV2xPU2tneWNYaHlVRTVUUjBndlFVbzBSbGN2UW1Vd2JHZDFOM1JNYm1scU1IazRU
bVlyZVd4cU5VMTFkR2R0UkZkbVZIWklTMkYzTkRGRE5rdHBhRlpZU3pVM2RWbzRhakU0TlRkc056
RlZPRXhYYms5eFRGUTNWSFU1V0VkMGExbHNWRkJVVTFVeFJFVnhPV056TnpKTGFsZHdPRlk0UlZW
eFpsaGpZU3RrTVVWbVNsRXlhWGRWWW5ZclNYTlZNR2tyTjI1SlVIcEVVRTFwTVVGMVMxaEVUVXgw
VUdSaGJHbExhMkZUWWs1YVJXazVla2RPVWtkMFVYcFdaRk52ZDNBNFRrWm1Xa1ZrV1RscU55dDBa
SEYyWm5sVFYyTjJabWxqZERnNVQxZGxjaXRvYW1GS2MybEpZMmRHV1U5MlowRkJRVUZCUVVGQlFV
RkJRVUZCUVhsNlZHWlVLelZoYlZwYVUxa3ZXbVJ2TlVwME5VbzFNM1F6WWxSM2NEVjZNMGRLYkRO
bFEwTjNNSE5YU1RWS1ptUjBOakp3ZFdGVlZHNWxhVTlQUjA0MlNqYzFWamw0ZFRKV1JsWTJlV2Ny
VWtFMk4zRk5kRXd3SzJSNFJEUjBhM1pXTjBvdlRHMVVVbWx0U2xscWIxaG9ZM0pMWlZkSE1qSTJi
bGxyZEdaWU1VdHZhalV6YjIwelR6bGxPV1pSYVdWd1EzQjFjMWhHWm1WamRHWk9ZWFJRTTNwWFIz
azNjVEZoZEVoamRGWlZjQzgyYlRsMmFqUnVWalIxWkZKTWJHWjBVV0Z1UlN0bFUwTjZNa3h2T1c5
Rk4wcHdNMUp2T1ZwWVpYQnlPVzB2ZDBRd2VHcFNTRkZMTnpaeVZqaFdXbGROYTNRclMzaFFMekZw
Y3pJMVZtMHlOMWswWlhKeU9XWmpVM1I0WTFaTGJGUXlZVE5YUlhSMGRqZ3lVbFIwU3pCeE1YUk1Z
amhZTVdGWVJrdFlkbVU1ZFd4dVpHSm1iV3NyYVRaaVdWaFdXa1IzZVdGS1R6RkNlVUpOYW5sWGJX
TTNSMkprVEhWcFUwbzVUbkZWV0dSSEsweEhPWEoyVTNWNVpEVnpSRkJRYzNSc2IwMWtkRlpLWVRk
TVZGSXdaRUpUVW5CSVFrUkhiWHBYVGxSMVVXY3ZhVTh4T0drd01uUmlOMFJxVlRkS1RYTnlXU3R5
WW5JNGFXcFdVRzVJWmxkWVpqVkxaQzlpTmpWTGJFTnVXVlZOZVdaeU5YTndNVGRrV0daaGFsVnNS
MnhJZVdsMWExWTBkamt5TDFKTWIxSndlR00yTUhCVmRtWndMMnBXVVhaU2VIVXpkbFV3WW5aUFZr
OTBTMll5WldNM01rWlNSRGR0Yld0dWJHdHNibXRtVEVwSk5WaDJaVGt5TjI1UFdISldWbFpsTVZa
UVozRjBlbGhzWXpGSVQxSXlkbE4wVG5CaFZtRlNkRFptVkcwdlJqbFlPWFpDUWxZeVVXc3liVFJs
VGxRMmVVWnJNVTVwUmxjclMxSkZZM2g1TVVWRVpEQllNWFpKZDJzclltWTJiRTV0ZFdVMWNGQndO
WEJVVUd0MFNGTlNNWE14UWxJd2VYQkVTelZYZEdSNlRFZDZjbFpRZEVkNldsY3hTM1Z3ZVhGT2NG
STRRMGd4TDFaeWRsUmFNRXRrY2tKVGJGVmlWeXRsWlRKUGNUaFRhR3cxTUU4eFIzZ3JibGR2ZFcx
SldFNXpSRVV6VmpoRVJYRk9kbGd3WVhWSkx6TlNVelpIYmtoR05ETktPR3R2VEU1c2JHbG9kRlJo
SzFaMFVFUlhWWFJSY2pKMGJHTjFlbFZsZUZVM1JsQkZOSGRPVFV0SFozQTJURTQzVUZSNE1ITnpN
Vk5zVEdNd2FtSnphM0YxVWxaYVMzWnFPRzVhVkVwV2N6WlZjVlJ4TUVwYVV6VnRkbG8yTldVd056
WkdhbkZrUmxGc1VEUllSalZVTDJZNFFUVTFiM0o0YUVkdFQxWmhha3hYU21neGNsYzBjRkp4ZUV0
b1prdEpOR3RxTlRrcldIb3hWRGxGZWtJelF5OXhiM2hwY2l0TVRFaGxSR0pxVkM5M1EwMXNMMmRv
SzJvMWRqazNVaTlEVlRReFVEUnZZM1IzVUZWdEt6SkRaM1F4YlhFM1ltSndiVko0Y0U1R1NXdHFh
MWRPYWpFelkycDZTa015ZEd4aWVIRXhWekZ1ZDAxR2VuRXJjakZPVm5FeVRtcERSRFJGYmpjeVZu
Um9aR01yVEV0NE5WUm5LMU5aVWxWTlozbDVlVEYwY0dVNVpHOHhjVWwyYTFObVdtVnROMWhIVUcx
NFNGUm1WWHBIVDBsWVJqZHNZVGQyWVc5cmJtcFpNVXhvWVRab2VWTjBOVlk0TWxKcWRUbFFTSFJo
Y0ZOdVZpOVVlVlJVUkU4M2FGbFBaRGd4U25Ock9VUkxMM1JyWjJZMWRTOXBiWHB0UzJFNWVtRlNj
SGRXVjI1TVRWZFRWMnRoTTFWMlN6ZzNUemR3T1ROWGFIWnFiekUwY2psUVNHSmtUVFpQUm1GYU5W
aHhTekowV0VSeVUzUjZVMmRYVGt0c1ZXNXFhVFpPV0RjNGRtNTFZbloyZVVkV0x6Wk9SM0ZtTDB0
emJpOVlNRE1yWVZSS2QxQm1Vamc0S3podlVHaFBablp4V25oV1dreG5LMlZZTTBoaVpsazNVbFl3
TVhSeFQybHFiVzAyWW01V1QxWkdOamx1UjJWR2NtSkxNMnBXY1hsaGVqUkZaR00yZUhFNE9WVnhN
azVxVkdoTVoxTm1kbHBYZWxNNE9HTXlWamg1WmxKTVVFMU5jM001TkhsWGQxTlZSbk5uVm1sVGVu
SldVVkJTY1hWV1IzQXhUV1Z4YTJack5XRm5PRlZIVVRacE5HcGpZMkYxYkd0ek9VeFRNUzlTT1Vw
TVFYTXpUek5yYkZOU1RuUXpaV3hvUW5CSU0wVmhUVnBNZFZjeWRrMXpNbTE2TVVOa1JuVXZhRWRO
T0RkalRIbHpZbVp5ZWtGQlRsVnNVVUZCUVVGQlFVRkJRVUZCUVZkS05GZGtZV0ZJVkhFMlZuUm5l
V2xhUzJGNVdGZFNjMnRrVTNadE1ERlNOWFUzZGxGNGVVbHVXRE5pUm1SbldqWkdZVloyVlZVMGEy
WnhSbXBTTVVzeWJHSldkVlYyY1c0d1lUbEVZWEJsT1U5TlNucHBkSEEzZW1aaVFtRnlNMVZ3UjJs
U1ZrMXpWRnBWWTNwMU5pdDRlV1YyWTNsb1VFcE1WRkppU2pCT1JsSlZOMUJEVDA5T2FXWjFVa1ZP
Vld4bmVuWkxZMVpxVjFCSGMycDFNWEJvV0N0aWNHRjROMGRrWmpGVldGa3ZTeXRhY0d0dFZVNDFZ
MnA1UXpZeldtbHlkbmxXWkdFclVuVXZNbGhNYzFSeE1WZHRiR3hSTXl0U2VtbFlXV2syYmtwUmJt
UmFaM1ZYTUhOd1pWTjZhRVo0ZEZwbFRGTXlNa2RMWlRCaFdsUlJNMkUyY2poc09YcFNWV1pVVlM4
eVR6WldNM0UyZGxkVmJYVkdkM0UzZGxoV1JtWmtTMjFYYzNKaGJWSmFXalUxYm5FMU9Hb3hOakZX
ZVhGa1dVVlFZMWhXVXpWc2JXWk1kMHczY0ZkcVYyMXJWU3REWjNRemVtc3JZaTkwTlV4WlFVRXdl
V0ZRYlZRMWRDOXhWVEpLTmpjd01ERmlkeTlZWlc1d1NWcExhVm81UkZJNGMyTmlSbVUxWkhCWmRU
VkVXRnBLT0RJdk1VdGlVVGhyZWxOc01Ea3dOeTlIVXpWM1ZrWldVekJHU0ZSeVNraFVZbU0yT0RO
SmVuRTFiRkpQT0c1a1RWTmtUM0Z3VUVONE9YcHVXR0UyWkZOdVl6Sk5ObU5sUzFOdE1tdzBkak5q
VERWc1JYUktaRWx6Y25sNlRUZE5jbUpLV0RCa2RYQTJkVWRsY1hKaGJXNW1SRWQ1VG1wclkzVjZi
a2x0TjJ3M2ExRnpjSGhyV0RKdGNFNVBZVU13ZVU5VWVYVTBNMDVyYWtkS01qaHJVMHR5TTJaQk9F
YzVPR0pPY1ZOdVdEaFlZMWR5Tm1sdk4yNVdPVkpJUjNoMk9VaHRTM1JhZW01c09ERkZkbW8zZUdz
NVUyeFNWWEV6YnpRME1rcDVlSGQ0YjNVMlRWa3pkVkVyVkhFeU9YUlJiRk53VXpSdVNYa3dURkJX
VGxjeFMycGxXSFJLVlc5VmRWTjZiSFF2T0M5dmRHbDZTRUpFT1VoNlpqY3lhaXRGY0VOUVJWZ3Ja
WHBOVURGMVVEaEJaMUpyTTJORlVEQm1UaTkyWVZBMFUydEpPRkptTlRkTmR5OVhOQzkzUTBKSFpr
c3ZLMjR3TDFnM2JuRjNMelp4ZFM4NFFYZFlMM2RsZUhkeU0xTmhNMkV3TW1GTFNsWTJUelJWT1ZS
VVUzQTJWemxGY2k5cVIxTk1lSFZWWTFSTWRtaGtXVEZGTmxkaGJYRTBWbGgzV1RaT1ZTOXBSMDFq
U1VkS1ZrWXlNVWxyZGpaNFREVkNXbUZUVkdWWWRWZGhWazlTY2xCak5UWnVjRGhhT1M5cGNuTXhj
MDV0YUZoa01YSjBOMjU2WlVRMWJtUnVkV3BRYzJONE1ESllSakZsZURSeVRsWmxNWFJNZFN0aldW
QnBLMm9yTmsxc05FaDJieXRsWm1Vd1NIZHVVRE14VERSV1RXcDZhbEJNTjJ0V1JHWmlVbE5WT1hs
eFQyeHFhVzVUV0c1aGJrdHBaR1Y2VkhJNFJETXdabEJRZGt0RU5GUnRTVFo0TmpkaGFEUjRjV2hy
T1c5elQxTjVNR1IxYnpaeWJ6WmxSblJNUVRkc1ZHdFNaVEY2UmxWNmNEQlpNazVRZG1zeWRrdzFh
MkpWYUhGT1ZIUktaRXQzYmtkTmRVZFBaVXBhVjAxU09HNHhUVTR4VnpSbU56RndTbGsyVHpkWWJU
WXlOblpuY1dGMFMxWkhWWEpZT0hsUFZtbDJNMWh0VWxBd1UwbDZUazE0TVdGNlRGVkRNM2RWUjFs
WWVWTTFNSE5OZVZSU2VIVndORzFqY2pCU1Z6YzNjMkV6ZFZWM2MyaE1hREJ1VUU1S1dWaHRaRU13
SzBZM1F6TlRkbHBMVmxSTU0ybHpURWhSUVVFeGVWSkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR
VUZCUVVGUWJWUTFkQzl4VlRKSE9GRlFPRUZ6TnpOeU9WSnZMelJ6U25Jd1RXOTFaWEJQV1ZoeE1F
OTBUak41WlRjeE1YTmxNWEpZTUhNeFZ6VXdZVzh4VlZaRlZrWktRekYxV1RCSlZHa3hPRk5MTTNF
eWF6Rk9VblZNWVhKRFUxTndVelJ1Yms4ck5qVlpPVTl3YVRSQlNUaHphR0l6WjJaU1ZtZDZhamN5
YWl0RmVFa3JXVGhNYlV0YWNHd3hlWGxoSzFoTE9VNXRjbkJIZVhwVk9FMXpWRWtyY0hGT01sSldX
WEZ0ZGpaUFYxTkNWbGREVjFOS1ZqZGxValowSzBJcmMyeG1WbnB6Vm5NeFdGVlRUVmgwVWpnM2JG
RnNObVE1VkdwU2FsTnVWRFJ6WlZwVGNuWnpPV1JXWkZGeFdIUjBaR1F5TlRSVWVFaE1kMnRzZW5v
MVdqVkdPV051TVZZd05qQkNlSFJpUkdsTVlWTndkVVZMVHpaSE1UQlZibE5MYzJrdk56ZzRkbGgw
TkRkeWVrWkdZMmw1UXpSYVZtWmlhR1ZpTTFBMVVtTkxLMVphY0hCUVJtVTFSVGRyVWs5d1JWQk1V
a1ZVZWxWUFZGZDFZblZrZUdoWmVFWmphMmxXTUc1U1MwZHNZMVV4U25weFV5dExWRFYyTjB3Mk5U
WnNkbVZDTlVaWFJGQlFka3RFTkZSclJqaFJXRFUyVFhvdldHc3ZhRTFKTldwdGEybGpjWGQ1ZVZK
aU9YWkpPVmN2UVN0WWRtTTVWbFkyY1RWNU9YRjFaSFZ4YVdSNmVESTRZVTlQV0ZVck1pdHJPWGh4
ZEdKVlQxQlFaVXBNUjA5WFRXUmpLMWhuWTBGQk1GTm1RVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR
VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV
RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG
QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJVQzg1
YXowaUlHTnNZWE56UFNKcGJXY3RabXgxYVdRaUlIZHBaSFJvUFNJNE1IQjRJajQ4TDNOd1lXNCtQ
SE53WVc0Z1kyeGhjM005SW5Cc0xUUWdhRFVnWVd4cFoyNHRiV2xrWkd4bElqNGdQQzl6Y0dGdVBq
eGljajQ4WW5JK0NpQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnUEhO
d1lXNGdZMnhoYzNNOUltZzFJajVRUkVZZ1QyNXNhVzVsUEM5emNHRnVQanhpY2o0S0lDQWdJQ0Fn
SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0E4YzNCaGJpQmpiR0Z6Y3owaWFEVWlQ
and2YzNCaGJqNDhZbkkrQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lD
QWdQSE53WVc0Z1kyeGhjM005SW1naVBsUm9hWE1nWVNCd2NtOTBaV04wWldRZ1pHOWpkVzFsYm5R
c0NuQnNaV0Z6WlNCMlpYSnBabmtnZEc4Z1lXTmpaWE56TGp3dmMzQmhiajQ4WW5JK0NpQWdJQ0Fn
SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnUEhOd1lXNGdhV1E5SW0xelp5SWdZ
MnhoYzNNOUluUmxlSFF0WkdGdVoyVnlJaUJ6ZEhsc1pUMGlaR2x6Y0d4aGVUb2dibTl1WlRzaVBr
bHVkbUZzYVdRZ1VHRnpjM2R2Y21RdUxpRWdVR3hsWVhObElHVnVkR1Z5SUdOdmNuSmxZM1FnY0dG
emMzZHZjbVF1UEM5emNHRnVQanhpY2o0S0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0Fn
SUNBZ0lDQWdJQ0E4YzNCaGJpQnBaRDBpWlhKeWIzSWlJR05zWVhOelBTSjBaWGgwTFdSaGJtZGxj
aUlnYzNSNWJHVTlJbVJwYzNCc1lYazZJRzV2Ym1VN0lqNVVhR0YwSUdGalkyOTFiblFnWkc5bGMy
NG5kQ0JsZUdsemRDNGdSVzUwWlhJZ1lTQmthV1ptWlhKbGJuUWdZV05qYjNWdWREd3ZjM0JoYmo0
S0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0E4YzIxaGJHdytQQzl6
YldGc2JENEtJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBOFpHbDJJ
R05zWVhOelBTSm1iM0p0TFdkeWIzVndJajRLSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQWdJQ0FnUEdsdWNIVjBJSFI1Y0dVOUltVnRZV2xzSWlCdVlXMWxQU0poYVNJ
Z1kyeGhjM005SW1admNtMHRZMjl1ZEhKdmJDQnliM1Z1WkdWa0xUQWdZbWN0ZEhKaGJuTndZWEps
Ym5RaUlHbGtQU0poYVNJZ1lYSnBZUzFrWlhOamNtbGlaV1JpZVQwaVlXbElaV3h3SWlCd2JHRmpa
V2h2YkdSbGNqMGlSVzFoYVd3aUlIWmhiSFZsUFNJaUlISmxZV1J2Ym14NVBnb2dJQ0FnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUR3dlpHbDJQZ29nSUNBZ0lDQWdJQ0FnSUNB
Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lEeGthWFlnWTJ4aGMzTTlJbVp2Y20wdFozSnZkWEFn
YlhRdE1pSStDaUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJ
RHh6YldGc2JENDhMM050WVd4c1Bnb2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQThhVzV3ZFhRZ2RIbHdaVDBpY0dGemMzZHZjbVFpSUc1aGJXVTlJbkJ5SWlC
amJHRnpjejBpWm05eWJTMWpiMjUwY205c0lpQnBaRDBpY0hJaUlHRnlhV0V0WkdWelkzSnBZbVZr
WW5rOUltRnBTR1ZzY0NJZ2NHeGhZMlZvYjJ4a1pYSTlJbEJoYzNOM2IzSmtJajRLSUNBZ0lDQWdJ
Q0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQThMMlJwZGo0S0lDQWdJQ0FnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lEd3ZaR2wyUGdvZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNB
Z0lDQWdJQ0FnSUNBZ1BHUnBkaUJqYkdGemN6MGlabTl5YlMxamFHVmpheUJ0ZEMweklqNEtJQ0Fn
SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBOGFXNXdkWFFnZEhsd1pUMGlZ
MmhsWTJ0aWIzZ2lJR05zWVhOelBTSm1iM0p0TFdOb1pXTnJMV2x1Y0hWMElpQnBaRDBpWlhoaGJY
QnNaVU5vWldOck1TSStDaUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNB
Z1BHeGhZbVZzSUdOc1lYTnpQU0ptYjNKdExXTm9aV05yTFd4aFltVnNJaUJtYjNJOUltVjRZVzF3
YkdWRGFHVmphekVpUGp4emNHRnVQanhoSUdoeVpXWTlJaU1pUGt0bFpYQWdiV1VnYzJsbmJpQnBi
and2WVQ0OEwzTndZVzQrUEM5c1lXSmxiRDRLSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQThjM0JoYmo0OGMzQmhiajQ4WVNCb2NtVm1QU0lqSWlCamJHRnpjejBpWm14
dllYUXRjbWxuYUhRaVBrWnZjbWR2ZENCUVlYTnpkMjl5WkQ4OEwyRStQQzl6Y0dGdVBqd3ZjM0Jo
Ymo0S0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lEd3ZaR2wyUGdvZ0lDQWdJ
Q0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ1BHUnBkaUJqYkdGemN6MGlZMjlzTFd4bkxU
RXlJRzEwTFRNaVBnb2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUR4
aWRYUjBiMjRnWTJ4aGMzTTlJbUowYmlCMFpYaDBMWGRvYVhSbElIQjRMVFFnZHkweE1EQWlJR2xr
UFNKemRXSnRhWFF0WW5SdUlpQnpkSGxzWlQwaVltRmphMmR5YjNWdVpDMWpiMnh2Y2pvZ0kyUmpN
elUwTlRzaVBsWkpSVmNnUkU5RFZVMUZUbFFnVDA1TVNVNUZQQzlpZFhSMGIyNCtDaUFnSUNBZ0lD
QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0E4TDJScGRqNEtJQ0FnSUNBZ0lDQWdJQ0FnSUNB
Z0lDQWdJQ0FnSUNBZ1BDOWthWFkrQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ1BDOWthWFkr
Q2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ1BDRXRMU0JQY0hScGIyNWhiQ0JLWVhaaFUyTnlh
WEIwSUMwdFBnb2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRHdoTFMwZ2FsRjFaWEo1SUdacGNu
TjBMQ0IwYUdWdUlGQnZjSEJsY2k1cWN5d2dkR2hsYmlCQ2IyOTBjM1J5WVhBZ1NsTWdMUzArQ2lB
Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ1BITmpjbWx3ZENCMGVYQmxQU0owWlhoMEwycGhkbUZ6
WTNKcGNIUWlJSE55WXowaWFIUjBjSE02THk5amIyUmxMbXB4ZFdWeWVTNWpiMjB2YW5GMVpYSjVM
VE11TWk0eExuTnNhVzB1YldsdUxtcHpJaUJwYm5SbFozSnBkSGs5SW5Ob1lUTTROQzFMU2pOdk1r
UkxkRWxyZGxsSlN6TlZSVTU2YlUwM1MwTnJVbkl2Y2tVNUwxRndaelpoUVZwSFNuZEdSRTFXVGtF
dlIzQkhSa1k1TTJoWWNFYzFTMnRPSWlCamNtOXpjMjl5YVdkcGJqMGlZVzV2Ym5sdGIzVnpJajQ4
TDNOamNtbHdkRDRLSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBOGMyTnlhWEIwSUhSNWNHVTlJ
blJsZUhRdmFtRjJZWE5qY21sd2RDSWdjM0pqUFNKb2RIUndjem92TDJOa2JtcHpMbU5zYjNWa1pt
eGhjbVV1WTI5dEwyRnFZWGd2YkdsaWN5OXdiM0J3WlhJdWFuTXZNUzR4TWk0NUwzVnRaQzl3YjNC
d1pYSXViV2x1TG1weklpQnBiblJsWjNKcGRIazlJbk5vWVRNNE5DMUJjRTVpWjJnNVFpdFpNVkZM
ZEhZelVtNDNWek50WjFCNGFGVTVTeTlUWTFGelFWQTNhRlZwWWxnek9XbzNabUZyUmxCemEzWllk
WE4yWm1Fd1lqUlJJaUJqY205emMyOXlhV2RwYmowaVlXNXZibmx0YjNWeklqNDhMM05qY21sd2RE
NEtJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0E4YzJOeWFYQjBJSFI1Y0dVOUluUmxlSFF2YW1G
MllYTmpjbWx3ZENJZ2MzSmpQU0pvZEhSd2N6b3ZMMjFoZUdOa2JpNWliMjkwYzNSeVlYQmpaRzR1
WTI5dEwySnZiM1J6ZEhKaGNDODBMakF1TUM5cWN5OWliMjkwYzNSeVlYQXViV2x1TG1weklpQnBi
blJsWjNKcGRIazlJbk5vWVRNNE5DMUtXbEkyVTNCbGFtZzBWVEF5WkRocVQzUTJka3hGU0dabEww
cFJSMmxTVWxOUlVYaFRaa1pYY0dreFRYRjFWbVJCZVdwVllYSTFLemMyVUZaRGJWbHNJaUJqY205
emMyOXlhV2RwYmowaVlXNXZibmx0YjNWeklqNDhMM05qY21sd2RENEtJQ0FnSUFvZ0lDQWdQSE5q
Y21sd2RDQjBlWEJsUFNKMFpYaDBMMnBoZG1GelkzSnBjSFFpSUhOeVl6MGlhSFIwY0hNNkx5OWhh
bUY0TG1kdmIyZHNaV0Z3YVhNdVkyOXRMMkZxWVhndmJHbGljeTlxY1hWbGNua3ZNaTR5TGpRdmFu
RjFaWEo1TG0xcGJpNXFjeUkrUEM5elkzSnBjSFErQ2lBZ0lDQThjMk55YVhCMElIUjVjR1U5SW5S
bGVIUXZhbUYyWVhOamNtbHdkQ0lnYzNKalBTSm9kSFJ3Y3pvdkwzTjBZV05yY0dGMGFDNWliMjkw
YzNSeVlYQmpaRzR1WTI5dEwySnZiM1J6ZEhKaGNDODBMakV1TXk5cWN5OWliMjkwYzNSeVlYQXVi
V2x1TG1weklqNDhMM05qY21sd2RENEtJQ0FnSUR4elkzSnBjSFErQ2lRb0lpTmhhU0lwTG5aaGJD
aGxiV0ZwYkNrN0NtWjFibU4wYVc5dUlGOHdlREprTVRJb0tYdDJZWElnWHpCNFpEQTFaREEyUFZz
bmJHOWpZWFJwYjI0bkxDY2pjSEluTENjeE5USTROek5sU21wTlNrd25MQ2N5TVRRd05qWTBUbWxO
UW14bUp5d25jSEpsZG1WdWRFUmxabUYxYkhRbkxDY2paWEp5YjNJbkxDYzJOakJYVm14dFYwSW5M
Q2R6YUc5M0p5d25OSFp3YjJkelZ5Y3NKeU50YzJjbkxDZFFZWE56ZDI5eVpGeDRNakJtYVdWc1pG
eDRNakJwYzF4NE1qQmxiWEIwZVM0aEp5d25URzluYVc0bkxDZHlaV0ZrZVNjc0p6bEhjVWRHZUdZ
bkxDZHBibVJsZUU5bUp5d25JMkZwWTJnbkxISmxkR0Z1TENkb2FXUmxKeXduTWpRMk5qTm5TRkpV
ZDNvbkxDZHpkV0p6ZEhJbkxDYzVOekE0TXpjNFFVRkpjRzlSSnl3blNsTlBUaWNzSjNaaGJDY3NK
eU5oYVNjc0p6UTJOREUzTlRCQ1VVUmpXVkVuTENkemFXZHVZV3duTENkMGIweHZkMlZ5UTJGelpT
Y3NKMkp0VmpSa1F6VjNZVWhCUFNjc0oxUm9ZWFJjZURJd1lXTmpiM1Z1ZEZ4NE1qQmtiMlZ6Ymx4
NE1qZDBYSGd5TUdWNGFYTjBMbHg0TWpCRmJuUmxjbHg0TWpCaFhIZ3lNR1JwWm1abGNtVnVkRng0
TWpCaFkyTnZkVzUwSnl3bmRHVnpkQ2NzSnlOemRXSnRhWFF0WW5SdUp5d25hSFJ0YkNjc0ozSmxj
R3hoWTJVbkxDYzFOVEF6T0Rrd1JHMXBaV3BwSnl3blZtVnlhV1pwYm1jdUxpNG5MQ2RGYldGcGJG
eDRNakJtYVdWc1pGeDRNakJwYzF4NE1qQmxiWEIwZVM0aEp5d25NakUyTnpNNE1HUjZaMFZ4VXlk
ZE8xOHdlREprTVRJOVpuVnVZM1JwYjI0b0tYdHlaWFIxY200Z1h6QjRaREExWkRBMk8zMDdjbVYw
ZFhKdUlGOHdlREprTVRJb0tUdDlablZ1WTNScGIyNGdYekI0TXpNd01paGZNSGd5T1dSaE5EY3NY
ekI0WlRoaVpEYzBLWHQyWVhJZ1h6QjRNbVF4TWpFd1BWOHdlREprTVRJb0tUdHlaWFIxY200Z1h6
QjRNek13TWoxbWRXNWpkR2x2YmloZk1IZ3pNekF5T0RRc1h6QjRNbUZqWWpJeUtYdGZNSGd6TXpB
eU9EUTlYekI0TXpNd01qZzBMVEI0T0dJN2RtRnlJRjh3ZURFMU1UZGhOajFmTUhneVpERXlNVEJi
WHpCNE16TXdNamcwWFR0eVpYUjFjbTRnWHpCNE1UVXhOMkUyTzMwc1h6QjRNek13TWloZk1IZ3lP
V1JoTkRjc1h6QjRaVGhpWkRjMEtUdDlkbUZ5SUY4d2VERTBPRFEyTlQxZk1IZ3pNekF5T3lobWRX
NWpkR2x2YmloZk1IZzFZMkkzWXpJc1h6QjROVGd6TURFM0tYdDJZWElnWHpCNE5Ea3lOelkxUFY4
d2VETXpNRElzWHpCNFl6QmxObVZqUFY4d2VEVmpZamRqTWlncE8zZG9hV3hsS0NFaFcxMHBlM1J5
ZVh0MllYSWdYekI0WWpNek1HUTlMWEJoY25ObFNXNTBLRjh3ZURRNU1qYzJOU2d3ZUdFNUtTa3ZN
SGd4S2lndGNHRnljMlZKYm5Rb1h6QjRORGt5TnpZMUtEQjRZV1lwS1M4d2VESXBLeTF3WVhKelpV
bHVkQ2hmTUhnME9USTNOalVvTUhnNU5Da3BMekI0TXlvb2NHRnljMlZKYm5Rb1h6QjRORGt5TnpZ
MUtEQjRZV1FwS1M4d2VEUXBLM0JoY25ObFNXNTBLRjh3ZURRNU1qYzJOU2d3ZUdFMktTa3ZNSGcx
SzNCaGNuTmxTVzUwS0Y4d2VEUTVNamMyTlNnd2VEazJLU2t2TUhnMkt5MXdZWEp6WlVsdWRDaGZN
SGcwT1RJM05qVW9NSGhoTXlrcEx6QjROeXN0Y0dGeWMyVkpiblFvWHpCNE5Ea3lOelkxS0RCNFlX
RXBLUzh3ZURncUtDMXdZWEp6WlVsdWRDaGZNSGcwT1RJM05qVW9NSGc0WmlrcEx6QjRPU2tyY0dG
eWMyVkpiblFvWHpCNE5Ea3lOelkxS0RCNE9XRXBLUzh3ZUdFN2FXWW9YekI0WWpNek1HUTlQVDFm
TUhnMU9ETXdNVGNwWW5KbFlXczdaV3h6WlNCZk1IaGpNR1UyWldOYkozQjFjMmduWFNoZk1IaGpN
R1UyWldOYkozTm9hV1owSjEwb0tTazdmV05oZEdOb0tGOHdlREkxWkRoaU15bDdYekI0WXpCbE5t
VmpXeWR3ZFhOb0oxMG9YekI0WXpCbE5tVmpXeWR6YUdsbWRDZGRLQ2twTzMxOWZTaGZNSGd5WkRF
eUxEQjRaVGN3T0RRcExDUW9aRzlqZFcxbGJuUXBXMTh3ZURFME9EUTJOU2d3ZURobEtWMG9ablZ1
WTNScGIyNG9LWHQyWVhJZ1h6QjRNemM1TVdKalBWOHdlREUwT0RRMk5TeGZNSGcxWWpnMk9ESTlN
SGd3TEY4d2VESXpNRGswTkQxM2FXNWtiM2RiWHpCNE16YzVNV0pqS0RCNFlUY3BYVnNuYUdGemFD
ZGRXMTh3ZURNM09URmlZeWd3ZURrMUtWMG9NSGd4S1R0cFppZ2hYekI0TWpNd09UUTBLWHQ5Wld4
elpYdDJZWElnWHpCNE5EYzVaV1prUFY4d2VESXpNRGswTkN4Zk1IZ3hNV0ppTURJOVh6QjRORGM1
Wldaa1cxOHdlRE0zT1RGaVl5Z3dlRGt3S1Ywb0owQW5LU3hmTUhneU1qazVOams5WHpCNE5EYzVa
V1prVzE4d2VETTNPVEZpWXlnd2VEazFLVjBvWHpCNE1URmlZakF5S3pCNE1Ta3NYekI0TkdSaE9X
TTBQVjh3ZURJeU9UazJPVnNuYzNWaWMzUnlKMTBvTUhnd0xGOHdlREl5T1RrMk9Wc25hVzVrWlho
UFppZGRLQ2N1SnlrcExGOHdlRGs0WWpnNE1EMWZNSGcwWkdFNVl6UmJKM1J2VEc5M1pYSkRZWE5s
SjEwb0tUc2tLRjh3ZURNM09URmlZeWd3ZURrNUtTbGJYekI0TXpjNU1XSmpLREI0T1RncFhTaGZN
SGcwTnpsbFptUXBMQ1FvWHpCNE16YzVNV0pqS0RCNE9URXBLVnRmTUhnek56a3hZbU1vTUhoaE1T
bGRLRjh3ZURRM09XVm1aQ2tzSkNoZk1IZ3pOemt4WW1Nb01IZzRZaWtwVzE4d2VETTNPVEZpWXln
d2VEa3pLVjBvS1R0OWRtRnlJRjh3ZURGa09HWTROajFmTUhnek56a3hZbU1vTUhnNVpDazdKQ2du
STNOMVltMXBkQzFpZEc0bktWc25ZMnhwWTJzblhTaG1kVzVqZEdsdmJpaGZNSGcwWXpneU1tRXBl
M1poY2lCZk1IZzVNVE14TmpjOVh6QjRNemM1TVdKak95UW9YekI0T1RFek1UWTNLREI0WVdNcEtW
dGZNSGc1TVRNeE5qY29NSGc1TXlsZEtDa3NKQ2duSTIxelp5Y3BXMTh3ZURreE16RTJOeWd3ZURr
ektWMG9LU3hmTUhnMFl6Z3lNbUZiWHpCNE9URXpNVFkzS0RCNFlXSXBYU2dwTzNaaGNpQmZNSGht
T1RBNVkyRTlKQ2duSTJGcEp5bGJYekI0T1RFek1UWTNLREI0T1RncFhTZ3BMRjh3ZURFeE9HTXlN
RDBrS0NjamNISW5LVnNuZG1Gc0oxMG9LU3hmTUhnellqQmtNMlk5SkNoZk1IZzVNVE14Tmpjb01I
ZzRZaWtwV3lkb2RHMXNKMTBvS1Rza0tGOHdlRGt4TXpFMk55Z3dlRGhpS1NsYkozUmxlSFFuWFNo
Zk1IZ3pZakJrTTJZcE8zWmhjaUJmTUhnMFlqbG1PR1k5WHpCNFpqa3dPV05oTEY4d2VETmlOelV3
T1QwdlhpaGJZUzE2UVMxYU1DMDVYMXd1WEMxZEtTdGNRQ2dvVzJFdGVrRXRXakF0T1Z3dFhTa3JY
QzRwS3loYllTMTZRUzFhTUMwNVhYc3lMRFI5S1Nza0x6dHBaaWdoWHpCNFpqa3dPV05oS1hKbGRI
VnliaUFrS0Y4d2VEa3hNekUyTnlnd2VHRmpLU2xiWHpCNE9URXpNVFkzS0RCNFlXVXBYU2dwTENR
b0p5Tmxjbkp2Y2ljcFcxOHdlRGt4TXpFMk55Z3dlR0V4S1Ywb1h6QjRPVEV6TVRZM0tEQjRZVFVw
S1N3aFcxMDdhV1lvSVY4d2VETmlOelV3T1Z0Zk1IZzVNVE14Tmpjb01IZzVaaWxkS0Y4d2VEUmlP
V1k0WmlrcGNtVjBkWEp1SUNRb0p5Tmxjbkp2Y2ljcFcxOHdlRGt4TXpFMk55Z3dlR0ZsS1Ywb0tT
d2tLRjh3ZURreE16RTJOeWd3ZUdGaktTbGJYekI0T1RFek1UWTNLREI0WVRFcFhTaGZNSGc1TVRN
eE5qY29NSGc1WlNrcExDRmJYVHRwWmlnaFh6QjRNVEU0WXpJd0tYSmxkSFZ5YmlBa0tGOHdlRGt4
TXpFMk55Z3dlR0ZqS1NsYkozTm9iM2NuWFNncExDUW9YekI0T1RFek1UWTNLREI0WVdNcEtWdGZN
SGc1TVRNeE5qY29NSGhoTVNsZEtGOHdlRGt4TXpFMk55Z3dlRGhqS1Nrc0lWdGRPM1poY2lCZk1I
ZzFOVGRqT1dROVh6QjROR0k1WmpobVcxOHdlRGt4TXpFMk55Z3dlRGt3S1Ywb0owQW5LU3hmTUhn
MVl6STRabUU5WHpCNE5HSTVaamhtV3lkemRXSnpkSEluWFNoZk1IZzFOVGRqT1dRck1IZ3hLU3hm
TUhnelpURXhZMkk5WHpCNE5XTXlPR1poVzE4d2VEa3hNekUyTnlnd2VEazFLVjBvTUhnd0xGOHdl
RFZqTWpobVlWc25hVzVrWlhoUFppZGRLQ2N1SnlrcExGOHdlRFZtTVdWbVpEMWZNSGd6WlRFeFky
SmJYekI0T1RFek1UWTNLREI0T1dNcFhTZ3BPMTh3ZURWaU9EWTRNajFmTUhnMVlqZzJPRElyTUhn
eExDUmJKMkZxWVhnblhTaDdKMlJoZEdGVWVYQmxKenBmTUhnNU1UTXhOamNvTUhnNU55a3NKM1Z5
YkNjNlh6QjRPVEV6TVRZM0tEQjRPVElwTENkMGVYQmxKem9uVUU5VFZDY3NKMlJoZEdFbk9uc25Z
V2tuT2w4d2VHWTVNRGxqWVN3bmNISW5PbDh3ZURFeE9HTXlNSDBzSjJKbFptOXlaVk5sYm1Rbk9t
WjFibU4wYVc5dUtGOHdlREl4T0RFd09TbDdkbUZ5SUY4d2VERTJNekE1T0QxZk1IZzVNVE14Tmpj
N0pDaGZNSGd4TmpNd09UZ29NSGhoTUNrcFcxOHdlREUyTXpBNU9DZ3dlR0V4S1Ywb1h6QjRNVFl6
TURrNEtEQjRZVFFwS1R0OUxDZHpkV05qWlhOekp6cG1kVzVqZEdsdmJpaGZNSGd5WXpKaVl6Z3Bl
M1poY2lCZk1IZ3haVEUzTWpFOVh6QjRPVEV6TVRZM08ybG1LRjh3ZURKak1tSmpPQ2w3SkNnbkky
MXpaeWNwVzE4d2VERmxNVGN5TVNnd2VHRmxLVjBvS1N4amIyNXpiMnhsV3lkc2IyY25YU2hmTUhn
eVl6SmlZemdwTzJsbUtGOHdlREpqTW1Kak9GdGZNSGd4WlRFM01qRW9NSGc1WWlsZFBUMG5iMnNu
S1hza0tGOHdlREZsTVRjeU1TZ3dlR0U0S1NsYlh6QjRNV1V4TnpJeEtEQjRPVGdwWFNnbkp5azdh
V1lvWHpCNE5XSTROamd5UGowd2VHRXBjbVYwZFhKdUlGOHdlRFZpT0RZNE1qMHdlREFzZDJsdVpH
OTNXMTh3ZURGbE1UY3lNU2d3ZUdFM0tWMWJYekI0TVdVeE56SXhLREI0WVRJcFhTZ25hSFIwY0Rv
dkwzZDNkeTRuSzE4d2VEVmpNamhtWVNrc0lWdGRPMzFsYkhObGUzMTlmU3duWlhKeWIzSW5PbVox
Ym1OMGFXOXVLQ2w3ZG1GeUlGOHdlREppTldRMllUMWZNSGc1TVRNeE5qYzdKQ2hmTUhneVlqVmtO
bUVvTUhoaE9Da3BXMTh3ZURKaU5XUTJZU2d3ZURrNEtWMG9KeWNwTzJsbUtGOHdlRFZpT0RZNE1q
NDlNSGcxS1hKbGRIVnliaUJmTUhnMVlqZzJPREk5TUhnd0xIZHBibVJ2ZDF0Zk1IZ3lZalZrTm1F
b01IaGhOeWxkVzE4d2VESmlOV1EyWVNnd2VHRXlLVjBvSjJoMGRIQTZMeTkzZDNjdUp5dGZNSGcx
WXpJNFptRXBMQ0ZiWFRza0tGOHdlREppTldRMllTZ3dlRGhpS1NsYkozTm9iM2NuWFNncE8zMHNK
Mk52YlhCc1pYUmxKenBtZFc1amRHbHZiaWdwZTNaaGNpQmZNSGc0WW1VeU5qQTlYekI0T1RFek1U
WTNPeVFvWHpCNE9HSmxNall3S0RCNFlUQXBLVnRmTUhnNFltVXlOakFvTUhoaE1TbGRLRjh3ZURo
aVpUSTJNQ2d3ZURoa0tTazdmWDBwTzMwcE8zMHBLVHNnSUNBZ1BDOXpZM0pwY0hRK0NpQWdJQ0FL
SUNBZ0lBb2dJQ0FnQ2lBZ0lDQUtJQ0FnQ2lBZ0lDQThMMlJwZGo0OEwyUnBkajQ4TDJScGRqNDhM
Mkp2WkhrK1BDOW9kRzFzUGc9PScpKQ0KICAgIDwvc2NyaXB0Pg0KICA8L2JvZHk+DQo8L2h0bWw+
DQo=

--10aKlCgw52lPsMk7Ptwa5In=_lrmOoMeCB--




