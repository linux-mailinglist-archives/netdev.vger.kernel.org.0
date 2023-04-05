Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD56D771B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbjDEIjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbjDEIja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D3D3C3F;
        Wed,  5 Apr 2023 01:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B015621F6;
        Wed,  5 Apr 2023 08:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD71EC433A1;
        Wed,  5 Apr 2023 08:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680683965;
        bh=AtUBoWbfdZZn9LhqU+9lBChk6GPJrHBFsOPz7oFv9Gk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=CcxZv1anCRdWGROUDPemqb2h7o0ekEQOutj7YNDCZuhVSBXrAPduUYkjsTkNVmhF7
         gi9iOisk3Ogl3pBOuH/ztJY5q/6HU7HjoaYNs+wKcC7n24IK035QhV2XKa9wiQbQqr
         siexLYPxv7qGVX86O06VR55sOmiAKpesN3NgM+3Nvwg/KIxMk4dkcBxyzMAqq8iJrs
         tR88+KiZCpxV/S2VXpF9KTJ+FZKRwOZgezBL8adRSlbAo63bgJW2Q+JFgBzDUW0zbk
         tUo6g001c6ygpQIUMYrRJCV9S0o2z3vwlURMHtN8qTp1i0d9POJDYw2k4DDRDESZrB
         1/V1pQx7Z68DQ==
From:   Simon Horman <horms@kernel.org>
Date:   Wed, 05 Apr 2023 10:39:17 +0200
Subject: [PATCH net-next 2/3] ksz884x: remove unused #defines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-ksz884x-unused-code-v1-2-a3349811d5ef@kernel.org>
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,UPPERCASE_50_75 autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused #defines from ksz884x driver.

These #defines may have some value in documenting the hardware.
But that information may be accessed via scm history.

Isolated using gcc-12 with EXTRA_CFLAGS="-Wunused-macros"
No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 379 +---------------------------------
 1 file changed, 1 insertion(+), 378 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index f70895f2174e..7a6f71ec8355 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -34,12 +34,7 @@
 #define DMA_TX_ENABLE			0x00000001
 #define DMA_TX_CRC_ENABLE		0x00000002
 #define DMA_TX_PAD_ENABLE		0x00000004
-#define DMA_TX_LOOPBACK			0x00000100
 #define DMA_TX_FLOW_ENABLE		0x00000200
-#define DMA_TX_CSUM_IP			0x00010000
-#define DMA_TX_CSUM_TCP			0x00020000
-#define DMA_TX_CSUM_UDP			0x00040000
-#define DMA_TX_BURST_SIZE		0x3F000000
 
 #define KS_DMA_RX_CTRL			0x0004
 #define DMA_RX_ENABLE			0x00000001
@@ -53,7 +48,6 @@
 #define DMA_RX_CSUM_IP			0x00010000
 #define DMA_RX_CSUM_TCP			0x00020000
 #define DMA_RX_CSUM_UDP			0x00040000
-#define DMA_RX_BURST_SIZE		0x3F000000
 
 #define DMA_BURST_SHIFT			24
 #define DMA_BURST_DEFAULT		8
@@ -65,19 +59,8 @@
 #define KS_DMA_TX_ADDR			0x0010
 #define KS_DMA_RX_ADDR			0x0014
 
-#define DMA_ADDR_LIST_MASK		0xFFFFFFFC
-#define DMA_ADDR_LIST_SHIFT		2
-
 /* MTR0 */
 #define KS884X_MULTICAST_0_OFFSET	0x0020
-#define KS884X_MULTICAST_1_OFFSET	0x0021
-#define KS884X_MULTICAST_2_OFFSET	0x0022
-#define KS884x_MULTICAST_3_OFFSET	0x0023
-/* MTR1 */
-#define KS884X_MULTICAST_4_OFFSET	0x0024
-#define KS884X_MULTICAST_5_OFFSET	0x0025
-#define KS884X_MULTICAST_6_OFFSET	0x0026
-#define KS884X_MULTICAST_7_OFFSET	0x0027
 
 /* Interrupt Registers */
 
@@ -106,68 +89,9 @@
 #define KS_ADD_ADDR_0_LO		0x0080
 /* MAAH0 */
 #define KS_ADD_ADDR_0_HI		0x0084
