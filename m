Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDCEA878A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfIDN7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:22 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39229 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729590AbfIDN7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:22 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2019 09:59:20 EDT
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 295FA82180F; Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id C86E482181C;
        Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 3/4] gianfar: cleanup gianfar.h
Date:   Wed,  4 Sep 2019 20:52:21 +0700
Message-Id: <20190904135223.31754-4-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
 <20190904135223.31754-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove now unused macro and structure definitions from gianfar.h that have
accumulated there over time.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/net/ethernet/freescale/gianfar.h | 38 ------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index f058594a67fb..f472a6dbbe6f 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -67,8 +67,6 @@ struct ethtool_rx_list {
 /* Number of bytes to align the rx bufs to */
 #define RXBUF_ALIGNMENT 64
 
-#define PHY_INIT_TIMEOUT 100000
-
 #define DRV_NAME "gfar-enet"
 extern const char gfar_driver_version[];
 
@@ -88,10 +86,6 @@ extern const char gfar_driver_version[];
 #define GFAR_RX_MAX_RING_SIZE   256
 #define GFAR_TX_MAX_RING_SIZE   256
 
-#define GFAR_MAX_FIFO_THRESHOLD 511
-#define GFAR_MAX_FIFO_STARVE	511
-#define GFAR_MAX_FIFO_STARVE_OFF 511
-
 #define FBTHR_SHIFT        24
 #define DEFAULT_RX_LFC_THR  16
 #define DEFAULT_LFC_PTVVAL  4
@@ -109,9 +103,6 @@ extern const char gfar_driver_version[];
 #define DEFAULT_FIFO_TX_THR 0x100
 #define DEFAULT_FIFO_TX_STARVE 0x40
 #define DEFAULT_FIFO_TX_STARVE_OFF 0x80
-#define DEFAULT_BD_STASH 1
-#define DEFAULT_STASH_LENGTH	96
-#define DEFAULT_STASH_INDEX	0
 
 /* The number of Exact Match registers */
 #define GFAR_EM_NUM	15
@@ -139,15 +130,6 @@ extern const char gfar_driver_version[];
 #define DEFAULT_RX_COALESCE 0
 #define DEFAULT_RXCOUNT	0
 
-#define GFAR_SUPPORTED (SUPPORTED_10baseT_Half \
-		| SUPPORTED_10baseT_Full \
-		| SUPPORTED_100baseT_Half \
-		| SUPPORTED_100baseT_Full \
-		| SUPPORTED_Autoneg \
-		| SUPPORTED_MII)
-
-#define GFAR_SUPPORTED_GBIT SUPPORTED_1000baseT_Full
-
 /* TBI register addresses */
 #define MII_TBICON		0x11
 
@@ -185,8 +167,6 @@ extern const char gfar_driver_version[];
 #define ECNTRL_REDUCED_MII_MODE	0x00000004
 #define ECNTRL_SGMII_MODE	0x00000002
 
-#define MRBLR_INIT_SETTINGS	DEFAULT_RX_BUFFER_SIZE
-
 #define MINFLR_INIT_SETTINGS	0x00000040
 
 /* Tqueue control */
@@ -266,12 +246,6 @@ extern const char gfar_driver_version[];
 #define DEFAULT_TXIC mk_ic_value(DEFAULT_TXCOUNT, DEFAULT_TXTIME)
 #define DEFAULT_RXIC mk_ic_value(DEFAULT_RXCOUNT, DEFAULT_RXTIME)
 
-#define skip_bd(bdp, stride, base, ring_size) ({ \
-	typeof(bdp) new_bd = (bdp) + (stride); \
-	(new_bd >= (base) + (ring_size)) ? (new_bd - (ring_size)) : new_bd; })
-
-#define next_bd(bdp, base, ring_size) skip_bd(bdp, 1, base, ring_size)
-
 #define RCTRL_TS_ENABLE 	0x01000000
 #define RCTRL_PAL_MASK		0x001f0000
 #define RCTRL_LFC		0x00004000
@@ -385,11 +359,6 @@ extern const char gfar_driver_version[];
 #define IMASK_RX_DISABLED ((~(IMASK_RX_DEFAULT)) & IMASK_DEFAULT)
 #define IMASK_TX_DISABLED ((~(IMASK_TX_DEFAULT)) & IMASK_DEFAULT)
 
-/* Fifo management */
-#define FIFO_TX_THR_MASK	0x01ff
-#define FIFO_TX_STARVE_MASK	0x01ff
-#define FIFO_TX_STARVE_OFF_MASK	0x01ff
-
 /* Attribute fields */
 
 /* This enables rx snooping for buffers and descriptors */
@@ -1341,13 +1310,6 @@ extern const struct ethtool_ops gfar_ethtool_ops;
 #define RQFCR_PID_PORT_MASK 0xFFFF0000
 #define RQFCR_PID_MAC_MASK 0xFF000000
 
-struct gfar_mask_entry {
-	unsigned int mask; /* The mask value which is valid form start to end */
-	unsigned int start;
-	unsigned int end;
-	unsigned int block; /* Same block values indicate depended entries */
-};
-
 /* Represents a receive filer table entry */
 struct gfar_filer_entry {
 	u32 ctrl;
-- 
2.23.0

