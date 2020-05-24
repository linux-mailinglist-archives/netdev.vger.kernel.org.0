Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1EB1E0371
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbgEXVv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59335 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388229AbgEXVv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E43E5C00A5;
        Sun, 24 May 2020 17:51:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=BmHe+YqefDg1qRqlu1WT2WirOv9GHY4qE4PeeObWjl4=; b=QNStlrcI
        njNjusiFYMHMdvOfM3ByJ4PK3l8wV3KeIDYQykg0uw49mADIoEQU4Ye6jwbpurW8
        utY27ooFfHL0TlvBVLfVrVWbKAZ+zJhqtVUWopFYTK/uMXzw4d1fHDrsAQ86E2ez
        vUwg0zU1aiKD3Vwm62VrPa2ayAEdO0tguPdAISdGdBBw+Xon7TY1lKIHyZzXoMVt
        AVL1kvUY8duxTUffvO2ka5SHcMEijdDn2rJrUiEK/6axlp0+AREZM+Mv5t0rGXr8
        g3SI7/0lMiZD19Cb6v7Vjf4X6HrDQDI2Lo37HtY9uhTrI0VvVjbZSCf4RE8VnOaj
        A/XcBoOFMx3PBA==
X-ME-Sender: <xms:XezKXr8NeFaYV-ewXkksO5Z3nMqRxesF7ih2xvwVe3ntMWPPTJOA8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XezKXnuQgUP4b7WOnTnwcqqgheltpWf1IkUnrIg87hA0JxiljhBp-g>
    <xmx:XezKXpBevfjUDRcCDCy3PcvjDDVzuuRZ8WALi1aPN8sIkKBZc-8C3A>
    <xmx:XezKXncPOl2Vffsnb2EwByQN9bwyFABhZWtq1KvtZJVrQO_-spEnlw>
    <xmx:XezKXq3yoFTv9tTGRiCQF2R1gv4KWuq24h0XMZpFnkMrbEHy5y_7NA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8AE03066532;
        Sun, 24 May 2020 17:51:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/11] mlxsw: spectrum: Rename IGMP trap group
Date:   Mon, 25 May 2020 00:50:57 +0300
Message-Id: <20200524215107.1315526-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The IGMP trap group will be used for MLD traps in the next patch, so
rename it to "MC_SNOOPING" which is more appropriate.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 3c3db1c874b6..602f9fdfd7ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5531,7 +5531,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_IGMP,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dfafd30c57b9..3457a3058eee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4046,11 +4046,11 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, LLDP, TRAP_TO_CPU,
 		  false, SP_LLDP, DISCARD),
 	MLXSW_SP_RXL_MARK(DHCP, MIRROR_TO_CPU, DHCP, false),
-	MLXSW_SP_RXL_MARK(IGMP_QUERY, MIRROR_TO_CPU, IGMP, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, TRAP_TO_CPU, IGMP, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, TRAP_TO_CPU, IGMP, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V2_LEAVE, TRAP_TO_CPU, IGMP, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, TRAP_TO_CPU, IGMP, false),
+	MLXSW_SP_RXL_MARK(IGMP_QUERY, MIRROR_TO_CPU, MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IGMP_V2_LEAVE, TRAP_TO_CPU, MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, ARP, false),
 	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, ARP, false),
 	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, IP2ME, false),
@@ -4155,7 +4155,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			rate = 128;
 			burst_size = 7;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IGMP:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD:
 			rate = 16 * 1024;
 			burst_size = 10;
@@ -4235,7 +4235,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			priority = 4;
 			tc = 4;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IGMP:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD:
 			priority = 3;
-- 
2.26.2

