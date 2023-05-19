Return-Path: <netdev+bounces-3864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9043709452
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8296E1C20A79
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5EA6AA4;
	Fri, 19 May 2023 09:59:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCBE5692
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:59:22 +0000 (UTC)
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 May 2023 02:59:07 PDT
Received: from alimail71.intl.sendcloud.org (alimail71.intl.sendcloud.org [161.117.180.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6562F10D
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rtfing.com;
 i=@rtfing.com; q=dns/txt; s=mail; t=1684490044; h=from : reply-to : to
 : subject : content-type : date : message-id : list-unsubscribe :
 from; bh=7l8k/XwJHQPQc2gpqm3xAumEw64oUkqs9lQZHm3aVKo=;
 b=b6cjUdmve0af3zRSPMQJrDO+bR8wmOp5JP1ETntHBCJ6k4M03Ia8LgufYb9ZX6i86zacJ
 TPv8icEsZTPT3kQejeyA1tVlVAMKeeWDmR4SvV+E4UXyH+EcH/ONGD7oUox3z0GcKfMMOgG
 ENSrXXCeXPiGlLgYXspxm5PAFR2PoDs=
Received: from localhost (Unknown [127.0.0.1])         by SendCloud Inbound Server with ESMTPA id 3D477E57-2F35-4A87-B849-A02C6C988A4B.1         envelope-from <stone.5344409@rtfing.com> (authenticated bits=0); Fri, 19 May 2023 17:54:04 +0800
From: "5G Router" <stone.5344409@rtfing.com>
Reply-To: stone@yuncore.com.cn
To: netdev@vger.kernel.org
Subject: =?utf-8?q?AX3000__5G_Router_VPN?=
Content-Type: multipart/mixed; boundary="zK3R5saGV3=_wtwcIcLsk2icCxwhK5UVlL"
Date: Fri, 19 May 2023 17:54:03 +0800
X-SENDCLOUD-UUID: 1684490044492_103735_18638_3404.sg-10_1_253_26-inbound0$netdev@vger.kernel.org
X-SENDCLOUD-LOG: 1684490044492_103735_18638_3404.sg-10_1_253_26-inbound0$netdev@vger.kernel.org#netdev@vger.kernel.org#790230#103735#0#
X-SENDCLOUD-LOG-NEW: MTY4NDQ5MDA0NDQ5Ml8xMDM3MzVfMTg2MzhfMzQwNC5zZy0xMF8xXzI1M18yNi1pbmJvdW5kMCRuZXRkZXZAdmdlci5rZXJuZWwub3JnI25ldGRldkB2Z2VyLmtlcm5lbC5vcmcjNzkwMjMwIzEwMzczNSMwIw==
Message-ID: <1684490044492_103735_18638_3404.sg-10_1_253_26-inbound0@rtfing.com>
List-Unsubscribe: <https://track2.sendcloud.net/track/unsubscribe.do?p=eyJ1c2VyX2lkIjogMTAzNzM1LCAidGFza19pZCI6ICIiLCAiZW1haWxfaWQiOiAiMTY4NDQ5MDA0NDQ5Ml8xMDM3MzVfMTg2MzhfMzQwNC5zZy0xMF8xXzI1M18yNi1pbmJvdW5kMCRuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgInNpZ24iOiAiMzBkNDQwYTg5NjBlMzg4NGVlMTg2NzZiOWZiYmI3YzYiLCAidXNlcl9oZWFkZXJzIjoge30sICJsYWJlbCI6IDAsICJ0cmFja19kb21haW4iOiAidHJhY2syLnNlbmRjbG91ZC5uZXQiLCAicmVhbF90eXBlIjogIiIsICJuZXRlYXNlIjogImZhbHNlIiwgIm91dF9pcCI6ICIxNjEuMTE3LjE4MC4xNCIsICJjb250ZW50X3R5cGUiOiAiIiwgInJlY2VpdmVyIjogIm5ldGRldkB2Z2VyLmtlcm5lbC5vcmciLCAibWFpbGxpc3RfaWQiOiAwLCAib3ZlcnNlYXMiOiAiIiwgImNhdGVnb3J5X2lkIjogNzkwMjMwLCAicGFnZV9pZCI6IC0xfQ%3D%3D>,<mailto:0_790230_1684490044492_103735_18638_3404.sg-10_1_253_26-inbound0@rtfing.com>
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_IMAGE_ONLY_16,
	HTML_IMAGE_RATIO_04,HTML_MESSAGE,MIME_HEADER_CTYPE_ONLY,MIME_HTML_ONLY,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_REMOTE_IMAGE,
	T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>


--zK3R5saGV3=_wtwcIcLsk2icCxwhK5UVlL
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64
Content-Disposition: inline

PEhUTUw+PEhFQUQ+DQo8TUVUQSBodHRwLWVxdWl2PSJDb250ZW50LVR5cGUiIGNvbnRlbnQ9InRl
eHQvaHRtbDsgY2hhcnNldD11dGYtOCI+IA0KPE1FVEEgbmFtZT0iR0VORVJBVE9SIiBjb250ZW50
PSJNU0hUTUwgMTEuMDAuMTA1NzAuMTAwMSI+PC9IRUFEPiANCjxCT0RZIHN0eWxlPSJjb2xvcjog
cmdiKDAsIDAsIDApOyBsaW5lLWhlaWdodDogMS41OyBmb250LWZhbWlseTogQ2FsaWJyaTsgZm9u
dC1zaXplOiAxMnB0OyI+DQo8RElWPiZuYnNwOw0KPERJVj5EZWFyJm5ic3A7IERpcmVjdG9yICw8
L0RJVj4NCjxESVY+PEJSPjwvRElWPg0KPERJVj5OZXcgcmVsZWFzZWQgNUcgUm91dGVyIC48QlI+
PC9ESVY+DQo8T0w+DQogIDxMST48U1RST05HPk1USyBBWDE4MDAgL0lQUTUwMTggQVgzMDAwPC9T
VFJPTkc+PC9MST48U1RST05HPjwvU1RST05HPiAgICAgDQogIDxMST48U1RST05HPlN1cHBvcnRz
IFZQTjwvU1RST05HPjwvTEk+PFNUUk9ORz48L1NUUk9ORz4gICAgIA0KICA8TEk+PFNUUk9ORz5T
dXBwb3J0cyZuYnNwOyBPcGVud3J0PC9TVFJPTkc+PC9MST48U1RST05HPjwvU1RST05HPiAgICAg
DQogIDxMST48U1RST05HPlN1cHBvcnRzIElQVjQvSVBWNjwvU1RST05HPjwvTEk+PFNUUk9ORz48
L1NUUk9ORz4gICAgIA0KICA8TEk+PFNUUk9ORz5TdXBwb3J0cyZuYnNwOyBTZWFtbGVzcyBSb2Ft
aW5nPC9TVFJPTkc+PC9MST48U1RST05HPjwvU1RST05HPiAgICAgDQoNCiAgPExJPjxTVFJPTkc+
U3VwcG9ydCZuYnNwOyBSSjExPC9TVFJPTkc+PC9MST48L09MPjxTVFJPTkc+PElNRyB3aWR0aD0i
MTczIiANCmhlaWdodD0iMjkyIiBhbGlnbj0iYmFzZWxpbmUiIGFsdD0iIiBzcmM9Imh0dHBzOi8v
eG52Y3d0LmNvbS8yMDIzMDUxOS8xODE5NV8yZDQ5NWJhMWI5ZjkyOGFlN2Y5NzdiOWMwOTkxNzc4
ZS5qcGciIA0KYm9yZGVyPSIwIiBoc3BhY2U9IjAiPjwvU1RST05HPiANCjxESVY+U2FtcGxlIGlz
IGF2YWlsYWJsZSAsaWYgeW91IGhhdmUgYW55IGludGVyZXN0cyAscGxzIGxldCBtZSBrbm93IC48
L0RJVj4NCjxESVY+PEJSPjwvRElWPg0KPERJVj5UaGFua3M8L0RJVj4NCjxESVY+U3RvbmU8QlI+
PC9ESVY+PC9ESVY+DQo8RElWPiZuYnNwOzwvRElWPg0KPERJVj4mbmJzcDs8L0RJVj48aW1nIHNy
Yz0iaHR0cHM6Ly9yNHNkdG4uY29tLzE4MTk1L2Q0NzEzMWVlMDVmMGE2MjU0ZWIvMjgzLnBuZyIg
IHN0eWxlPSJib3JkZXI6MDsgd2lkdGg6MTsgaGVpZ2h0OjE7IHdpZHRoPSIxIiBoZWlnaHQ9IjEi
IG92ZXJmbG93OmhpZGRlbjsiIGFsdD0iIiAvPjwvQk9EWT48L0hUTUw+DQo=

--zK3R5saGV3=_wtwcIcLsk2icCxwhK5UVlL--




