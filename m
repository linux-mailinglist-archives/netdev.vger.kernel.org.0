Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB44EF90A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 19:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350206AbiDARj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 13:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350210AbiDARj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 13:39:27 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2959720DB07;
        Fri,  1 Apr 2022 10:37:37 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KVS6l5bgGz9sRy;
        Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cMdvPpaRRqA1; Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KVS6l4grQz9sRx;
        Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8B90B8B87E;
        Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id R0zb54Fhn4rx; Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.82])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 39C6C8B879;
        Fri,  1 Apr 2022 19:37:35 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 231HbOLg665604
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 1 Apr 2022 19:37:24 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 231HbLoC665601;
        Fri, 1 Apr 2022 19:37:21 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Geoff Levand <geoff@infradead.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: Prepare cleanup of powerpc's asm/prom.h
Date:   Fri,  1 Apr 2022 19:37:21 +0200
Message-Id: <b3e4ef935b0c20e0bf2054505c0f0a26f6e831bb.1648833425.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1648834640; l=4676; s=20211009; h=from:subject:message-id; bh=jl6LYjsEx9n7ujbs28rxMUGTFS2Ufwsf4HrsXVi8cQ8=; b=fuzhCyZSyHHY+dL2GY4yBHOSeCS+NQUMtkR16HooOTRLCr39XiwP7UIWvtVRcN4kEX59Zxm6NbKm m22unQn0C5HZVso0lQcHGkpbZg4Us85A9mGfZlOro3rh4b5aee9/
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

powerpc's asm/prom.h brings some headers that it doesn't
need itself.

In order to clean it up, first add missing headers in
users of asm/prom.h

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/net/ethernet/apple/bmac.c                | 2 +-
 drivers/net/ethernet/apple/mace.c                | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c     | 2 ++
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c | 1 +
 drivers/net/ethernet/ibm/ehea/ehea.h             | 1 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c        | 2 ++
 drivers/net/ethernet/ibm/ibmvnic.c               | 1 +
 drivers/net/ethernet/sun/sungem.c                | 1 -
 drivers/net/ethernet/toshiba/spider_net.c        | 1 +
 9 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 4d2ba30c2fbd..3843e8fdcdde 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -25,7 +25,7 @@
 #include <linux/ethtool.h>
 #include <linux/slab.h>
 #include <linux/pgtable.h>
-#include <asm/prom.h>
+
 #include <asm/dbdma.h>
 #include <asm/io.h>
 #include <asm/page.h>
diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index 6f8c91eb1263..97f96d30d9b3 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -20,7 +20,7 @@
 #include <linux/bitrev.h>
 #include <linux/slab.h>
 #include <linux/pgtable.h>
-#include <asm/prom.h>
+
 #include <asm/dbdma.h>
 #include <asm/io.h>
 #include <asm/macio.h>
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index be0bd4b44926..5ddb769bdfb4 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -29,7 +29,9 @@
 #include <linux/crc32.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index b5497e308302..f85b5e81dfc1 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
+#include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <asm/io.h>
 #include <asm/mpc52xx.h>
diff --git a/drivers/net/ethernet/ibm/ehea/ehea.h b/drivers/net/ethernet/ibm/ehea/ehea.h
index b140835d4c23..208c440a602b 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea.h
+++ b/drivers/net/ethernet/ibm/ehea/ehea.h
@@ -19,6 +19,7 @@
 #include <linux/ethtool.h>
 #include <linux/vmalloc.h>
 #include <linux/if_vlan.h>
+#include <linux/platform_device.h>
 
 #include <asm/ibmebus.h>
 #include <asm/io.h>
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index bad94e4d50f4..8ce3348edf08 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -29,6 +29,8 @@
 #include <asm/kexec.h>
 #include <linux/mutex.h>
 #include <linux/prefetch.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <net/ip.h>
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 77683909ca3d..309d97d28fb1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -53,6 +53,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/kthread.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 036856102c50..45bd89153de2 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -52,7 +52,6 @@
 #endif
 
 #ifdef CONFIG_PPC_PMAC
-#include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #endif
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index f47b8358669d..eeee4f7ae444 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -35,6 +35,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
+#include <linux/of.h>
 #include <net/checksum.h>
 
 #include "spider_net.h"
-- 
2.35.1

