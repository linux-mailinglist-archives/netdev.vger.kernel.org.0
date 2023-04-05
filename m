Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04216D771D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbjDEIjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237539AbjDEIja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9AE4EEE;
        Wed,  5 Apr 2023 01:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87813638AB;
        Wed,  5 Apr 2023 08:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E0C4339B;
        Wed,  5 Apr 2023 08:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680683967;
        bh=eBwHOZLTqSobGmEKeSjE4WmBwNLZqQkIpLt+lGpxtXo=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=AEIrzDGVYGUsfD+hJNg8g7uXBn4tgA7CJNWuzKFTCeJM7NQbWe4L28Xo74KtLZjRp
         yHnli61GeswYrSYD7hOdi4zg9fKisFTJNUXHOgwVVaxtaC1D7Cae9oBvxKtPio2AKA
         D3et4CHR+axnDW9a34sTwihczIJrIsS1LMXXcjYPj8asieIrCt5h+qYbwNDTbD1JZC
         c6MHGsaV9kwwUotNBiMY7q1r3TyY7myGEOdeW2Yu5EeNyOqE//pvxfDBoOKMDNbj4O
         qvm+Dpwb2eFNrOnHEhGxOAZDnVyYf49Pb9fV+Y+a7vyGjCrkE954b+OIKTK3Z1GR7F
         5nrQJYulfbUFw==
From:   Simon Horman <horms@kernel.org>
Date:   Wed, 05 Apr 2023 10:39:18 +0200
Subject: [PATCH net-next 3/3] ksz884x: remove unused functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-ksz884x-unused-code-v1-3-a3349811d5ef@kernel.org>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
In-Reply-To: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused functions and now unused #defines from ksz884x driver.

These functions and #defines may have some value in documenting the
hardware. But that information may be accessed via scm history.

Flagged by clang-16 with W=1.
No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 308 ----------------------------------
 1 file changed, 308 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 7a6f71ec8355..48d9cb8c6773 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -153,16 +153,10 @@
 
 #define KS884X_PHY_CTRL_OFFSET		0x00
 
-#define KS884X_PHY_STATUS_OFFSET	0x02
-
 #define KS884X_PHY_AUTO_NEG_OFFSET	0x08
 
 #define KS884X_PHY_REMOTE_CAP_OFFSET	0x0A
 
-#define KS884X_PHY_LINK_MD_OFFSET	0x00
-
-#define KS884X_PHY_PHY_CTRL_OFFSET	0x02
-
 /* SIDER */
 #define KS884X_SIDER_P			0x0400
 #define KS884X_CHIP_ID_OFFSET		KS884X_SIDER_P
@@ -210,9 +204,6 @@
 
 /* SGCR7 */
 #define KS8842_SGCR7_P			0x0412
-#define KS8842_SWITCH_CTRL_7_OFFSET	KS8842_SGCR7_P
-
-#define SWITCH_UNK_DEF_PORT_ENABLE	0x0008
 
 /* MACAR1 */
 #define KS8842_MACAR1_P			0x0470
@@ -246,15 +237,10 @@
 #define PORT_BASED_PRIORITY_MASK	0x0018
 #define PORT_BASED_PRIORITY_BASE	0x0003
 #define PORT_BASED_PRIORITY_SHIFT	3
-#define PORT_INSERT_TAG			0x0004
-#define PORT_REMOVE_TAG			0x0002
 #define PORT_PRIO_QUEUE_ENABLE		0x0001
 
 #define KS8842_PORT_CTRL_2_OFFSET	0x02
 
-#define PORT_INGRESS_VLAN_FILTER	0x4000
-#define PORT_DISCARD_NON_VID		0x2000
-#define PORT_FORCE_FLOW_CTRL		0x1000
 #define PORT_BACK_PRESSURE		0x0800
 #define PORT_TX_ENABLE			0x0400
 #define PORT_RX_ENABLE			0x0200
@@ -1081,15 +1067,6 @@ static void hw_turn_on_intr(struct ksz_hw *hw, u32 bit)
 		hw_set_intr(hw, hw->intr_mask);
 }
 
