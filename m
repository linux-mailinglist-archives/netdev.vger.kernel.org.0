Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9923A3A9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgHCL5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:41746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgHCL5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04BE1ABF1
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id ADB9C60754; Mon,  3 Aug 2020 13:57:06 +0200 (CEST)
Message-Id: <2ab9b90226d988746429ba1120b589ff53acd3c5.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/7] rename maybe_unused macro to __maybe_unused
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:06 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code consistent with kernel and also makes it a bit more
apparent that it is an attribute.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 amd8111e.c     | 2 +-
 at76c50x-usb.c | 2 +-
 de2104x.c      | 4 ++--
 dsa.c          | 2 +-
 e100.c         | 2 +-
 e1000.c        | 2 +-
 et131x.c       | 2 +-
 ethtool.c      | 6 +++---
 fec.c          | 2 +-
 fec_8xx.c      | 2 +-
 fjes.c         | 2 +-
 ibm_emac.c     | 2 +-
 igb.c          | 2 +-
 internal.h     | 2 +-
 ixgb.c         | 2 +-
 ixgbe.c        | 2 +-
 ixgbevf.c      | 2 +-
 lan78xx.c      | 2 +-
 marvell.c      | 4 ++--
 natsemi.c      | 4 ++--
 realtek.c      | 2 +-
 sfc.c          | 3 ++-
 smsc911x.c     | 2 +-
 stmmac.c       | 4 ++--
 tg3.c          | 4 ++--
 tse.c          | 2 +-
 vioc.c         | 2 +-
 vmxnet3.c      | 2 +-
 28 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/amd8111e.c b/amd8111e.c
index 5a056b3f84ca..175516bd2904 100644
--- a/amd8111e.c
+++ b/amd8111e.c
@@ -152,7 +152,7 @@ typedef enum {
 #define PHY_SPEED_100		0x3
 
 
-int amd8111e_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int amd8111e_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		       struct ethtool_regs *regs)
 {
 
diff --git a/at76c50x-usb.c b/at76c50x-usb.c
index 0121e9886b65..fad41bf5fe25 100644
--- a/at76c50x-usb.c
+++ b/at76c50x-usb.c
@@ -12,7 +12,7 @@ static char *hw_versions[] = {
         "     505AMX",
 };
 
-int at76c50x_usb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int at76c50x_usb_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 			   struct ethtool_regs *regs)
 {
 	u8 version = (u8)(regs->version >> 24);
diff --git a/de2104x.c b/de2104x.c
index cc03533d1548..190422fb2249 100644
--- a/de2104x.c
+++ b/de2104x.c
@@ -111,7 +111,7 @@ print_rx_missed(u32 csr8)
 	}
 }
 
-static void de21040_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 			      struct ethtool_regs *regs)
 {
 	u32 tmp, v, *data = (u32 *)regs->data;
@@ -417,7 +417,7 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 		v & (1<<0) ? "      Jabber disable\n" : "");
 }
 
-static void de21041_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 			      struct ethtool_regs *regs)
 {
 	u32 tmp, v, *data = (u32 *)regs->data;
diff --git a/dsa.c b/dsa.c
index 0071769861c3..65502a899194 100644
--- a/dsa.c
+++ b/dsa.c
@@ -870,7 +870,7 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 #undef FIELD
 #undef REG
 
-int dsa_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int dsa_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	/* DSA per-driver register dump */
diff --git a/e100.c b/e100.c
index 540ae3544faf..fd4bd031a4a6 100644
--- a/e100.c
+++ b/e100.c
@@ -36,7 +36,7 @@
 #define CU_CMD			0x00F0
 #define RU_CMD			0x0007
 
-int e100_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int e100_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/e1000.c b/e1000.c
index 91e5bc14afe5..dbd6eb55a92c 100644
--- a/e1000.c
+++ b/e1000.c
@@ -363,7 +363,7 @@ static enum e1000_mac_type e1000_get_mac_type(u16 device_id)
 	return mac_type;
 }
 
-int e1000_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int e1000_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		    struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/et131x.c b/et131x.c
index 1b0607177e6d..a23f7a27091c 100644
--- a/et131x.c
+++ b/et131x.c
@@ -2,7 +2,7 @@
 #include <string.h>
 #include "internal.h"
 
-int et131x_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int et131x_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		     struct ethtool_regs *regs)
 {
 	u8 version = (u8)(regs->version >> 24);
diff --git a/ethtool.c b/ethtool.c
index 1b99ac91dcbf..0f312bdae2bb 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -366,7 +366,7 @@ static int rxflow_str_to_type(const char *str)
 	return flow_type;
 }
 