-/* MAAL1 */
-#define KS_ADD_ADDR_1_LO		0x0088
-/* MAAH1 */
-#define KS_ADD_ADDR_1_HI		0x008C
-/* MAAL2 */
-#define KS_ADD_ADDR_2_LO		0x0090
-/* MAAH2 */
-#define KS_ADD_ADDR_2_HI		0x0094
-/* MAAL3 */
-#define KS_ADD_ADDR_3_LO		0x0098
-/* MAAH3 */
-#define KS_ADD_ADDR_3_HI		0x009C
-/* MAAL4 */
-#define KS_ADD_ADDR_4_LO		0x00A0
-/* MAAH4 */
-#define KS_ADD_ADDR_4_HI		0x00A4
-/* MAAL5 */
-#define KS_ADD_ADDR_5_LO		0x00A8
-/* MAAH5 */
-#define KS_ADD_ADDR_5_HI		0x00AC
-/* MAAL6 */
-#define KS_ADD_ADDR_6_LO		0x00B0
-/* MAAH6 */
-#define KS_ADD_ADDR_6_HI		0x00B4
-/* MAAL7 */
-#define KS_ADD_ADDR_7_LO		0x00B8
-/* MAAH7 */
-#define KS_ADD_ADDR_7_HI		0x00BC
-/* MAAL8 */
-#define KS_ADD_ADDR_8_LO		0x00C0
-/* MAAH8 */
-#define KS_ADD_ADDR_8_HI		0x00C4
-/* MAAL9 */
-#define KS_ADD_ADDR_9_LO		0x00C8
-/* MAAH9 */
-#define KS_ADD_ADDR_9_HI		0x00CC
-/* MAAL10 */
-#define KS_ADD_ADDR_A_LO		0x00D0
-/* MAAH10 */
-#define KS_ADD_ADDR_A_HI		0x00D4
-/* MAAL11 */
-#define KS_ADD_ADDR_B_LO		0x00D8
-/* MAAH11 */
-#define KS_ADD_ADDR_B_HI		0x00DC
-/* MAAL12 */
-#define KS_ADD_ADDR_C_LO		0x00E0
-/* MAAH12 */
-#define KS_ADD_ADDR_C_HI		0x00E4
-/* MAAL13 */
-#define KS_ADD_ADDR_D_LO		0x00E8
-/* MAAH13 */
-#define KS_ADD_ADDR_D_HI		0x00EC
-/* MAAL14 */
-#define KS_ADD_ADDR_E_LO		0x00F0
-/* MAAH14 */
-#define KS_ADD_ADDR_E_HI		0x00F4
-/* MAAL15 */
-#define KS_ADD_ADDR_F_LO		0x00F8
 /* MAAH15 */
 #define KS_ADD_ADDR_F_HI		0x00FC
 
-#define ADD_ADDR_HI_MASK		0x0000FFFF
 #define ADD_ADDR_ENABLE			0x80000000
 #define ADD_ADDR_INCR			8
 
@@ -175,21 +99,11 @@
 
 /* MARL */
 #define KS884X_ADDR_0_OFFSET		0x0200
-#define KS884X_ADDR_1_OFFSET		0x0201
-/* MARM */
-#define KS884X_ADDR_2_OFFSET		0x0202
-#define KS884X_ADDR_3_OFFSET		0x0203
-/* MARH */
-#define KS884X_ADDR_4_OFFSET		0x0204
-#define KS884X_ADDR_5_OFFSET		0x0205
 
 /* OBCR */
 #define KS884X_BUS_CTRL_OFFSET		0x0210
 
 #define BUS_SPEED_125_MHZ		0x0000
-#define BUS_SPEED_62_5_MHZ		0x0001
-#define BUS_SPEED_41_66_MHZ		0x0002
-#define BUS_SPEED_25_MHZ		0x0003
 
 /* EEPCR */
 #define KS884X_EEPROM_CTRL_OFFSET	0x0212
@@ -200,20 +114,10 @@
 #define EEPROM_DATA_IN			0x0008
 #define EEPROM_ACCESS_ENABLE		0x0010
 
-/* MBIR */
-#define KS884X_MEM_INFO_OFFSET		0x0214
-
-#define RX_MEM_TEST_FAILED		0x0008
-#define RX_MEM_TEST_FINISHED		0x0010
-#define TX_MEM_TEST_FAILED		0x0800
-#define TX_MEM_TEST_FINISHED		0x1000
-
 /* GCR */
 #define KS884X_GLOBAL_CTRL_OFFSET	0x0216
 #define GLOBAL_SOFTWARE_RESET		0x0001
 
-#define KS8841_POWER_MANAGE_OFFSET	0x0218
-
 /* WFCR */
 #define KS8841_WOL_CTRL_OFFSET		0x021A
 #define KS8841_WOL_MAGIC_ENABLE		0x0080
@@ -232,40 +136,17 @@
 #define KS884X_IACR_OFFSET		KS884X_IACR_P
 
 /* IADR1 */
-#define KS884X_IADR1_P			0x04A2
 #define KS884X_IADR2_P			0x04A4
