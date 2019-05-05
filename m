Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618B313DFC
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfEEGsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:48:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52837 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfEEGsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:48:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 279D32106A;
        Sun,  5 May 2019 02:48:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 May 2019 02:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=a7o9M1+LINeV+UFn/hpUrYF9ZzsC6+gtZn9wKufuFi0=; b=3ia+yNBf
        SS1YAvihnkh4EywOUdK8E1wL3a2e0ljOi+8JlkS82k71pvUeHnCdZeIRAc2wLNqz
        dZm0EvYpCOVJOZEaIz/sdvc6RbCkt5x29h0sxoYTNGdFl9bz2Ty+OTsDXReME0Os
        1gV2gTpDNX4sLY0Jp539mZmpDcRNFwUQGQsj79XyMKVbNzWdaUh/P2JE3mPnkErL
        v5QhsHx/yMecguRHAWJqRAq0xmzGcchu7/ON14MmgadGPw44ts20oJWQxqXzBkA/
        GL5iDRMC4aGwjHF59Bmg7yHJ84urvyNMWddwAGXqZYgbbQnirf+29ba8JIE1dhy9
        Cc9SKI69mrmSXg==
X-ME-Sender: <xms:RYfOXKK6pw4m4qMHbbydu8_BWRy2iiBbSUh5mT_P4g7SzenA-TUxYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:RYfOXHoiD8MbP7hBZYBaUtIcCtLk3q5hrVJqcXLqoKREefQge2Q2uw>
    <xmx:RYfOXDDh_ZxV863bx5cSs89vjVcs9CMSkjZjtLTFU_MNq8mQWibI1g>
    <xmx:RYfOXNfAYMRbJHeLW0QZlt__7sTXXsNnJ33jb_ZQwHqShn9NlGBUuw>
    <xmx:RYfOXKU7bohDrnzZWvCOiZ3Bn5XtfNGfLh8loNAA2pSySnKVIH9dLQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1CB7E432B;
        Sun,  5 May 2019 02:48:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: reg: Add Port Physical Loopback Register
Date:   Sun,  5 May 2019 09:48:05 +0300
Message-Id: <20190505064807.27925-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505064807.27925-1-idosch@idosch.org>
References: <20190505064807.27925-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The PPLR register allows configuration of the port's loopback mode.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e1ee7f4994db..e8002bfc1e8f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5210,6 +5210,42 @@ static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u8 local_port)
 	mlxsw_reg_pspa_sub_port_set(payload, 0);
 }
 
+/* PPLR - Port Physical Loopback Register
+ * --------------------------------------
+ * This register allows configuration of the port's loopback mode.
+ */
+#define MLXSW_REG_PPLR_ID 0x5018
+#define MLXSW_REG_PPLR_LEN 0x8
+
+MLXSW_REG_DEFINE(pplr, MLXSW_REG_PPLR_ID, MLXSW_REG_PPLR_LEN);
+
+/* reg_pplr_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pplr, local_port, 0x00, 16, 8);
+
+/* Phy local loopback. When set the port's egress traffic is looped back
+ * to the receiver and the port transmitter is disabled.
+ */
+#define MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL BIT(1)
+
+/* reg_pplr_lb_en
+ * Loopback enable.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pplr, lb_en, 0x04, 0, 8);
+
+static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
+				       bool phy_local)
+{
+	MLXSW_REG_ZERO(pplr, payload);
+	mlxsw_reg_pplr_local_port_set(payload, local_port);
+	mlxsw_reg_pplr_lb_en_set(payload,
+				 phy_local ?
+				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
+}
+
 /* HTGT - Host Trap Group Table
  * ----------------------------
  * Configures the properties for forwarding to CPU.
@@ -9981,6 +10017,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pptb),
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
+	MLXSW_REG(pplr),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
 	MLXSW_REG(rgcr),
-- 
2.20.1

