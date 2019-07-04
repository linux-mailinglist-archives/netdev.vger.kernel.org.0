Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958785F342
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfGDHJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:08 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43693 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727389AbfGDHJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1008821AD2;
        Thu,  4 Jul 2019 03:09:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1sgsJYbtS61q2HAYThhlKMIfuikxTAUeY0PewNlYJpM=; b=QR9q+34p
        lGDPtn67le9dB02DwdefXSanL9Z1UCWFUFcqteEdmCwUzMl7JmqmqPgoK4oayOS6
        no9n1bBQ5ogHQpwhu6K7XuEtUnJFMS9X9Awk4KN2SXrxJnOtMwRddDW2zTV/GHAU
        0QOy66lp6GoIV+HW7z+ZFmdEApmtdrgU+Vlm6KIrXc6Nys633NFQOXiRokceiMC6
        Np6CuVFx8NXWY0RK8UUWhg0PnvS3Z4y6fkPiiSNRLm11TowY2HM3mE79M7BpHUjI
        8qOYm/tXJdcnns6++o8v6KbPCO1GXvzXAoPRKsqc9HdMcsWF6Xy+23DnP1jOyDxX
        tmXINtT18QzTCQ==
X-ME-Sender: <xms:EaYdXY53FoniS8yN3i2PpMTHAN2_g754pq7zBvNjRqi5ORsyHC6-Nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:EaYdXdtPlzC8GAOpEKhC2RDuoIIdZoAMc0B_K9EbsISRdPL5GjiT3w>
    <xmx:EaYdXQgiXXyzCrMx0U_-H7Jf71GBJlGqj5xVDeDHM_T2ZHJs2rh6Sg>
    <xmx:EaYdXQoJdWM7uEhg4U68PTFPZQlp9QyrpvVSn8GdHB14iym8DwFcyw>
    <xmx:EqYdXcVMznl-UIbS9OwhiGUA3APsDthy4SGGEIeIr1DSsM8Cgcon3A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 121D5380088;
        Thu,  4 Jul 2019 03:09:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum: Add new operation for getting the port's speed
Date:   Thu,  4 Jul 2019 10:07:37 +0300
Message-Id: <20190704070740.302-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

New operation for getting the port's speed as part of port-type-speed
operations.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 68 +++++++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 2 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 67133ba53015..7cfca2be09fc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2655,28 +2655,33 @@ mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 	}
 }
 
+static u32
+mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			return mlxsw_sp1_port_link_mode[i].speed;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
 static void
 mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 				 u32 ptys_eth_proto,
 				 struct ethtool_link_ksettings *cmd)
 {
-	u32 speed = SPEED_UNKNOWN;
-	u8 duplex = DUPLEX_UNKNOWN;
-	int i;
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
 
 	if (!carrier_ok)
-		goto out;
+		return;
 
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask) {
-			speed = mlxsw_sp1_port_link_mode[i].speed;
-			duplex = DUPLEX_FULL;
-			break;
-		}
-	}
-out:
-	cmd->base.speed = speed;
-	cmd->base.duplex = duplex;
+	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
+	if (cmd->base.speed != SPEED_UNKNOWN)
+		cmd->base.duplex = DUPLEX_FULL;
 }
 
 static u32
@@ -2747,6 +2752,7 @@ static const struct mlxsw_sp_port_type_speed_ops
 mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
+	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
 	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
@@ -2997,28 +3003,33 @@ mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 	}
 }
 
+static u32
+mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
+			return mlxsw_sp2_port_link_mode[i].speed;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
 static void
 mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 				 u32 ptys_eth_proto,
 				 struct ethtool_link_ksettings *cmd)
 {
-	u32 speed = SPEED_UNKNOWN;
-	u8 duplex = DUPLEX_UNKNOWN;
-	int i;
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
 
 	if (!carrier_ok)
-		goto out;
+		return;
 
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
-			speed = mlxsw_sp2_port_link_mode[i].speed;
-			duplex = DUPLEX_FULL;
-			break;
-		}
-	}
-out:
-	cmd->base.speed = speed;
-	cmd->base.duplex = duplex;
+	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
+	if (cmd->base.speed != SPEED_UNKNOWN)
+		cmd->base.duplex = DUPLEX_FULL;
 }
 
 static bool
@@ -3129,6 +3140,7 @@ static const struct mlxsw_sp_port_type_speed_ops
 mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
+	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
 	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 7f8427c1a997..c21cd1a425c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -279,6 +279,7 @@ struct mlxsw_sp_port_type_speed_ops {
 					 struct ethtool_link_ksettings *cmd);
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 			       unsigned long *mode);
+	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
-- 
2.20.1