-static inline void hw_ena_intr_bit(struct ksz_hw *hw, uint interrupt)
-{
-	u32 read_intr;
-
-	read_intr = readl(hw->io + KS884X_INTERRUPTS_ENABLE);
-	hw->intr_set = read_intr | interrupt;
-	writel(hw->intr_set, hw->io + KS884X_INTERRUPTS_ENABLE);
-}
-
 static inline void hw_read_intr(struct ksz_hw *hw, uint *status)
 {
 	*status = readl(hw->io + KS884X_INTERRUPTS_STATUS);
@@ -1458,29 +1435,6 @@ static void port_init_cnt(struct ksz_hw *hw, int port)
  * Port functions
  */
 
-/**
- * port_chk - check port register bits
- * @hw: 	The hardware instance.
- * @port:	The port index.
- * @offset:	The offset of the port register.
- * @bits:	The data bits to check.
- *
- * This function checks whether the specified bits of the port register are set
- * or not.
- *
- * Return 0 if the bits are not set.
- */
-static int port_chk(struct ksz_hw *hw, int port, int offset, u16 bits)
-{
-	u32 addr;
-	u16 data;
-
-	PORT_CTRL_ADDR(port, addr);
-	addr += offset;
-	data = readw(hw->io + addr);
-	return (data & bits) == bits;
-}
-
 /**
  * port_cfg - set port register bits
  * @hw: 	The hardware instance.
@@ -1507,53 +1461,6 @@ static void port_cfg(struct ksz_hw *hw, int port, int offset, u16 bits,
 	writew(data, hw->io + addr);
 }
 
-/**
- * port_chk_shift - check port bit
- * @hw: 	The hardware instance.
- * @port:	The port index.
- * @addr:	The offset of the register.
- * @shift:	Number of bits to shift.
- *
- * This function checks whether the specified port is set in the register or
- * not.
- *
- * Return 0 if the port is not set.
- */
-static int port_chk_shift(struct ksz_hw *hw, int port, u32 addr, int shift)
-{
-	u16 data;
-	u16 bit = 1 << port;
-
-	data = readw(hw->io + addr);
-	data >>= shift;
-	return (data & bit) == bit;
-}
-
-/**
- * port_cfg_shift - set port bit
- * @hw: 	The hardware instance.
- * @port:	The port index.
- * @addr:	The offset of the register.
- * @shift:	Number of bits to shift.
- * @set:	The flag indicating whether the port is to be set or not.
- *
- * This routine sets or resets the specified port in the register.
- */
-static void port_cfg_shift(struct ksz_hw *hw, int port, u32 addr, int shift,
-	int set)
-{
-	u16 data;
-	u16 bits = 1 << port;
-
-	data = readw(hw->io + addr);
-	bits <<= shift;
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-	writew(data, hw->io + addr);
-}
-
 /**
  * port_r8 - read byte from port register
  * @hw: 	The hardware instance.
@@ -1656,12 +1563,6 @@ static inline void port_cfg_broad_storm(struct ksz_hw *hw, int p, int set)
 		KS8842_PORT_CTRL_1_OFFSET, PORT_BROADCAST_STORM, set);
 }
 
-static inline int port_chk_broad_storm(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_BROADCAST_STORM);
-}
-
 /* Driver set switch broadcast storm protection at 10% rate. */
 #define BROADCAST_STORM_PROTECTION_RATE	10
 
@@ -1814,102 +1715,6 @@ static inline void port_cfg_back_pressure(struct ksz_hw *hw, int p, int set)
 		KS8842_PORT_CTRL_2_OFFSET, PORT_BACK_PRESSURE, set);
 }
 
-static inline void port_cfg_force_flow_ctrl(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_FORCE_FLOW_CTRL, set);
-}
-
-static inline int port_chk_back_pressure(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_BACK_PRESSURE);
-}
-
-static inline int port_chk_force_flow_ctrl(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_FORCE_FLOW_CTRL);
-}
-
-/* Spanning Tree */
-
-static inline void port_cfg_rx(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_RX_ENABLE, set);
-}
-
-static inline void port_cfg_tx(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_TX_ENABLE, set);
-}
-
-static inline void sw_cfg_fast_aging(struct ksz_hw *hw, int set)
-{
-	sw_cfg(hw, KS8842_SWITCH_CTRL_1_OFFSET, SWITCH_FAST_AGING, set);
-}
-
-static inline void sw_flush_dyn_mac_table(struct ksz_hw *hw)
-{
-	if (!(hw->overrides & FAST_AGING)) {
-		sw_cfg_fast_aging(hw, 1);
-		mdelay(1);
-		sw_cfg_fast_aging(hw, 0);
-	}
-}
-
-/* VLAN */
-
-static inline void port_cfg_ins_tag(struct ksz_hw *hw, int p, int insert)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_INSERT_TAG, insert);
-}
-
-static inline void port_cfg_rmv_tag(struct ksz_hw *hw, int p, int remove)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_REMOVE_TAG, remove);
-}
-
-static inline int port_chk_ins_tag(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_INSERT_TAG);
-}
-
-static inline int port_chk_rmv_tag(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_REMOVE_TAG);
-}
-
-static inline void port_cfg_dis_non_vid(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_DISCARD_NON_VID, set);
-}
-
-static inline void port_cfg_in_filter(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_INGRESS_VLAN_FILTER, set);
-}
-
-static inline int port_chk_dis_non_vid(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_DISCARD_NON_VID);
-}
-
-static inline int port_chk_in_filter(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_INGRESS_VLAN_FILTER);
-}
-
 /* Mirroring */
 
 static inline void port_cfg_mirror_sniffer(struct ksz_hw *hw, int p, int set)