-static int do_version(struct cmd_context *ctx maybe_unused)
+static int do_version(struct cmd_context *ctx __maybe_unused)
 {
 	fprintf(stdout,
 		PACKAGE " version " VERSION
@@ -1106,7 +1106,7 @@ nested:
 }
 
 static int dump_eeprom(int geeprom_dump_raw,
-		       struct ethtool_drvinfo *info maybe_unused,
+		       struct ethtool_drvinfo *info __maybe_unused,
 		       struct ethtool_eeprom *ee)
 {
 	if (geeprom_dump_raw) {
@@ -5708,7 +5708,7 @@ static const struct option args[] = {
 	{}
 };
 
-static int show_usage(struct cmd_context *ctx maybe_unused)
+static int show_usage(struct cmd_context *ctx __maybe_unused)
 {
 	int i;
 
diff --git a/fec.c b/fec.c
index 22bc09f982a0..9cb4f8b1d4e1 100644
--- a/fec.c
+++ b/fec.c
@@ -194,7 +194,7 @@ static void fec_dump_reg_v2(int reg, u32 val)
 #undef FIELD
 #undef REG
 
-int fec_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int fec_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	const u32 *data = (u32 *)regs->data;
diff --git a/fec_8xx.c b/fec_8xx.c
index 02ecaef84364..63352fca36b8 100644
--- a/fec_8xx.c
+++ b/fec_8xx.c
@@ -47,7 +47,7 @@ struct fec {
 				(unsigned long)(offsetof(struct fec, x)), \
 				#x, f->x)
 
-int fec_8xx_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int fec_8xx_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		      struct ethtool_regs *regs)
 {
 	struct fec *f = (struct fec *)regs->data;
diff --git a/fjes.c b/fjes.c
index 4c5f6bc70843..05bd24511fb7 100644
--- a/fjes.c
+++ b/fjes.c
@@ -2,7 +2,7 @@
 #include <stdio.h>
 #include "internal.h"
 
-int fjes_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int fjes_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/ibm_emac.c b/ibm_emac.c
index 3259c175a43a..ea01d56f609c 100644
--- a/ibm_emac.c
+++ b/ibm_emac.c
@@ -314,7 +314,7 @@ static void *print_tah_regs(void *buf)
 	return p + 1;
 }
 
-int ibm_emac_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int ibm_emac_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		       struct ethtool_regs *regs)
 {
 	struct emac_ethtool_regs_hdr *hdr =
diff --git a/igb.c b/igb.c
index 89b5cdb5d689..f358f53b74e0 100644
--- a/igb.c
+++ b/igb.c
@@ -88,7 +88,7 @@
 #define E1000_TCTL_RTLC   0x01000000    /* Re-transmit on late collision */
 #define E1000_TCTL_NRTU   0x02000000    /* No Re-transmit on underrun */
 
-int igb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int igb_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/internal.h b/internal.h
index 1c6689a29c81..8ae1efab5b5c 100644
--- a/internal.h
+++ b/internal.h
@@ -26,7 +26,7 @@
 #include "json_writer.h"
 #include "json_print.h"
 
-#define maybe_unused __attribute__((__unused__))
+#define __maybe_unused __attribute__((__unused__))
 
 /* internal for netlink interface */
 #ifdef ETHTOOL_ENABLE_NETLINK
diff --git a/ixgb.c b/ixgb.c
index 7c16c6e76d44..8aec9a9d2258 100644
--- a/ixgb.c
+++ b/ixgb.c
@@ -38,7 +38,7 @@
 #define IXGB_RAH_ASEL_SRC         0x00010000
 #define IXGB_RAH_AV               0x80000000
 
-int ixgb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int ixgb_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/ixgbe.c b/ixgbe.c
index 9754b2ad078f..6d509c87f357 100644
--- a/ixgbe.c
+++ b/ixgbe.c
@@ -168,7 +168,7 @@ ixgbe_get_mac_type(u16 device_id)
 }
 
 int
-ixgbe_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+ixgbe_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/ixgbevf.c b/ixgbevf.c
index 265e0bf740b3..91c2b2cd4f3c 100644
--- a/ixgbevf.c
+++ b/ixgbevf.c
@@ -3,7 +3,7 @@
 #include "internal.h"
 
 int
-ixgbevf_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+ixgbevf_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
diff --git a/lan78xx.c b/lan78xx.c
index 46ade1c417f9..75ee0487d5fc 100644
--- a/lan78xx.c
+++ b/lan78xx.c
@@ -2,7 +2,7 @@
 #include <string.h>
 #include "internal.h"
 
-int lan78xx_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int lan78xx_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		      struct ethtool_regs *regs)
 {
 	unsigned int *lan78xx_reg = (unsigned int *)regs->data;
diff --git a/marvell.c b/marvell.c
index 9e5440d73c12..8afb150327a3 100644
--- a/marvell.c
+++ b/marvell.c
@@ -259,7 +259,7 @@ static void dump_control(u8 *r)
 	printf("General Purpose  I/O             0x%08X\n", *(u32 *) (r + 0x15c));
 }
 
-int skge_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int skge_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	const u32 *r = (const u32 *) regs->data;
@@ -380,7 +380,7 @@ static void dump_prefetch(const char *name, const void *r)
 	}
 }
 
