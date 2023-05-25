Return-Path: <netdev+bounces-5420-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC611711361
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB6031C20F4D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08748209A4;
	Thu, 25 May 2023 18:11:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F047B101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:39 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA580D8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038292; x=1716574292;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=PT3Sa6iYxiN2q+wWQMrHB7xxWT17qn7L4PefheSr2JA=;
  b=R3N3tnCPBRxBmhQv29be/42r0mEEmqSTn5bx7Af7FINWIawXIlU8P1OC
   aje27nuZPhhMySdufWM72GcWxvKm2dgTGX27wRMwsldRhTsjJdp1r9AtH
   6VtUAX6AggvMC6y7kTO7+IGLJwDvcmhajvrfZmMrfuk4GDQEQLYOi6Zmr
   teARuZB4FMOe5M5ybJ+yAigMyFZmJpjuJiHUExQSsr9ZS02T4R+y5SYkX
   IQlRI9QcFlnlIHvzAOboEUyrtvITEiHq/FmMAQ/eoQ4QeUKMxCxSdp9f7
   5GuRMzDk/EhXLyUWJzhQ6BqL86lwKhFf0on5zByi0fsBgAkALA2HMUO3O
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="217319855"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:12 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:11 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:28 +0200
Subject: [PATCH iproute2-next v2 8/8] man: dcb-app: clean up a few mistakes
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-8-9f38e688117e@microchip.com>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While referencing the dcb-app manpage, I spotted a few mistakes. Lets
fix them.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 man/man8/dcb-app.8 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
index ecb38591168e..be505a0be308 100644
--- a/man/man8/dcb-app.8
+++ b/man/man8/dcb-app.8
@@ -1,4 +1,4 @@
-.TH DCB-ETS 8 "6 December 2020" "iproute2" "Linux"
+.TH DCB-APP 8 "6 December 2020" "iproute2" "Linux"
 .SH NAME
 dcb-app \- show / manipulate application priority table of
 the DCB (Data Center Bridging) subsystem
@@ -26,7 +26,7 @@ the DCB (Data Center Bridging) subsystem
 .RB "[ " pcp-prio " ]"
 
 .ti -8
-.B dcb ets " { " add " | " del " | " replace " } " dev
+.B dcb app " { " add " | " del " | " replace " } " dev
 .RI DEV
 .RB "[ " default-prio " " \fIPRIO-LIST\fB " ]"
 .RB "[ " ethtype-prio " " \fIET-MAP\fB " ]"
@@ -106,7 +106,7 @@ individual APP 3-tuples through
 .B add
 and
 .B del
-commands. On the other other hand, the command
+commands. On the other hand, the command
 .B replace
 does what one would typically want in this situation--first adds the new
 configuration, and then removes the obsolete one, so that only one
@@ -184,7 +184,7 @@ for details. Keys are DSCP points, values are priorities assigned to
 traffic with matching DSCP. DSCP points can be written either directly as
 numeric values, or using symbolic names specified in
 .B /etc/iproute2/rt_dsfield
-(however note that that file specifies full 8-bit dsfield values, whereas
+(however note that the file specifies full 8-bit dsfield values, whereas
 .B dcb app
 will only use the higher six bits).
 .B dcb app show
@@ -230,7 +230,7 @@ priority 4:
 .P
 # dcb app replace dev eth0 dscp-prio 24:4
 .br
-# dcb app show dev eth0 dscp-prio
+# dcb app -N show dev eth0 dscp-prio
 .br
 dscp-prio 0:0 24:4 48:6
 

-- 
2.34.1