@@ -1947,28 +1752,6 @@ static void sw_init_mirror(struct ksz_hw *hw)
 	sw_cfg_mirror_rx_tx(hw, 0);
 }
 
-static inline void sw_cfg_unk_def_deliver(struct ksz_hw *hw, int set)
-{
-	sw_cfg(hw, KS8842_SWITCH_CTRL_7_OFFSET,
-		SWITCH_UNK_DEF_PORT_ENABLE, set);
-}
-
-static inline int sw_cfg_chk_unk_def_deliver(struct ksz_hw *hw)
-{
-	return sw_chk(hw, KS8842_SWITCH_CTRL_7_OFFSET,
-		SWITCH_UNK_DEF_PORT_ENABLE);
-}
-
-static inline void sw_cfg_unk_def_port(struct ksz_hw *hw, int port, int set)
-{
-	port_cfg_shift(hw, port, KS8842_SWITCH_CTRL_7_OFFSET, 0, set);
-}
-
-static inline int sw_chk_unk_def_port(struct ksz_hw *hw, int port)
-{
-	return port_chk_shift(hw, port, KS8842_SWITCH_CTRL_7_OFFSET, 0);
-}
-
 /* Priority */
 
 static inline void port_cfg_diffserv(struct ksz_hw *hw, int p, int set)
@@ -1995,30 +1778,6 @@ static inline void port_cfg_prio(struct ksz_hw *hw, int p, int set)
 		KS8842_PORT_CTRL_1_OFFSET, PORT_PRIO_QUEUE_ENABLE, set);
 }
 
-static inline int port_chk_diffserv(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_DIFFSERV_ENABLE);
-}
-
-static inline int port_chk_802_1p(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_802_1P_ENABLE);
-}
-
-static inline int port_chk_replace_vid(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_USER_PRIORITY_CEILING);
-}
-
-static inline int port_chk_prio(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_PRIO_QUEUE_ENABLE);
-}
-
 /**
  * sw_dis_diffserv - disable switch DiffServ priority
  * @hw: 	The hardware instance.
@@ -2218,23 +1977,6 @@ static void sw_cfg_port_base_vlan(struct ksz_hw *hw, int port, u8 member)
 	hw->ksz_switch->port_cfg[port].member = member;
 }
 
-/**
- * sw_get_addr - get the switch MAC address.
- * @hw: 	The hardware instance.
- * @mac_addr:	Buffer to store the MAC address.
- *
- * This function retrieves the MAC address of the switch.
- */
-static inline void sw_get_addr(struct ksz_hw *hw, u8 *mac_addr)
-{
-	int i;
-
-	for (i = 0; i < 6; i += 2) {
-		mac_addr[i] = readb(hw->io + KS8842_MAC_ADDR_0_OFFSET + i);
-		mac_addr[1 + i] = readb(hw->io + KS8842_MAC_ADDR_1_OFFSET + i);
-	}
-}
-
 /**
  * sw_set_addr - configure switch MAC address
  * @hw: 	The hardware instance.
@@ -2432,56 +2174,6 @@ static inline void hw_w_phy_ctrl(struct ksz_hw *hw, int phy, u16 data)
 	writew(data, hw->io + phy + KS884X_PHY_CTRL_OFFSET);
 }
 
-static inline void hw_r_phy_link_stat(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_STATUS_OFFSET);
-}
-
-static inline void hw_r_phy_auto_neg(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_AUTO_NEG_OFFSET);
-}
-
-static inline void hw_w_phy_auto_neg(struct ksz_hw *hw, int phy, u16 data)
-{
-	writew(data, hw->io + phy + KS884X_PHY_AUTO_NEG_OFFSET);
-}
-
-static inline void hw_r_phy_rem_cap(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_REMOTE_CAP_OFFSET);
-}
-
-static inline void hw_r_phy_crossover(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_CTRL_OFFSET);
-}
-
-static inline void hw_w_phy_crossover(struct ksz_hw *hw, int phy, u16 data)
-{
-	writew(data, hw->io + phy + KS884X_PHY_CTRL_OFFSET);
-}
-
-static inline void hw_r_phy_polarity(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_PHY_CTRL_OFFSET);
-}
-
-static inline void hw_w_phy_polarity(struct ksz_hw *hw, int phy, u16 data)
-{
-	writew(data, hw->io + phy + KS884X_PHY_PHY_CTRL_OFFSET);
-}
-
-static inline void hw_r_phy_link_md(struct ksz_hw *hw, int phy, u16 *data)
-{
-	*data = readw(hw->io + phy + KS884X_PHY_LINK_MD_OFFSET);
-}
-
-static inline void hw_w_phy_link_md(struct ksz_hw *hw, int phy, u16 data)
-{
-	writew(data, hw->io + phy + KS884X_PHY_LINK_MD_OFFSET);
-}
-
 /**
  * hw_r_phy - read data from PHY register
  * @hw: 	The hardware instance.

-- 
2.30.2

