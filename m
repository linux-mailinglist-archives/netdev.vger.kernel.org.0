Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2EDEB6DD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJaSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:23:51 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:42022 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbfJaSXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:23:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 0AF5A8384360;
        Thu, 31 Oct 2019 18:23:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1311:1314:1345:1437:1515:1534:1544:1711:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3872:4321:4385:4605:5007:6261:7996:10004:11026:11232:11473:11657:11658:11914:12043:12050:12297:12438:12555:12679:12895:12986:13894:14096:14181:14394:14721:21080:21451:21627:21740:21810:30054:30055,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: plane01_21290db56310d
X-Filterd-Recvd-Size: 4792
Received: from joe-laptop.perches.com (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Thu, 31 Oct 2019 18:23:47 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] hp100: Move 100BaseVG AnyLAN driver to staging
Date:   Thu, 31 Oct 2019 11:23:37 -0700
Message-Id: <4024b52c917975cebde58afc094eed1a107622c2.1572545956.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

100BaseVG AnyLAN hasn't been useful since 1996 or so and even then
didn't sell many devices.  It's unlikely any are still in use.

Move the driver to staging with the intent of removing it altogether
one day.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS                                   | 4 ++--
 drivers/net/ethernet/Kconfig                  | 1 -
 drivers/net/ethernet/Makefile                 | 1 -
 drivers/staging/Kconfig                       | 2 ++
 drivers/staging/Makefile                      | 1 +
 drivers/{net/ethernet => staging}/hp/Kconfig  | 0
 drivers/{net/ethernet => staging}/hp/Makefile | 0
 drivers/{net/ethernet => staging}/hp/hp100.c  | 0
 drivers/{net/ethernet => staging}/hp/hp100.h  | 0
 9 files changed, 5 insertions(+), 4 deletions(-)
 rename drivers/{net/ethernet => staging}/hp/Kconfig (100%)
 rename drivers/{net/ethernet => staging}/hp/Makefile (100%)
 rename drivers/{net/ethernet => staging}/hp/hp100.c (100%)
 rename drivers/{net/ethernet => staging}/hp/hp100.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6c34d..bea725 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7444,8 +7444,8 @@ F:	drivers/platform/x86/tc1100-wmi.c
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 M:	Jaroslav Kysela <perex@perex.cz>
-S:	Maintained
-F:	drivers/net/ethernet/hp/hp100.*
+S:	Obsolete
+F:	drivers/staging/hp/hp100.*
 
 HPET:	High Precision Event Timers driver
 M:	Clemens Ladisch <clemens@ladisch.de>
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index e8e9c16..4ded81 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -78,7 +78,6 @@ source "drivers/net/ethernet/freescale/Kconfig"
 source "drivers/net/ethernet/fujitsu/Kconfig"
 source "drivers/net/ethernet/google/Kconfig"
 source "drivers/net/ethernet/hisilicon/Kconfig"
-source "drivers/net/ethernet/hp/Kconfig"
 source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 05abeb..f8f38d 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_NET_VENDOR_FREESCALE) += freescale/
 obj-$(CONFIG_NET_VENDOR_FUJITSU) += fujitsu/
 obj-$(CONFIG_NET_VENDOR_GOOGLE) += google/
 obj-$(CONFIG_NET_VENDOR_HISILICON) += hisilicon/
-obj-$(CONFIG_NET_VENDOR_HP) += hp/
 obj-$(CONFIG_NET_VENDOR_HUAWEI) += huawei/
 obj-$(CONFIG_NET_VENDOR_IBM) += ibm/
 obj-$(CONFIG_NET_VENDOR_INTEL) += intel/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 6f1fa4..333308 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -125,4 +125,6 @@ source "drivers/staging/exfat/Kconfig"
 
 source "drivers/staging/qlge/Kconfig"
 
+source "drivers/staging/hp/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a90f9b3..e4943c 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_UWB)		+= uwb/
 obj-$(CONFIG_USB_WUSB)		+= wusbcore/
 obj-$(CONFIG_EXFAT_FS)		+= exfat/
 obj-$(CONFIG_QLGE)		+= qlge/
+obj-$(CONFIG_NET_VENDOR_HP)	+= hp/
diff --git a/drivers/net/ethernet/hp/Kconfig b/drivers/staging/hp/Kconfig
similarity index 100%
rename from drivers/net/ethernet/hp/Kconfig
rename to drivers/staging/hp/Kconfig
diff --git a/drivers/net/ethernet/hp/Makefile b/drivers/staging/hp/Makefile
similarity index 100%
rename from drivers/net/ethernet/hp/Makefile
rename to drivers/staging/hp/Makefile
diff --git a/drivers/net/ethernet/hp/hp100.c b/drivers/staging/hp/hp100.c
similarity index 100%
rename from drivers/net/ethernet/hp/hp100.c
rename to drivers/staging/hp/hp100.c
diff --git a/drivers/net/ethernet/hp/hp100.h b/drivers/staging/hp/hp100.h
similarity index 100%
rename from drivers/net/ethernet/hp/hp100.h
rename to drivers/staging/hp/hp100.h
-- 
2.24.0.rc2

