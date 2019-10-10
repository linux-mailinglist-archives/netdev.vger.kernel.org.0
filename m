Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98113D20CF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbfJJGcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:32:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53799 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729045AbfJJGcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:32:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 437DB21368;
        Thu, 10 Oct 2019 02:32:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 02:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/UZ/mVW0xgQa9ZQDS+9E2Ri1me6o1USXQTTcDiYi6Fw=; b=OOdtPbVJ
        BB+YDm5Di/S0+38gltrY8rxhob1QDWBwz68sitQ1wNd8JH4sml85vq1mwzJddql+
        m9oN0ERo9mzAluKBPfnnz/Swrg8SMNdRX5wyRMhfqlIZIaZQ9LzzM0IDCz6iCgu1
        N19BvnDSVsQOEWet4f/Yyvqf1SKA5RNtL9wopkBe9N2uMheypbfv5izoswtSIBjO
        /kIs4BppUFx1IpXOBoXrMMN4o5pHjNJUoFbRw8S7m/ZqSW/iA6XL3rXpQF5OQ7Ba
        uL2t73C1N5ghgZB4Zm2uAbRxt+iByn0sBaQSQ8sFZ9bXSm0ESx19IKCbnimrhBTM
        N2AlFlazTNcqRg==
X-ME-Sender: <xms:itCeXTYRFYGfopb5179ZSqwikmQMnEQ9tOXC5buBT9OKzVm4n1pfiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:itCeXRXdYSlv-SL9FdGD-GpxbHEq_FIsRmIfp9LvSVOlc7qBn4FtJA>
    <xmx:itCeXSBzUsQURHRUN1rdZ-gqLCTRoVQ3oVjnaAr9arYVyC4BMiOxlg>
    <xmx:itCeXdI07ewaiGKOwDZoUQ1PT_tfdsfNPhXs6EFRp5KIp3xnJTvPtw>
    <xmx:itCeXcE0dH3KGn6U8uRg-c--NwM6xcgeuQmcRi6Cfz15LWKmz2c6EA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A372D60063;
        Thu, 10 Oct 2019 02:32:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Thu, 10 Oct 2019 09:32:03 +0300
Message-Id: <20191010063203.31577-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010063203.31577-1-idosch@idosch.org>
References: <20191010063203.31577-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend speed support with 400Gbps

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 52 +++++++++++++++----
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7b538e698a3d..f5e39758c6ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4111,6 +4111,7 @@ MLXSW_ITEM32(reg, ptys, an_status, 0x04, 28, 4);
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4		BIT(9)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2		BIT(10)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4		BIT(12)
+#define MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8				BIT(15)
 
 /* reg_ptys_ext_eth_proto_cap
  * Extended Ethernet port supported speeds and protocols.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3c5154e559b2..ae3c4da11520 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2912,9 +2912,22 @@ mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4[] = {
 #define MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN \
 	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4)
 
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_400gaui_8[] = {
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_400gaui_8)
+
 #define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
 #define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
 #define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
+#define MLXSW_SP_PORT_MASK_WIDTH_8X	BIT(3)
 
 static u8 mlxsw_sp_port_mask_width_get(u8 width)
 {
@@ -2925,6 +2938,8 @@ static u8 mlxsw_sp_port_mask_width_get(u8 width)
 		return MLXSW_SP_PORT_MASK_WIDTH_2X;
 	case 4:
 		return MLXSW_SP_PORT_MASK_WIDTH_4X;
+	case 8:
+		return MLXSW_SP_PORT_MASK_WIDTH_8X;
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
@@ -2946,7 +2961,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100,
 	},
 	{
@@ -2955,7 +2971,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_1000,
 	},
 	{
@@ -2964,7 +2981,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_2500,
 	},
 	{
@@ -2973,7 +2991,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_5000,
 	},
 	{
@@ -2982,14 +3001,16 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_10000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_40000,
 	},
 	{
@@ -2998,7 +3019,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_25000,
 	},
 	{
@@ -3006,7 +3028,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_50000,
 	},
 	{
@@ -3020,7 +3043,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100000,
 	},
 	{
@@ -3034,9 +3058,17 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_200000,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_400gaui_8,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_400000,
+	},
 };
 
 #define MLXSW_SP2_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp2_port_link_mode)
-- 
2.21.0

