Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339981E0377
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388502AbgEXVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59639 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388494AbgEXVvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E25FF5C00A5;
        Sun, 24 May 2020 17:51:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EfNUitSnBqhNcIQDyVyhvcXoSE0G6rs3niPO6Uc9nIk=; b=1ZwHgScL
        f2WAME5+cUVqS/tHUIy8/kGluM+D7LnmTj89iMWcbUwr9Q4IDbfxMCeQRBjvFp1F
        3fBuf3DXePBHNLgifh3iwe8n5KDz1VER+OHb9SraQtmvqbEK8P9XUjbnZFzgx/un
        6iV6X2/cN7zt1JVZul1Z0BnVttsJHC2VpHoX/F24Tm3nXyMeR1AJMK04oRpkO1OP
        +0NeF2BRRp5ekk0YsZN6CmO9e+vTMHyn1B4MpSqGALTrE0F5Ip89b9BMHkCyfION
        /V+Zfuxv8XfiND/ul0rLWLxQGCGcD4NiP7B35Lr0FaNwAiLq90nfOhvhQe4DMYZm
        t5n+S204CMyiNQ==
X-ME-Sender: <xms:ZuzKXn3pgqHEZjgvt3nwUvuAobweStkKpQO12N7Eu0p3Zn2v8eBk8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZuzKXmHUtU9WjKfcTtcpx2qS8uXLAOPbvCMcRcbCgaJUJR_m1J_MLw>
    <xmx:ZuzKXn7rBiywWQ8aFsbWxvsX8weohYZwaeRRul4HgTdSz_G-Qn6cqA>
    <xmx:ZuzKXs3kkJeO_K_0yiilTJOXqKCwUj6zTSFNOtvHLe9amt7KjlptNQ>
    <xmx:ZuzKXsPcwAeu9T4Y7GRcxOG08DGvaQbv5D-3VyNaDz4R4kdPhZdsgw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD4FA306651E;
        Sun, 24 May 2020 17:51:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/11] mlxsw: spectrum: Rename ARP trap group
Date:   Mon, 25 May 2020 00:51:04 +0300
Message-Id: <20200524215107.1315526-9-idosch@idosch.org>
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

The ARP trap group will be used for IPv6 ND traps in the next patch, so
rename it to "NEIGH_DISCOVERY" which is more appropriate.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d51a4c4665d0..4d61c414348f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5536,7 +5536,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 978f6d98e8c4..6ef8222cc0ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4050,8 +4050,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_NO_MARK(IGMP_V2_LEAVE, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
-	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, ARP, false),
-	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, ARP, false),
+	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
+	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY, MIRROR_TO_CPU,
 			  MC_SNOOPING, false),
@@ -4112,8 +4112,9 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
 	/* NVE traps */
-	MLXSW_SP_RXL_MARK(NVE_ENCAP_ARP, TRAP_TO_CPU, ARP, false),
-	MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, TRAP_TO_CPU, ARP, false),
+	MLXSW_SP_RXL_MARK(NVE_ENCAP_ARP, TRAP_TO_CPU, NEIGH_DISCOVERY, false),
+	MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, TRAP_TO_CPU, NEIGH_DISCOVERY,
+			     false),
 	/* PTP traps */
 	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, PTP0, TRAP_TO_CPU,
 		  false, SP_PTP0, DISCARD),
@@ -4161,7 +4162,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			burst_size = 10;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
@@ -4238,7 +4239,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			priority = 3;
 			tc = 3;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
-- 
2.26.2