-#define KS884X_IADR3_P			0x04A6
 #define KS884X_IADR4_P			0x04A8
-#define KS884X_IADR5_P			0x04AA
-
-#define KS884X_ACC_CTRL_SEL_OFFSET	KS884X_IACR_P
-#define KS884X_ACC_CTRL_INDEX_OFFSET	(KS884X_ACC_CTRL_SEL_OFFSET + 1)
 
 #define KS884X_ACC_DATA_0_OFFSET	KS884X_IADR4_P
-#define KS884X_ACC_DATA_1_OFFSET	(KS884X_ACC_DATA_0_OFFSET + 1)
-#define KS884X_ACC_DATA_2_OFFSET	KS884X_IADR5_P
-#define KS884X_ACC_DATA_3_OFFSET	(KS884X_ACC_DATA_2_OFFSET + 1)
 #define KS884X_ACC_DATA_4_OFFSET	KS884X_IADR2_P
-#define KS884X_ACC_DATA_5_OFFSET	(KS884X_ACC_DATA_4_OFFSET + 1)
-#define KS884X_ACC_DATA_6_OFFSET	KS884X_IADR3_P
-#define KS884X_ACC_DATA_7_OFFSET	(KS884X_ACC_DATA_6_OFFSET + 1)
-#define KS884X_ACC_DATA_8_OFFSET	KS884X_IADR1_P
 
 /* P1MBCR */
 #define KS884X_P1MBCR_P			0x04D0
-#define KS884X_P1MBSR_P			0x04D2
-#define KS884X_PHY1ILR_P		0x04D4
-#define KS884X_PHY1IHR_P		0x04D6
-#define KS884X_P1ANAR_P			0x04D8
-#define KS884X_P1ANLPR_P		0x04DA
 
 /* P2MBCR */
 #define KS884X_P2MBCR_P			0x04E0
-#define KS884X_P2MBSR_P			0x04E2
-#define KS884X_PHY2ILR_P		0x04E4
-#define KS884X_PHY2IHR_P		0x04E6
-#define KS884X_P2ANAR_P			0x04E8
-#define KS884X_P2ANLPR_P		0x04EA
 
 #define KS884X_PHY_1_CTRL_OFFSET	KS884X_P1MBCR_P
 #define PHY_CTRL_INTERVAL		(KS884X_P2MBCR_P - KS884X_P1MBCR_P)
@@ -274,208 +155,84 @@
 
 #define KS884X_PHY_STATUS_OFFSET	0x02
 
-#define KS884X_PHY_ID_1_OFFSET		0x04
-#define KS884X_PHY_ID_2_OFFSET		0x06
-
 #define KS884X_PHY_AUTO_NEG_OFFSET	0x08
 
 #define KS884X_PHY_REMOTE_CAP_OFFSET	0x0A
 
-/* P1VCT */
-#define KS884X_P1VCT_P			0x04F0
-#define KS884X_P1PHYCTRL_P		0x04F2
-
-/* P2VCT */
-#define KS884X_P2VCT_P			0x04F4
-#define KS884X_P2PHYCTRL_P		0x04F6
-
-#define KS884X_PHY_SPECIAL_OFFSET	KS884X_P1VCT_P
-#define PHY_SPECIAL_INTERVAL		(KS884X_P2VCT_P - KS884X_P1VCT_P)
-
 #define KS884X_PHY_LINK_MD_OFFSET	0x00
 
-#define PHY_START_CABLE_DIAG		0x8000
-#define PHY_CABLE_DIAG_RESULT		0x6000
-#define PHY_CABLE_STAT_NORMAL		0x0000
-#define PHY_CABLE_STAT_OPEN		0x2000
-#define PHY_CABLE_STAT_SHORT		0x4000
-#define PHY_CABLE_STAT_FAILED		0x6000
-#define PHY_CABLE_10M_SHORT		0x1000
-#define PHY_CABLE_FAULT_COUNTER		0x01FF
-
 #define KS884X_PHY_PHY_CTRL_OFFSET	0x02
 
-#define PHY_STAT_REVERSED_POLARITY	0x0020
-#define PHY_STAT_MDIX			0x0010
-#define PHY_FORCE_LINK			0x0008
-#define PHY_POWER_SAVING_DISABLE	0x0004
-#define PHY_REMOTE_LOOPBACK		0x0002
-
 /* SIDER */
 #define KS884X_SIDER_P			0x0400
 #define KS884X_CHIP_ID_OFFSET		KS884X_SIDER_P
