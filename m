Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977BD8323F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfHFNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:06:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45073 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:06:39 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 462vzK5DRfz1rFDY;
        Tue,  6 Aug 2019 15:06:37 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 462vzK4V1gz1qqkQ;
        Tue,  6 Aug 2019 15:06:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id dNwr-jq4Roe4; Tue,  6 Aug 2019 15:06:34 +0200 (CEST)
X-Auth-Info: IyVvSdajA7h0DycARFjSsP+1HCH2qGVUEDITtLokFow=
Received: from localhost.localdomain (cst-prg-69-96.cust.vodafone.cz [46.135.69.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Aug 2019 15:06:34 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 2/3] net: dsa: ksz: Merge ksz_priv.h into ksz_common.h
Date:   Tue,  6 Aug 2019 15:06:08 +0200
Message-Id: <20190806130609.29686-2-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806130609.29686-1-marex@denx.de>
References: <20190806130609.29686-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the two headers into one, no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     |   1 -
 drivers/net/dsa/microchip/ksz8795_spi.c |   1 -
 drivers/net/dsa/microchip/ksz9477.c     |   1 -
 drivers/net/dsa/microchip/ksz9477_spi.c |   1 -
 drivers/net/dsa/microchip/ksz_common.c  |   1 -
 drivers/net/dsa/microchip/ksz_common.h  | 144 ++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_priv.h    | 156 ------------------------
 7 files changed, 144 insertions(+), 161 deletions(-)
 delete mode 100644 drivers/net/dsa/microchip/ksz_priv.h

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ae80b3c6dea2..a23d3ffdf0c4 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -18,7 +18,6 @@
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
-#include "ksz_priv.h"
 #include "ksz_common.h"
 #include "ksz8795_reg.h"
 
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 50aa0d24effb..d0f8153e86b7 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -14,7 +14,6 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
-#include "ksz_priv.h"
 #include "ksz_common.h"
 
 #define SPI_ADDR_SHIFT			12
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a8c97f7a79b7..187be42de5f1 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -14,7 +14,6 @@
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
-#include "ksz_priv.h"
 #include "ksz9477_reg.h"
 #include "ksz_common.h"
 
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 5a9e27b337a8..a226b389e12d 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -13,7 +13,6 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
-#include "ksz_priv.h"
 #include "ksz_common.h"
 
 #define SPI_ADDR_SHIFT			24
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a1e6e560fde8..b45c7b972cec 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -18,7 +18,6 @@
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
-#include "ksz_priv.h"
 #include "ksz_common.h"
 
 void ksz_update_port_member(struct ksz_device *dev, int port)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 9f9ff0fb3b53..c44a8d23d973 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -7,7 +7,151 @@
 #ifndef __KSZ_COMMON_H
 #define __KSZ_COMMON_H
 
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/phy.h>
 #include <linux/regmap.h>
+#include <net/dsa.h>
+
+struct vlan_table {
+	u32 table[3];
+};
+
+struct ksz_port_mib {
+	struct mutex cnt_mutex;		/* structure access */
+	u8 cnt_ptr;
+	u64 *counters;
+};
+
+struct ksz_port {
+	u16 member;
+	u16 vid_member;
+	int stp_state;
+	struct phy_device phydev;
+
+	u32 on:1;			/* port is not disabled by hardware */
+	u32 phy:1;			/* port has a PHY */
+	u32 fiber:1;			/* port is fiber */
+	u32 sgmii:1;			/* port is SGMII */
+	u32 force:1;
+	u32 read:1;			/* read MIB counters in background */
+	u32 freeze:1;			/* MIB counter freeze is enabled */
+
+	struct ksz_port_mib mib;
+};
+
+struct ksz_device {
+	struct dsa_switch *ds;
+	struct ksz_platform_data *pdata;
+	const char *name;
+
+	struct mutex dev_mutex;		/* device access */
+	struct mutex stats_mutex;	/* status access */
+	struct mutex alu_mutex;		/* ALU access */
+	struct mutex vlan_mutex;	/* vlan access */
+	const struct ksz_dev_ops *dev_ops;
+
+	struct device *dev;
+	struct regmap *regmap[3];
+
+	void *priv;
+
+	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
+
+	/* chip specific data */
+	u32 chip_id;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_port;			/* port connected to CPU */
+	int cpu_ports;			/* port bitmap can be cpu port */
+	int phy_port_cnt;
+	int port_cnt;
+	int reg_mib_cnt;
+	int mib_cnt;
+	int mib_port_cnt;
+	int last_port;			/* ports after that not used */
+	phy_interface_t interface;
+	u32 regs_size;
+	bool phy_errata_9477;
+	bool synclko_125;
+
+	struct vlan_table *vlan_cache;
+
+	struct ksz_port *ports;
+	struct timer_list mib_read_timer;
+	struct work_struct mib_read;
+	unsigned long mib_read_interval;
+	u16 br_member;
+	u16 member;
+	u16 live_ports;
+	u16 on_ports;			/* ports enabled by DSA */
+	u16 rx_ports;
+	u16 tx_ports;
+	u16 mirror_rx;
+	u16 mirror_tx;
+	u32 features;			/* chip specific features */
+	u32 overrides;			/* chip functions set by user */
+	u16 host_mask;
+	u16 port_mask;
+};
+
+struct alu_struct {
+	/* entry 1 */
+	u8	is_static:1;
+	u8	is_src_filter:1;
+	u8	is_dst_filter:1;
+	u8	prio_age:3;
+	u32	_reserv_0_1:23;
+	u8	mstp:3;
+	/* entry 2 */
+	u8	is_override:1;
+	u8	is_use_fid:1;
+	u32	_reserv_1_1:23;
+	u8	port_forward:7;
+	/* entry 3 & 4*/
+	u32	_reserv_2_1:9;
+	u8	fid:7;
+	u8	mac[ETH_ALEN];
+};
+
+struct ksz_dev_ops {
+	u32 (*get_port_addr)(int port, int offset);
+	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
+	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
+	void (*phy_setup)(struct ksz_device *dev, int port,
+			  struct phy_device *phy);
+	void (*port_cleanup)(struct ksz_device *dev, int port);
+	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
+	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
+	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
+	int (*r_dyn_mac_table)(struct ksz_device *dev, u16 addr, u8 *mac_addr,
+			       u8 *fid, u8 *src_port, u8 *timestamp,
+			       u16 *entries);
+	int (*r_sta_mac_table)(struct ksz_device *dev, u16 addr,
+			       struct alu_struct *alu);
+	void (*w_sta_mac_table)(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu);
+	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
+			  u64 *cnt);
+	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
+			  u64 *dropped, u64 *cnt);
+	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
+	void (*port_init_cnt)(struct ksz_device *dev, int port);
+	int (*shutdown)(struct ksz_device *dev);
+	int (*detect)(struct ksz_device *dev);
+	int (*init)(struct ksz_device *dev);
+	void (*exit)(struct ksz_device *dev);
+};
+
+struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
+int ksz_switch_register(struct ksz_device *dev,
+			const struct ksz_dev_ops *ops);
+void ksz_switch_remove(struct ksz_device *dev);
+
+int ksz8795_switch_register(struct ksz_device *dev);
+int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
deleted file mode 100644
index 44c16aaf775c..000000000000
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ /dev/null
@@ -1,156 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
- * Microchip KSZ series switch common definitions
- *
- * Copyright (C) 2017-2019 Microchip Technology Inc.
- */
-
-#ifndef __KSZ_PRIV_H
-#define __KSZ_PRIV_H
-
-#include <linux/kernel.h>
-#include <linux/mutex.h>
-#include <linux/phy.h>
-#include <linux/etherdevice.h>
-#include <net/dsa.h>
-
-struct vlan_table {
-	u32 table[3];
-};
-
-struct ksz_port_mib {
-	struct mutex cnt_mutex;		/* structure access */
-	u8 cnt_ptr;
-	u64 *counters;
-};
-
-struct ksz_port {
-	u16 member;
-	u16 vid_member;
-	int stp_state;
-	struct phy_device phydev;
-
-	u32 on:1;			/* port is not disabled by hardware */
-	u32 phy:1;			/* port has a PHY */
-	u32 fiber:1;			/* port is fiber */
-	u32 sgmii:1;			/* port is SGMII */
-	u32 force:1;
-	u32 read:1;			/* read MIB counters in background */
-	u32 freeze:1;			/* MIB counter freeze is enabled */
-
-	struct ksz_port_mib mib;
-};
-
-struct ksz_device {
-	struct dsa_switch *ds;
-	struct ksz_platform_data *pdata;
-	const char *name;
-
-	struct mutex dev_mutex;		/* device access */
-	struct mutex stats_mutex;	/* status access */
-	struct mutex alu_mutex;		/* ALU access */
-	struct mutex vlan_mutex;	/* vlan access */
-	const struct ksz_dev_ops *dev_ops;
-
-	struct device *dev;
-	struct regmap *regmap[3];
-
-	void *priv;
-
-	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
-
-	/* chip specific data */
-	u32 chip_id;
-	int num_vlans;
-	int num_alus;
-	int num_statics;
-	int cpu_port;			/* port connected to CPU */
-	int cpu_ports;			/* port bitmap can be cpu port */
-	int phy_port_cnt;
-	int port_cnt;
-	int reg_mib_cnt;
-	int mib_cnt;
-	int mib_port_cnt;
-	int last_port;			/* ports after that not used */
-	phy_interface_t interface;
-	u32 regs_size;
-	bool phy_errata_9477;
-	bool synclko_125;
-
-	struct vlan_table *vlan_cache;
-
-	struct ksz_port *ports;
-	struct timer_list mib_read_timer;
-	struct work_struct mib_read;
-	unsigned long mib_read_interval;
-	u16 br_member;
-	u16 member;
-	u16 live_ports;
-	u16 on_ports;			/* ports enabled by DSA */
-	u16 rx_ports;
-	u16 tx_ports;
-	u16 mirror_rx;
-	u16 mirror_tx;
-	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
-	u16 host_mask;
-	u16 port_mask;
-};
-
-struct alu_struct {
-	/* entry 1 */
-	u8	is_static:1;
-	u8	is_src_filter:1;
-	u8	is_dst_filter:1;
-	u8	prio_age:3;
-	u32	_reserv_0_1:23;
-	u8	mstp:3;
-	/* entry 2 */
-	u8	is_override:1;
-	u8	is_use_fid:1;
-	u32	_reserv_1_1:23;
-	u8	port_forward:7;
-	/* entry 3 & 4*/
-	u32	_reserv_2_1:9;
-	u8	fid:7;
-	u8	mac[ETH_ALEN];
-};
-
-struct ksz_dev_ops {
-	u32 (*get_port_addr)(int port, int offset);
-	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
-	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
-	void (*phy_setup)(struct ksz_device *dev, int port,
-			  struct phy_device *phy);
-	void (*port_cleanup)(struct ksz_device *dev, int port);
-	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
-	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
-	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
-	int (*r_dyn_mac_table)(struct ksz_device *dev, u16 addr, u8 *mac_addr,
-			       u8 *fid, u8 *src_port, u8 *timestamp,
-			       u16 *entries);
-	int (*r_sta_mac_table)(struct ksz_device *dev, u16 addr,
-			       struct alu_struct *alu);
-	void (*w_sta_mac_table)(struct ksz_device *dev, u16 addr,
-				struct alu_struct *alu);
-	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
-			  u64 *cnt);
-	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
-			  u64 *dropped, u64 *cnt);
-	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
-	void (*port_init_cnt)(struct ksz_device *dev, int port);
-	int (*shutdown)(struct ksz_device *dev);
-	int (*detect)(struct ksz_device *dev);
-	int (*init)(struct ksz_device *dev);
-	void (*exit)(struct ksz_device *dev);
-};
-
-struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
-int ksz_switch_register(struct ksz_device *dev,
-			const struct ksz_dev_ops *ops);
-void ksz_switch_remove(struct ksz_device *dev);
-
-int ksz8795_switch_register(struct ksz_device *dev);
-int ksz9477_switch_register(struct ksz_device *dev);
-
-#endif
-- 
2.20.1

