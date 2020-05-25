Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B81E1812
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbgEYXG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48947 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388337AbgEYXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DC805C0186;
        Mon, 25 May 2020 19:06:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9zNBIXSDrNAe0PGBTdTR4j2VbBEptHBRXUtzX781Q9k=; b=oJ3S4Isc
        emGGmUQR2qavvLEOoHCUaX76IwlCTSN64PDYFwaoHXkf/dLk5eWJQxOioSaiPl5Q
        XFtraZRsOvmlNC+YCp0m5SquSyuxku2FcPOrCk+CCbTnj9cLmuP6q3notdglIfJE
        36qBgSJ7RU6u8330CxCvLQ6z0FWBTASo2ZBcI82XZFaYq5eAsoiB/XSFP8/BdOVM
        FSODYuL3j+yogDWzPAB282ACRpObY8ayVA4+I0+3pPUjc3SSsetMIaQQSCaAiz9A
        v1QWc1WkgnoN2f3h0o+4JKWZekHkW6+jxKbbLuL8JWALeC9SugdWPrAAGQE6GEaM
        gBiTtLF8kRtRsg==
X-ME-Sender: <xms:a0_MXmRN2J_QTqBsH4qZDgFkk17UfftxD62vzriNuP8R8Yp8wNTzcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:a0_MXrznxrwEcMBxAjo8eJRQAFFtsWntPf2MrRJo9tfzm-w2h5vJyA>
    <xmx:a0_MXj3rk7V0ZEoy8hzmNBm_z849gpZshgcy5Jj6eeaVk-6iZuvHBA>
    <xmx:a0_MXiBjczxZpXsC5P7Kg6hXzK_zIzi2lIoRKyZnag2B1OwajzHTOA>
    <xmx:a0_MXnayZ8S8yDBeubmPM86rOZc80vqGh-LptqyZ-gWu6BGzHNZKoA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 396AC3280064;
        Mon, 25 May 2020 19:06:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/14] mlxsw: spectrum: Rename IPv6 ND trap group
Date:   Tue, 26 May 2020 02:05:45 +0300
Message-Id: <20200525230556.1455927-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The IPv6 Neighbour Discovery (ND) group will be used for various IPv6
packets, not all of which fall under the definition of ND, so rename it
to "IPV6" which is more appropriate.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5b5b96a82a34..6df7cc8a69f1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5542,7 +5542,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e8c9fc4cb6fb..b420aa292d7c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4078,15 +4078,15 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(RTR_INGRESS0, TRAP_TO_CPU, REMOTE_ROUTE, false),
 	MLXSW_SP_RXL_MARK(IPV4_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(IPV6_BGP, TRAP_TO_CPU, BGP, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6_ND,
+	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6,
 			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISEMENT, TRAP_TO_CPU, IPV6_ND,
+	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISEMENT, TRAP_TO_CPU, IPV6,
 			  false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION, TRAP_TO_CPU,
 			  NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISEMENT, TRAP_TO_CPU,
 			  NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6_ND, false),
+	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, ROUTER_EXP, false),
@@ -4165,7 +4165,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
@@ -4239,7 +4239,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			tc = 3;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
 			priority = 2;
-- 
2.26.2

