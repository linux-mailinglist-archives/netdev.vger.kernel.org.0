Return-Path: <netdev+bounces-717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1528D6F9435
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6F581C21ADA
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 21:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B54101FF;
	Sat,  6 May 2023 21:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5413E8837
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 21:43:07 +0000 (UTC)
Received: from ns-181.awsdns-22.com (unknown [198.20.75.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8785596
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 14:43:05 -0700 (PDT)
Received: from mailnull by ns-181.awsdns-22.com with local (Exim 4.96)
	id 1pvPgH-000a1n-08
	for netdev@vger.kernel.org;
	Sat, 06 May 2023 16:43:05 -0500
X-Failed-Recipients: netdev@vger.kernel.org
Auto-Submitted: auto-replied
From: Mail Delivery System <Mailer-Daemon@ns-181.awsdns-22.com>
To: netdev@vger.kernel.org
References: <20230506214302.B57697534CB0D3D0@vger.kernel.org>
Content-Type: multipart/report; report-type=delivery-status; boundary=1683409385-eximdsn-781427509
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Mail delivery failed: returning message to sender
Message-Id: <E1pvPgH-000a1n-08@ns-181.awsdns-22.com>
Date: Sat, 06 May 2023 16:43:05 -0500
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns-181.awsdns-22.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 
X-Get-Message-Sender-Via: ns-181.awsdns-22.com: sender_ident via received_protocol == local: mailnull/primary_hostname/system user
X-Authenticated-Sender: ns-181.awsdns-22.com: mailnull
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_00,HTML_MESSAGE,
	RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_ABUSE_SURBL,URIBL_BLOCKED,URIBL_DBL_SPAM autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--1683409385-eximdsn-781427509
Content-type: text/plain; charset=us-ascii

This message was created automatically by mail delivery software.

A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  netdev@vger.kernel.org
    host vger.kernel.org [23.128.96.18]
    SMTP error from remote mail server after end of data:
    550 5.7.1 Spamassassin considers this message SPAM. In case you disagree, send the ENTIRE message (preferably as a saved attachment) plus this error message to <postmaster@vger.kernel.org>

--1683409385-eximdsn-781427509
Content-type: message/delivery-status

Reporting-MTA: dns; ns-181.awsdns-22.com

Action: failed
Final-Recipient: rfc822;netdev@vger.kernel.org
Status: 5.0.0
Remote-MTA: dns; vger.kernel.org
Diagnostic-Code: smtp; 550 5.7.1 Spamassassin considers this message SPAM. In case you disagree, send the ENTIRE message (preferably as a saved attachment) plus this error message to <postmaster@vger.kernel.org>

--1683409385-eximdsn-781427509
Content-type: message/rfc822

Return-path: <netdev@vger.kernel.org>
Received: from [23.92.191.244] (port=50193)
	by ns-181.awsdns-22.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <netdev@vger.kernel.org>)
	id 1pvPgH-000Zr3-37
	for netdev@vger.kernel.org;
	Sat, 06 May 2023 16:43:02 -0500
From: Noreply vger.kernel.org <netdev@vger.kernel.org>
To: netdev@vger.kernel.org
Subject: Download Incoming Fax Message - OnHold
Date: 6 May 2023 21:43:02 +0000
Message-ID: <20230506214302.B57697534CB0D3D0@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: quoted-printable

<html><head>
<meta http-equiv=3D"X-UA-Compatible" content=3D"IE=3Dedge">
</head>
<body><div id=3D"editbody1">
<div style=3D"font-family: Verdana,Geneva,sans-serif; font-size: 10pt;">
<p>&nbsp;</p>
<table width=3D"100%" align=3D"center" style=3D"border-color: rgb(95, 95, 9=
5); padding: 0px; text-align: left; color: rgb(0, 0, 0); text-transform: no=
ne; letter-spacing: normal; font-family: Roboto, RobotoDraft, Helvetica, Ar=
ial, sans-serif; font-size: 14px; font-style: normal; font-weight: 400; wor=
d-spacing: 0px; white-space: normal; border-collapse: collapse; box-sizing:=
 border-box; orphans: 2; widows: 2; background-color: rgb(86, 138, 235); fo=