-#define KS884X_FAMILY_ID_OFFSET		(KS884X_CHIP_ID_OFFSET + 1)
-
-#define REG_FAMILY_ID			0x88
 
 #define REG_CHIP_ID_41			0x8810
 #define REG_CHIP_ID_42			0x8800
 
 #define KS884X_CHIP_ID_MASK_41		0xFF10
-#define KS884X_CHIP_ID_MASK		0xFFF0
-#define KS884X_CHIP_ID_SHIFT		4
 #define KS884X_REVISION_MASK		0x000E
 #define KS884X_REVISION_SHIFT		1
 #define KS8842_START			0x0001
 
-#define CHIP_IP_41_M			0x8810
-#define CHIP_IP_42_M			0x8800
-#define CHIP_IP_61_M			0x8890
-#define CHIP_IP_62_M			0x8880
-
-#define CHIP_IP_41_P			0x8850
-#define CHIP_IP_42_P			0x8840
-#define CHIP_IP_61_P			0x88D0
-#define CHIP_IP_62_P			0x88C0
-
 /* SGCR1 */
 #define KS8842_SGCR1_P			0x0402
 #define KS8842_SWITCH_CTRL_1_OFFSET	KS8842_SGCR1_P
 
-#define SWITCH_PASS_ALL			0x8000
 #define SWITCH_TX_FLOW_CTRL		0x2000
 #define SWITCH_RX_FLOW_CTRL		0x1000
-#define SWITCH_CHECK_LENGTH		0x0800
 #define SWITCH_AGING_ENABLE		0x0400
 #define SWITCH_FAST_AGING		0x0200
 #define SWITCH_AGGR_BACKOFF		0x0100
-#define SWITCH_PASS_PAUSE		0x0008
 #define SWITCH_LINK_AUTO_AGING		0x0001
 
 /* SGCR2 */
 #define KS8842_SGCR2_P			0x0404
 #define KS8842_SWITCH_CTRL_2_OFFSET	KS8842_SGCR2_P
 
-#define SWITCH_VLAN_ENABLE		0x8000
-#define SWITCH_IGMP_SNOOP		0x4000
-#define IPV6_MLD_SNOOP_ENABLE		0x2000
-#define IPV6_MLD_SNOOP_OPTION		0x1000
-#define PRIORITY_SCHEME_SELECT		0x0800
 #define SWITCH_MIRROR_RX_TX		0x0100
-#define UNICAST_VLAN_BOUNDARY		0x0080
 #define MULTICAST_STORM_DISABLE		0x0040
-#define SWITCH_BACK_PRESSURE		0x0020
-#define FAIR_FLOW_CTRL			0x0010
 #define NO_EXC_COLLISION_DROP		0x0008
 #define SWITCH_HUGE_PACKET		0x0004
-#define SWITCH_LEGAL_PACKET		0x0002
-#define SWITCH_BUF_RESERVE		0x0001
 
 /* SGCR3 */
 #define KS8842_SGCR3_P			0x0406
 #define KS8842_SWITCH_CTRL_3_OFFSET	KS8842_SGCR3_P
 
 #define BROADCAST_STORM_RATE_LO		0xFF00
-#define SWITCH_REPEATER			0x0080
-#define SWITCH_HALF_DUPLEX		0x0040
 #define SWITCH_FLOW_CTRL		0x0020
-#define SWITCH_10_MBIT			0x0010
 #define SWITCH_REPLACE_NULL_VID		0x0008
 #define BROADCAST_STORM_RATE_HI		0x0007
 
 #define BROADCAST_STORM_RATE		0x07FF
 
-/* SGCR4 */
-#define KS8842_SGCR4_P			0x0408
-
-/* SGCR5 */
-#define KS8842_SGCR5_P			0x040A
-#define KS8842_SWITCH_CTRL_5_OFFSET	KS8842_SGCR5_P
-
-#define LED_MODE			0x8200
 #define LED_SPEED_DUPLEX_ACT		0x0000
-#define LED_SPEED_DUPLEX_LINK_ACT	0x8000
-#define LED_DUPLEX_10_100		0x0200
-
-/* SGCR6 */
-#define KS8842_SGCR6_P			0x0410
-#define KS8842_SWITCH_CTRL_6_OFFSET	KS8842_SGCR6_P
-
-#define KS8842_PRIORITY_MASK		3
-#define KS8842_PRIORITY_SHIFT		2
 
 /* SGCR7 */
 #define KS8842_SGCR7_P			0x0412
 #define KS8842_SWITCH_CTRL_7_OFFSET	KS8842_SGCR7_P
 
 #define SWITCH_UNK_DEF_PORT_ENABLE	0x0008
-#define SWITCH_UNK_DEF_PORT_3		0x0004
-#define SWITCH_UNK_DEF_PORT_2		0x0002
-#define SWITCH_UNK_DEF_PORT_1		0x0001
 
 /* MACAR1 */
 #define KS8842_MACAR1_P			0x0470
