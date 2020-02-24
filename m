Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D976A16A0B6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBXIxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgBXIx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:53:29 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A1720866;
        Mon, 24 Feb 2020 08:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534407;
        bh=RoCQdDmy4liLgvBwzNfGejkGcTEeCehnyk0UjHmagdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIIgna+SnULJEasT61/O0GpSaKFHcXRluSAdreN60StjYJTcJL86yDb8fPp4YniHr
         dUCN0USO9ZuIW4aFUJ4cKCdE9+97wKCyWHHFRuxViNi7BBtholaF6/yfhNw46FmmIQ
         vBeetjIK98E8Yy9+Zg3D6ImaqJbOEh3JAYMMGTdk=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v1 03/18] net/3com: Delete driver and module versions from 3com drivers
Date:   Mon, 24 Feb 2020 10:52:56 +0200
Message-Id: <20200224085311.460338-4-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to mislead users by providing different versions for
driver, ethtool and modules. Delete driver assignments and let use
the default one.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/3com/3c509.c    |  8 +-------
 drivers/net/ethernet/3com/3c515.c    | 16 +---------------
 drivers/net/ethernet/3com/3c589_cs.c |  2 --
 drivers/net/ethernet/3com/typhoon.c  |  1 -
 4 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 8cafd06ff0c4..b762176a1406 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -60,8 +60,6 @@
 */

 #define DRV_NAME	"3c509"
-#define DRV_VERSION	"1.20"
-#define DRV_RELDATE	"04Feb2008"

 /* A few values that may be tweaked. */

@@ -87,13 +85,12 @@
 #include <linux/device.h>
 #include <linux/eisa.h>
 #include <linux/bitops.h>
+#include <linux/vermagic.h>

 #include <linux/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>

-static char version[] = DRV_NAME ".c:" DRV_VERSION " " DRV_RELDATE " becker@scyld.com\n";
-
 #ifdef EL3_DEBUG
 static int el3_debug = EL3_DEBUG;
 #else
@@ -547,8 +544,6 @@ static int el3_common_init(struct net_device *dev)
 	       dev->name, dev->base_addr, if_names[(dev->if_port & 0x03)],
 	       dev->dev_addr, dev->irq);

-	if (el3_debug > 0)
-		pr_info("%s", version);
 	return 0;

 }
@@ -1143,7 +1138,6 @@ el3_netdev_set_ecmd(struct net_device *dev,
 static void el3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }

 static int el3_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 1e233e2f0a5a..90312fcd6319 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -22,12 +22,8 @@

 */

+#include <linux/vermagic.h>
 #define DRV_NAME		"3c515"
-#define DRV_VERSION		"0.99t-ac"
-#define DRV_RELDATE		"28-Oct-2002"
-
-static char *version =
-DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " becker@scyld.com and others\n";

 #define CORKSCREW 1

@@ -84,7 +80,6 @@ static int max_interrupt_work = 20;
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("3Com 3c515 Corkscrew driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);

 /* "Knobs" for adjusting internal parameters. */
 /* Put out somewhat more debugging messages. (0 - no msg, 1 minimal msgs). */
@@ -418,8 +413,6 @@ int init_module(void)
 	int found = 0;
 	if (debug >= 0)
 		corkscrew_debug = debug;
-	if (corkscrew_debug)
-		pr_debug("%s", version);
 	while (corkscrew_scan(-1))
 		found++;
 	return found ? 0 : -ENODEV;
@@ -429,16 +422,10 @@ int init_module(void)
 struct net_device *tc515_probe(int unit)
 {
 	struct net_device *dev = corkscrew_scan(unit);
-	static int printed;

 	if (!dev)
 		return ERR_PTR(-ENODEV);

-	if (corkscrew_debug > 0 && !printed) {
-		printed = 1;
-		pr_debug("%s", version);
-	}
-
 	return dev;
 }
 #endif				/* not MODULE */
@@ -1540,7 +1527,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "ISA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index d47cde6c5f08..09816e84314d 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"3c589_cs"
-#define DRV_VERSION	"1.162-ac"

 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -482,7 +481,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 14fce6658106..4383ee615793 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -127,7 +127,6 @@ static const int multicast_filter_limit = 32;
 #include "typhoon.h"

 MODULE_AUTHOR("David Dillow <dave@thedillows.org>");
-MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_NAME);
 MODULE_DESCRIPTION("3Com Typhoon Family (3C990, 3CR990, and variants)");
--
2.24.1

