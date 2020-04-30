Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE41C0175
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgD3QGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9C324982;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=CiLOHnpVVSLJQyhYuYHkng4P2M1sc6qBmL1opImcUzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtFWZhE2vizuukFFtkd1jSTT58Y6StLOsN7sM2PljJ3sZLoFKRdqV+eobt5nkKqhr
         px3mEO9wFhFXCnAa9hNX3dWx1lBleBuKrhYSvdm88uWvufh3OK2hLI5z/y1aTFQRZw
         B4Mgha1OX9BHm35kiZ+Qe4M4a+HiJvaAVGOQkf6I=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxG6-LR; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 25/37] docs: networking: convert regulatory.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:20 +0200
Message-Id: <3df26ac762a1a7b3a61a9ae39b49cd67aa09ec21.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{regulatory.txt => regulatory.rst}        | 29 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 19 insertions(+), 13 deletions(-)
 rename Documentation/networking/{regulatory.txt => regulatory.rst} (94%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e63a2cb2e4cb..bc3b04a2edde 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -98,6 +98,7 @@ Contents:
    radiotap-headers
    ray_cs
    rds
+   regulatory
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.rst
similarity index 94%
rename from Documentation/networking/regulatory.txt
rename to Documentation/networking/regulatory.rst
index 381e5b23d61d..8701b91e81ee 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.rst
@@ -1,5 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
 Linux wireless regulatory documentation
----------------------------------------
+=======================================
 
 This document gives a brief review over how the Linux wireless
 regulatory infrastructure works.
@@ -57,7 +60,7 @@ Users can use iw:
 
 http://wireless.kernel.org/en/users/Documentation/iw
 
-An example:
+An example::
 
   # set regulatory domain to "Costa Rica"
   iw reg set CR
@@ -104,9 +107,9 @@ Example code - drivers hinting an alpha2:
 
 This example comes from the zd1211rw device driver. You can start
 by having a mapping of your device's EEPROM country/regulatory
-domain value to a specific alpha2 as follows:
+domain value to a specific alpha2 as follows::
 
-static struct zd_reg_alpha2_map reg_alpha2_map[] = {
+  static struct zd_reg_alpha2_map reg_alpha2_map[] = {
 	{ ZD_REGDOMAIN_FCC, "US" },
 	{ ZD_REGDOMAIN_IC, "CA" },
 	{ ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
@@ -116,10 +119,10 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
 	{ ZD_REGDOMAIN_FRANCE, "FR" },
 
 Then you can define a routine to map your read EEPROM value to an alpha2,
-as follows:
+as follows::
 
-static int zd_reg2alpha2(u8 regdomain, char *alpha2)
-{
+  static int zd_reg2alpha2(u8 regdomain, char *alpha2)
+  {
 	unsigned int i;
 	struct zd_reg_alpha2_map *reg_map;
 		for (i = 0; i < ARRAY_SIZE(reg_alpha2_map); i++) {
@@ -131,12 +134,14 @@ static int zd_reg2alpha2(u8 regdomain, char *alpha2)
 		}
 	}
 	return 1;
-}
+  }
 
 Lastly, you can then hint to the core of your discovered alpha2, if a match
 was found. You need to do this after you have registered your wiphy. You
 are expected to do this during initialization.
 
+::
+
 	r = zd_reg2alpha2(mac->regdomain, alpha2);
 	if (!r)
 		regulatory_hint(hw->wiphy, alpha2);
@@ -156,9 +161,9 @@ call regulatory_hint() with the regulatory domain structure in it.
 Bellow is a simple example, with a regulatory domain cached using the stack.
 Your implementation may vary (read EEPROM cache instead, for example).
 
-Example cache of some regulatory domain
+Example cache of some regulatory domain::
 
-struct ieee80211_regdomain mydriver_jp_regdom = {
+  struct ieee80211_regdomain mydriver_jp_regdom = {
 	.n_reg_rules = 3,
 	.alpha2 =  "JP",
 	//.alpha2 =  "99", /* If I have no alpha2 to map it to */
@@ -173,9 +178,9 @@ struct ieee80211_regdomain mydriver_jp_regdom = {
 			NL80211_RRF_NO_IR|
 			NL80211_RRF_DFS),
 	}
-};
+  };
 
-Then in some part of your code after your wiphy has been registered:
+Then in some part of your code after your wiphy has been registered::
 
 	struct ieee80211_regdomain *rd;
 	int size_of_regd;
diff --git a/MAINTAINERS b/MAINTAINERS
index d525b85a37a0..caab14c5c12b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -193,7 +193,7 @@ W:	https://wireless.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 F:	Documentation/driver-api/80211/cfg80211.rst
-F:	Documentation/networking/regulatory.txt
+F:	Documentation/networking/regulatory.rst
 F:	include/linux/ieee80211.h
 F:	include/net/cfg80211.h
 F:	include/net/ieee80211_radiotap.h
-- 
2.25.4