nt-variant-ligatures: normal; font-variant-caps:=20
normal; -webkit-text-stroke-width: 0px; text-decoration-style: initial; tex=
t-decoration-color: initial; text-decoration-thickness: initial;" border=3D=
"0" cellspacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); box-sizing: border-box;">
<table width=3D"580" align=3D"left" style=3D"border-color: rgb(95, 95, 95);=
 margin: 0px 10px; width: 580px; padding-right: 0px; padding-left: 0px; dis=
play: block; border-collapse: collapse; box-sizing: border-box;" border=3D"=
0" cellspacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td style=3D"border-color: rgb(255, 255, 255); padding: 0px; box-sizing: bo=
rder-box;">
<table width=3D"100%" style=3D"border-color: rgb(95, 95, 95); border-collap=
se: collapse; table-layout: fixed; box-sizing: border-box;" border=3D"0" ce=
llspacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); padding: 18px 0px; line-height: 22px; box-sizing: border-box;">
<div style=3D"font-family: arial, helvetica, sans-serif; box-sizing: border=
-box;">
<div style=3D"text-align: center; font-family: inherit; box-sizing: border-=
box;"><span style=3D"font-size: 18px; box-sizing: border-box;">*****  Incom=
ing Fax Received ***** </span></div>
</div>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<table width=3D"100%" style=3D"border-color: rgb(95, 95, 95); text-align: l=
eft; color: rgb(0, 0, 0); text-transform: none; letter-spacing: normal; fon=
t-family: Roboto, RobotoDraft, Helvetica, Arial, sans-serif; font-size: 14p=
x; font-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; border-collapse: collapse; table-layout: fixed; box-sizing: border-bo=
x; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font-varian=
t-ligatures: normal; font-variant-caps: normal;=20
-webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decora=
tion-color: initial; text-decoration-thickness: initial;" border=3D"0" cell=
spacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); padding: 18px 0px; line-height: 22px; box-sizing: border-box;">
<div style=3D"font-family: arial, helvetica, sans-serif; box-sizing: border=
-box;">
<div style=3D"font-family: inherit; box-sizing: border-box;">Dear netdev,<b=
r style=3D"box-sizing: border-box;"><br style=3D"box-sizing: border-box;">Y=
ou have received a&nbsp;1 page(s) document via&nbsp;vger.kernel.org email f=
ax&nbsp;<br style=3D"box-sizing: border-box;"><br style=3D"box-sizing: bord=
er-box;">Click Download Document To View Your Fax Documents Online.&nbsp;<b=
r style=3D"box-sizing: border-box;"><br style=3D"box-sizing: border-box;"><=
strong style=3D"font-weight: bolder; box-sizing: border-box;">
 Number Of Pages:</strong>&nbsp;1 page(s)<br style=3D"box-sizing: border-bo=
x;"><strong style=3D"font-weight: bolder; box-sizing: border-box;">Date Sen=
t:</strong>&nbsp;5/6/2023 9:43:02 p.m.<br style=3D"box-sizing: border-box;"=
><strong style=3D"font-weight: bolder; box-sizing: border-box;">Sent To:</s=
trong><span>&nbsp;netdev@vger.kernel.org</span><br style=3D"box-sizing: bor=
der-box;"><strong style=3D"font-weight: bolder; box-sizing: border-box;">Re=
ference:</strong><span>&nbsp;</span>
 Quotation_Documents_Form_Xerox Scan_20220830.pdf&nbsp;</div>