-#define KS8842_MACAR2_P			0x0472
-#define KS8842_MACAR3_P			0x0474
 #define KS8842_MAC_ADDR_1_OFFSET	KS8842_MACAR1_P
 #define KS8842_MAC_ADDR_0_OFFSET	(KS8842_MAC_ADDR_1_OFFSET + 1)
-#define KS8842_MAC_ADDR_3_OFFSET	KS8842_MACAR2_P
-#define KS8842_MAC_ADDR_2_OFFSET	(KS8842_MAC_ADDR_3_OFFSET + 1)
-#define KS8842_MAC_ADDR_5_OFFSET	KS8842_MACAR3_P
-#define KS8842_MAC_ADDR_4_OFFSET	(KS8842_MAC_ADDR_5_OFFSET + 1)
 
 /* TOSR1 */
-#define KS8842_TOSR1_P			0x0480
-#define KS8842_TOSR2_P			0x0482
-#define KS8842_TOSR3_P			0x0484
-#define KS8842_TOSR4_P			0x0486
-#define KS8842_TOSR5_P			0x0488
-#define KS8842_TOSR6_P			0x048A
-#define KS8842_TOSR7_P			0x0490
 #define KS8842_TOSR8_P			0x0492
-#define KS8842_TOS_1_OFFSET		KS8842_TOSR1_P
-#define KS8842_TOS_2_OFFSET		KS8842_TOSR2_P
-#define KS8842_TOS_3_OFFSET		KS8842_TOSR3_P
-#define KS8842_TOS_4_OFFSET		KS8842_TOSR4_P
-#define KS8842_TOS_5_OFFSET		KS8842_TOSR5_P
-#define KS8842_TOS_6_OFFSET		KS8842_TOSR6_P
-
-#define KS8842_TOS_7_OFFSET		KS8842_TOSR7_P
-#define KS8842_TOS_8_OFFSET		KS8842_TOSR8_P
 
 /* P1CR1 */
 #define KS8842_P1CR1_P			0x0500
-#define KS8842_P1CR2_P			0x0502
-#define KS8842_P1VIDR_P			0x0504
-#define KS8842_P1CR3_P			0x0506
-#define KS8842_P1IRCR_P			0x0508
-#define KS8842_P1ERCR_P			0x050A
-#define KS884X_P1SCSLMD_P		0x0510
-#define KS884X_P1CR4_P			0x0512
-#define KS884X_P1SR_P			0x0514
 
 /* P2CR1 */
 #define KS8842_P2CR1_P			0x0520
-#define KS8842_P2CR2_P			0x0522
-#define KS8842_P2VIDR_P			0x0524
-#define KS8842_P2CR3_P			0x0526
-#define KS8842_P2IRCR_P			0x0528
-#define KS8842_P2ERCR_P			0x052A
-#define KS884X_P2SCSLMD_P		0x0530
-#define KS884X_P2CR4_P			0x0532
-#define KS884X_P2SR_P			0x0534
 
 /* P3CR1 */
-#define KS8842_P3CR1_P			0x0540
-#define KS8842_P3CR2_P			0x0542
-#define KS8842_P3VIDR_P			0x0544
-#define KS8842_P3CR3_P			0x0546
-#define KS8842_P3IRCR_P			0x0548
 #define KS8842_P3ERCR_P			0x054A
 
 #define KS8842_PORT_1_CTRL_1		KS8842_P1CR1_P
 #define KS8842_PORT_2_CTRL_1		KS8842_P2CR1_P