-int sky2_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int sky2_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	const u16 *r16 = (const u16 *) regs->data;
diff --git a/natsemi.c b/natsemi.c
index ce82c426c178..0af465959cbc 100644
--- a/natsemi.c
+++ b/natsemi.c
@@ -323,7 +323,7 @@ static void __print_intr(int d, int intr, const char *name,
 } while (0)
 
 int
-natsemi_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+natsemi_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	u32 *data = (u32 *)regs->data;
@@ -964,7 +964,7 @@ natsemi_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 }
 
 int
-natsemi_dump_eeprom(struct ethtool_drvinfo *info maybe_unused,
+natsemi_dump_eeprom(struct ethtool_drvinfo *info __maybe_unused,
 		    struct ethtool_eeprom *ee)
 {
 	int i;
diff --git a/realtek.c b/realtek.c
index d10cfd41dc95..ee0c6119dafa 100644
--- a/realtek.c
+++ b/realtek.c
@@ -241,7 +241,7 @@ print_intr_bits(u16 mask)
 }
 
 int
-realtek_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+realtek_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	u32 *data = (u32 *) regs->data;
diff --git a/sfc.c b/sfc.c
index f56243d449ec..340800ee0fa0 100644
--- a/sfc.c
+++ b/sfc.c
@@ -3890,7 +3890,8 @@ print_complex_table(unsigned revision, const struct efx_nic_reg_table *table,
 }
 
 int
-sfc_dump_regs(struct ethtool_drvinfo *info maybe_unused, struct ethtool_regs *regs)
+sfc_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+	      struct ethtool_regs *regs)
 {
 	const struct efx_nic_reg *reg;
 	const struct efx_nic_reg_table *table;
diff --git a/smsc911x.c b/smsc911x.c
index bafee21485cf..b64350460451 100644
--- a/smsc911x.c
+++ b/smsc911x.c
@@ -2,7 +2,7 @@
 #include <string.h>
 #include "internal.h"
 
-int smsc911x_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int smsc911x_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		       struct ethtool_regs *regs)
 {
 	unsigned int *smsc_reg = (unsigned int *)regs->data;
diff --git a/stmmac.c b/stmmac.c
index 98d905835e16..58471200cd80 100644
--- a/stmmac.c
+++ b/stmmac.c
@@ -18,7 +18,7 @@
 #define GMAC_REG_NUM		55
 #define GMAC_DMA_REG_NUM	23
 
-int st_mac100_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int st_mac100_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 			struct ethtool_regs *regs)
 {
 	int i;
@@ -51,7 +51,7 @@ int st_mac100_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 	return 0;
 }
 
-int st_gmac_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int st_gmac_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		      struct ethtool_regs *regs)
 {
 	int i;
diff --git a/tg3.c b/tg3.c
index 8698391f63ea..ac73b33ae4e3 100644
--- a/tg3.c
+++ b/tg3.c
@@ -4,7 +4,7 @@
 
 #define TG3_MAGIC 0x669955aa
 
-int tg3_dump_eeprom(struct ethtool_drvinfo *info maybe_unused,
+int tg3_dump_eeprom(struct ethtool_drvinfo *info __maybe_unused,
 		    struct ethtool_eeprom *ee)
 {
 	int i;
@@ -23,7 +23,7 @@ int tg3_dump_eeprom(struct ethtool_drvinfo *info maybe_unused,
 	return 0;
 }
 
-int tg3_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int tg3_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	int i;
diff --git a/tse.c b/tse.c
index e5241ee4c98e..fb00d218ab8a 100644
--- a/tse.c
+++ b/tse.c
@@ -25,7 +25,7 @@ bitset(u32 val, int bit)
 	return 0;
 }
 
-int altera_tse_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int altera_tse_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 			 struct ethtool_regs *regs)
 {
 	int i;
diff --git a/vioc.c b/vioc.c
index ef163ab499f0..c04a6dc092f9 100644
--- a/vioc.c
+++ b/vioc.c
@@ -11,7 +11,7 @@ struct regs_line {
 
 #define VIOC_REGS_LINE_SIZE	sizeof(struct regs_line)
 
-int vioc_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+int vioc_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		   struct ethtool_regs *regs)
 {
 	unsigned int	i;
diff --git a/vmxnet3.c b/vmxnet3.c
index c97214511e93..68726825a8ca 100644
--- a/vmxnet3.c
+++ b/vmxnet3.c
@@ -3,7 +3,7 @@
 #include "internal.h"
 
 int
-vmxnet3_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+vmxnet3_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
-- 
2.28.0