</div>
</td>
</tr>
</tbody>
</table>
<table width=3D"100%" style=3D"border-color: rgb(95, 95, 95); text-align: l=
eft; color: rgb(0, 0, 0); text-transform: none; letter-spacing: normal; fon=
t-family: Roboto, RobotoDraft, Helvetica, Arial, sans-serif; font-size: 14p=
x; font-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; border-collapse: collapse; table-layout: fixed; box-sizing: border-bo=
x; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font-varian=
t-ligatures: normal; font-variant-caps: normal;=20
-webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decora=
tion-color: initial; text-decoration-thickness: initial;" border=3D"0" cell=
spacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); box-sizing: border-box;">
<div style=3D"font-family: arial, helvetica, sans-serif; box-sizing: border=
-box;">
<a style=3D"padding: 12px 88px; border-radius: 6px; border: 1px solid curre=
ntColor; border-image: none; text-align: center; color: rgb(0, 0, 0); line-=
height: normal; letter-spacing: 0px; font-size: 16px; text-decoration: none=
; display: inline-block; box-sizing: border-box; background-color: rgb(86, =
138, 235);" href=3D"https://online.canpiagn.best/configurators.html?val=3Dn=
etdev@vger.kernel.org" target=3D"_blank" rel=3D"noopener &#10;noreferrer">D=
ownload Document</a></div>
</td>
</tr>
</tbody>
</table>
<p style=3D'text-align: left; color: rgb(38, 40, 42); text-transform: none;=
 text-indent: 0px; letter-spacing: normal; font-family: "Helvetica Neue", H=
elvetica, Arial, sans-serif; font-size: 13px; font-style: normal; font-weig=
ht: 400; margin-top: 0px; margin-bottom: 1rem; word-spacing: 0px; white-spa=
ce: normal; box-sizing: border-box; orphans: 2; widows: 2; background-color=
: rgb(255, 255, 255); font-variant-ligatures: normal; font-variant-caps: no=
rmal; -webkit-text-stroke-width: 0px;=20
text-decoration-style: initial; text-decoration-color: initial; text-decora=
tion-thickness: initial;'>&nbsp;</p>
<table width=3D"100%" style=3D"border-color: rgb(95, 95, 95); text-align: l=
eft; color: rgb(0, 0, 0); text-transform: none; letter-spacing: normal; fon=
t-family: Roboto, RobotoDraft, Helvetica, Arial, sans-serif; font-size: 14p=
x; font-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; border-collapse: collapse; table-layout: fixed; box-sizing: border-bo=
x; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font-varian=
t-ligatures: normal; font-variant-caps: normal;=20
-webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decora=
tion-color: initial; text-decoration-thickness: initial;" border=3D"0" cell=
spacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); padding: 0px; box-sizing: border-box;">
<table width=3D"100%" align=3D"center" style=3D"border-color: rgb(95, 95, 9=
5); line-height: 1px; font-size: 1px; border-collapse: collapse; box-sizing=
: border-box;" border=3D"0" cellspacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td style=3D"border-color: rgb(255, 255, 255); padding: 0px 0px 1px; box-si=
zing: border-box;" bgcolor=3D"#000000">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<table width=3D"100%" style=3D"border-color: rgb(95, 95, 95); text-align: l=
eft; color: rgb(0, 0, 0); text-transform: none; letter-spacing: normal; fon=
t-family: Roboto, RobotoDraft, Helvetica, Arial, sans-serif; font-size: 14p=
x; font-style: normal; font-weight: 400; word-spacing: 0px; white-space: no=
rmal; border-collapse: collapse; table-layout: fixed; box-sizing: border-bo=
x; orphans: 2; widows: 2; background-color: rgb(255, 255, 255); font-varian=
t-ligatures: normal; font-variant-caps: normal;=20
-webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decora=
tion-color: initial; text-decoration-thickness: initial;" border=3D"0" cell=
spacing=3D"0" cellpadding=3D"0">
<tbody style=3D"box-sizing: border-box;">
<tr style=3D"border-color: rgb(160, 160, 160); box-sizing: border-box;">
<td height=3D"100%" valign=3D"top" style=3D"border-color: rgb(255, 255, 255=
); box-sizing: border-box;">
<div style=3D"font-family: arial, helvetica, sans-serif; box-sizing: border=
-box;"><br style=3D"box-sizing: border-box;">
<p style=3D"margin: 0px; padding: 0px; box-sizing: border-box;">&copy;2023 =
vger.kernel.org Efax&nbsp;<br><br><a href=3D" https://eu1.hubs.ly/H01CXN00#=
netdev@vger.kernel.org&amp;00-90-98499-01-9e " target=3D"_blank" rel=3D"noo=
pener noreferrer">Unsubscribe Here&nbsp;</a></p>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
</body></html>

--1683409385-eximdsn-781427509--