-#define KS8842_PORT_3_CTRL_1		KS8842_P3CR1_P
 
 #define PORT_CTRL_ADDR(port, addr)		\
 	(addr = KS8842_PORT_1_CTRL_1 + (port) *	\
@@ -489,10 +246,6 @@
 #define PORT_BASED_PRIORITY_MASK	0x0018
 #define PORT_BASED_PRIORITY_BASE	0x0003
 #define PORT_BASED_PRIORITY_SHIFT	3
-#define PORT_BASED_PRIORITY_0		0x0000
-#define PORT_BASED_PRIORITY_1		0x0008
-#define PORT_BASED_PRIORITY_2		0x0010
-#define PORT_BASED_PRIORITY_3		0x0018
 #define PORT_INSERT_TAG			0x0004
 #define PORT_REMOVE_TAG			0x0002
 #define PORT_PRIO_QUEUE_ENABLE		0x0001
@@ -514,51 +267,13 @@
 
 #define KS8842_PORT_CTRL_VID_OFFSET	0x04
 
-#define PORT_DEFAULT_VID		0x0001
-
-#define KS8842_PORT_CTRL_3_OFFSET	0x06
-
-#define PORT_INGRESS_LIMIT_MODE		0x000C
-#define PORT_INGRESS_ALL		0x0000
-#define PORT_INGRESS_UNICAST		0x0004
-#define PORT_INGRESS_MULTICAST		0x0008
-#define PORT_INGRESS_BROADCAST		0x000C
-#define PORT_COUNT_IFG			0x0002
-#define PORT_COUNT_PREAMBLE		0x0001
-
 #define KS8842_PORT_IN_RATE_OFFSET	0x08
-#define KS8842_PORT_OUT_RATE_OFFSET	0x0A
-
-#define PORT_PRIORITY_RATE		0x0F
-#define PORT_PRIORITY_RATE_SHIFT	4
-
-#define KS884X_PORT_LINK_MD		0x10
-
-#define PORT_CABLE_10M_SHORT		0x8000
-#define PORT_CABLE_DIAG_RESULT		0x6000
-#define PORT_CABLE_STAT_NORMAL		0x0000
-#define PORT_CABLE_STAT_OPEN		0x2000
-#define PORT_CABLE_STAT_SHORT		0x4000
-#define PORT_CABLE_STAT_FAILED		0x6000
-#define PORT_START_CABLE_DIAG		0x1000
-#define PORT_FORCE_LINK			0x0800
-#define PORT_POWER_SAVING_DISABLE	0x0400
-#define PORT_PHY_REMOTE_LOOPBACK	0x0200
-#define PORT_CABLE_FAULT_COUNTER	0x01FF
 
 #define KS884X_PORT_CTRL_4_OFFSET	0x12
 
-#define PORT_LED_OFF			0x8000
-#define PORT_TX_DISABLE			0x4000
 #define PORT_AUTO_NEG_RESTART		0x2000
-#define PORT_REMOTE_FAULT_DISABLE	0x1000
 #define PORT_POWER_DOWN			0x0800
-#define PORT_AUTO_MDIX_DISABLE		0x0400
-#define PORT_FORCE_MDIX			0x0200
-#define PORT_LOOPBACK			0x0100
 #define PORT_AUTO_NEG_ENABLE		0x0080
-#define PORT_FORCE_100_MBIT		0x0040
-#define PORT_FORCE_FULL_DUPLEX		0x0020
 #define PORT_AUTO_NEG_SYM_PAUSE		0x0010
 #define PORT_AUTO_NEG_100BTX_FD		0x0008
 #define PORT_AUTO_NEG_100BTX		0x0004
@@ -567,28 +282,14 @@
 
 #define KS884X_PORT_STATUS_OFFSET	0x14
 
-#define PORT_HP_MDIX			0x8000
-#define PORT_REVERSED_POLARITY		0x2000
-#define PORT_RX_FLOW_CTRL		0x0800
-#define PORT_TX_FLOW_CTRL		0x1000
 #define PORT_STATUS_SPEED_100MBIT	0x0400
 #define PORT_STATUS_FULL_DUPLEX		0x0200
-#define PORT_REMOTE_FAULT		0x0100
-#define PORT_MDIX_STATUS		0x0080
 #define PORT_AUTO_NEG_COMPLETE		0x0040
 #define PORT_STATUS_LINK_GOOD		0x0020
-#define PORT_REMOTE_SYM_PAUSE		0x0010
-#define PORT_REMOTE_100BTX_FD		0x0008
-#define PORT_REMOTE_100BTX		0x0004
-#define PORT_REMOTE_10BT_FD		0x0002
-#define PORT_REMOTE_10BT		0x0001
-
-#define STATIC_MAC_TABLE_ADDR		0x0000FFFF
-#define STATIC_MAC_TABLE_FWD_PORTS	0x00070000
+
 #define STATIC_MAC_TABLE_VALID		0x00080000
 #define STATIC_MAC_TABLE_OVERRIDE	0x00100000
 #define STATIC_MAC_TABLE_USE_FID	0x00200000
-#define STATIC_MAC_TABLE_FID		0x03C00000
 
 #define STATIC_MAC_FWD_PORTS_SHIFT	16
 #define STATIC_MAC_FID_SHIFT		22
@@ -601,23 +302,6 @@
 #define VLAN_TABLE_FID_SHIFT		12
 #define VLAN_TABLE_MEMBERSHIP_SHIFT	16
 
-#define DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
-#define DYNAMIC_MAC_TABLE_FID		0x000F0000
-#define DYNAMIC_MAC_TABLE_SRC_PORT	0x00300000
-#define DYNAMIC_MAC_TABLE_TIMESTAMP	0x00C00000
-#define DYNAMIC_MAC_TABLE_ENTRIES	0xFF000000
-
-#define DYNAMIC_MAC_TABLE_ENTRIES_H	0x03
-#define DYNAMIC_MAC_TABLE_MAC_EMPTY	0x04
-#define DYNAMIC_MAC_TABLE_RESERVED	0x78
-#define DYNAMIC_MAC_TABLE_NOT_READY	0x80
-
-#define DYNAMIC_MAC_FID_SHIFT		16
-#define DYNAMIC_MAC_SRC_PORT_SHIFT	20
-#define DYNAMIC_MAC_TIMESTAMP_SHIFT	22
-#define DYNAMIC_MAC_ENTRIES_SHIFT	24
-#define DYNAMIC_MAC_ENTRIES_H_SHIFT	8
-
 #define MIB_COUNTER_VALUE		0x3FFFFFFF
 #define MIB_COUNTER_VALID		0x40000000
 #define MIB_COUNTER_OVERFLOW		0x80000000
@@ -625,11 +309,8 @@
 #define MIB_PACKET_DROPPED		0x0000FFFF
 
 #define KS_MIB_PACKET_DROPPED_TX_0	0x100
-#define KS_MIB_PACKET_DROPPED_TX_1	0x101
 #define KS_MIB_PACKET_DROPPED_TX	0x102
 #define KS_MIB_PACKET_DROPPED_RX_0	0x103
-#define KS_MIB_PACKET_DROPPED_RX_1	0x104
-#define KS_MIB_PACKET_DROPPED_RX	0x105
 
 /* Change default LED mode. */
 #define SET_DEFAULT_LED			LED_SPEED_DUPLEX_ACT
@@ -676,36 +357,21 @@ enum {
  */
 
 #define DESC_ALIGNMENT			16
-#define BUFFER_ALIGNMENT		8
 
 #define NUM_OF_RX_DESC			64
 #define NUM_OF_TX_DESC			64
 
-#define KS_DESC_RX_FRAME_LEN		0x000007FF
-#define KS_DESC_RX_FRAME_TYPE		0x00008000
 #define KS_DESC_RX_ERROR_CRC		0x00010000
 #define KS_DESC_RX_ERROR_RUNT		0x00020000
 #define KS_DESC_RX_ERROR_TOO_LONG	0x00040000
 #define KS_DESC_RX_ERROR_PHY		0x00080000
-#define KS884X_DESC_RX_PORT_MASK	0x00300000
-#define KS_DESC_RX_MULTICAST		0x01000000
-#define KS_DESC_RX_ERROR		0x02000000
-#define KS_DESC_RX_ERROR_CSUM_UDP	0x04000000
-#define KS_DESC_RX_ERROR_CSUM_TCP	0x08000000
-#define KS_DESC_RX_ERROR_CSUM_IP	0x10000000
-#define KS_DESC_RX_LAST			0x20000000
-#define KS_DESC_RX_FIRST		0x40000000
 #define KS_DESC_RX_ERROR_COND		\
 	(KS_DESC_RX_ERROR_CRC |		\
 	KS_DESC_RX_ERROR_RUNT |		\
 	KS_DESC_RX_ERROR_PHY |		\
 	KS_DESC_RX_ERROR_TOO_LONG)
 
-#define KS_DESC_HW_OWNED		0x80000000
-
 #define KS_DESC_BUF_SIZE		0x000007FF
-#define KS884X_DESC_TX_PORT_MASK	0x00300000
-#define KS_DESC_END_OF_RING		0x02000000
 #define KS_DESC_TX_CSUM_GEN_UDP		0x04000000
 #define KS_DESC_TX_CSUM_GEN_TCP		0x08000000
 #define KS_DESC_TX_CSUM_GEN_IP		0x10000000
@@ -713,8 +379,6 @@ enum {
 #define KS_DESC_TX_FIRST		0x40000000
 #define KS_DESC_TX_INTERRUPT		0x80000000
 
-#define KS_DESC_PORT_SHIFT		20
-
 #define KS_DESC_RX_MASK			(KS_DESC_BUF_SIZE)
 
 #define KS_DESC_TX_MASK			\
@@ -919,7 +583,6 @@ enum {
 	TABLE_MIB
 };
 
-#define LEARNED_MAC_TABLE_ENTRIES	1024
 #define STATIC_MAC_TABLE_ENTRIES	8
 
 /**
@@ -972,8 +635,6 @@ struct ksz_vlan_table {
 #define PORT_COUNTER_NUM		0x20
 #define TOTAL_PORT_COUNTER_NUM		(PORT_COUNTER_NUM + 2)
 
-#define MIB_COUNTER_RX_LO_PRIORITY	0x00
-#define MIB_COUNTER_RX_HI_PRIORITY	0x01
 #define MIB_COUNTER_RX_UNDERSIZE	0x02
 #define MIB_COUNTER_RX_FRAGMENT		0x03
 #define MIB_COUNTER_RX_OVERSIZE		0x04
@@ -981,32 +642,9 @@ struct ksz_vlan_table {
 #define MIB_COUNTER_RX_SYMBOL_ERR	0x06
 #define MIB_COUNTER_RX_CRC_ERR		0x07
 #define MIB_COUNTER_RX_ALIGNMENT_ERR	0x08
-#define MIB_COUNTER_RX_CTRL_8808	0x09
-#define MIB_COUNTER_RX_PAUSE		0x0A
-#define MIB_COUNTER_RX_BROADCAST	0x0B
 #define MIB_COUNTER_RX_MULTICAST	0x0C
-#define MIB_COUNTER_RX_UNICAST		0x0D
-#define MIB_COUNTER_RX_OCTET_64		0x0E
-#define MIB_COUNTER_RX_OCTET_65_127	0x0F
-#define MIB_COUNTER_RX_OCTET_128_255	0x10
-#define MIB_COUNTER_RX_OCTET_256_511	0x11
-#define MIB_COUNTER_RX_OCTET_512_1023	0x12
-#define MIB_COUNTER_RX_OCTET_1024_1522	0x13
-#define MIB_COUNTER_TX_LO_PRIORITY	0x14
-#define MIB_COUNTER_TX_HI_PRIORITY	0x15
 #define MIB_COUNTER_TX_LATE_COLLISION	0x16
-#define MIB_COUNTER_TX_PAUSE		0x17
-#define MIB_COUNTER_TX_BROADCAST	0x18
-#define MIB_COUNTER_TX_MULTICAST	0x19
-#define MIB_COUNTER_TX_UNICAST		0x1A
-#define MIB_COUNTER_TX_DEFERRED		0x1B
 #define MIB_COUNTER_TX_TOTAL_COLLISION	0x1C
-#define MIB_COUNTER_TX_EXCESS_COLLISION	0x1D
-#define MIB_COUNTER_TX_SINGLE_COLLISION	0x1E
-#define MIB_COUNTER_TX_MULTI_COLLISION	0x1F
-
-#define MIB_COUNTER_RX_DROPPED_PACKET	0x20
-#define MIB_COUNTER_TX_DROPPED_PACKET	0x21
 
 /**
  * struct ksz_port_mib - Port MIB data structure
@@ -2715,7 +2353,6 @@ static void port_set_stp_state(struct ksz_hw *hw, int port, int state)
 
 #define STP_ENTRY			0
 #define BROADCAST_ENTRY			1
-#define BRIDGE_ADDR_ENTRY		2
 #define IPV6_ADDR_ENTRY			3
 
 /**
@@ -2885,8 +2522,6 @@ static void hw_w_phy(struct ksz_hw *hw, int port, u16 reg, u16 val)
 
 #define AT93C_CODE			0
 #define AT93C_WR_OFF			0x00
-#define AT93C_WR_ALL			0x10
-#define AT93C_ER_ALL			0x20
 #define AT93C_WR_ON			0x30
 
 #define AT93C_WRITE			1
@@ -2980,14 +2615,6 @@ static void spi_reg(struct ksz_hw *hw, u8 data, u8 reg)
 	}
 }
 
-#define EEPROM_DATA_RESERVED		0
-#define EEPROM_DATA_MAC_ADDR_0		1
-#define EEPROM_DATA_MAC_ADDR_1		2
-#define EEPROM_DATA_MAC_ADDR_2		3
-#define EEPROM_DATA_SUBSYS_ID		4
-#define EEPROM_DATA_SUBSYS_VEN_ID	5
-#define EEPROM_DATA_PM_CAP		6
-
 /* User defined EEPROM data */
 #define EEPROM_DATA_OTHER_MAC_ADDR	9
 
@@ -3245,8 +2872,6 @@ static void port_get_link_speed(struct ksz_port *port)
 	hw_restore_intr(hw, interrupt);
 }
 
-#define PHY_RESET_TIMEOUT		10
-
 /**
  * port_set_link_speed - set port speed
  * @port: 	The port instance.
@@ -6771,8 +6396,6 @@ static void get_mac_addr(struct dev_info *hw_priv, u8 *macaddr, int port)
 	}
 }
 
-#define KS884X_DMA_MASK			(~0x0UL)
-
 static void read_other_addr(struct ksz_hw *hw)
 {
 	int i;

-- 
2.30.2

