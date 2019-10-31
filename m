Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E96EACB2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfJaJmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38251 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfJaJmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 566D721FBC;
        Thu, 31 Oct 2019 05:42:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=K54IfPhnX3/5S26SmoE1T5UZUED1XoyTlMGOoBbVVEQ=; b=aMjtE8gn
        JXsEsLF+7zhNgJfFhnfQloVYcvh8q0uyr48FZVNlO4fV/CHv99gtXvPJsmFV5nMb
        ezM2Ow0emY/WRpry1yOonQU6xxWMsQviGO8blEv10e0QZh0Utccyd8IwZzn6vC/E
        JdfVAlonrTeqFk/QcXycwBfPJXMnPzFO9Pgj0ax7qQYKXO5WDbsWuKM5BMN0Rnu/
        6rF6kClw0GHq83zjzaQp6mldQ191ehDzBy/jfr72nYKEv3zEJJaiDlzJ+s2tYay0
        xXKjVC1LmD7/vIy5jYE7wEiZ0XqHJ3RW/Oq1HDx65NlNSLnja5kK6Ujuioybm6kU
        AT/hKlElAgbByQ==
X-ME-Sender: <xms:lay6XU3HE0Nrg1vDsUEiJJrqQjOk1F1AmmRvbX71SnDcqdkSL8lEUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:lay6Xb-bnX4IPKWheJVb6lkiguHM02h_aBiFPRQU2qom5mAJcfBzpA>
    <xmx:lay6XboThl5sVRrsCEqZICi2QZj44E211N39AfRNVogPE6j60tbGLg>
    <xmx:lay6XSGBem8IupXBIRHj8aLsN5TXimdEVcTVB4_egcU_bN_899nzvQ>
    <xmx:lqy6XaFcxcqvBBEHOoS6m36gD-WUmr7aof1xtOMUNN6-tS36MzNzKg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF1FF80065;
        Thu, 31 Oct 2019 05:42:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/16] mlxsw: reg: Add Port Module Type Mapping Register
Date:   Thu, 31 Oct 2019 11:42:07 +0200
Message-Id: <20191031094221.17526-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The PMTM allows query or configuration of module types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7fd6fd9c5244..bec035ee5349 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5375,6 +5375,55 @@ static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
 				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
 }
 
+/* PMTM - Port Module Type Mapping Register
+ * ----------------------------------------
+ * The PMTM allows query or configuration of module types.
+ */
+#define MLXSW_REG_PMTM_ID 0x5067
+#define MLXSW_REG_PMTM_LEN 0x10
+
+MLXSW_REG_DEFINE(pmtm, MLXSW_REG_PMTM_ID, MLXSW_REG_PMTM_LEN);
+
+/* reg_pmtm_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtm, module, 0x00, 16, 8);
+
+enum mlxsw_reg_pmtm_module_type {
+	/* Backplane with 4 lanes */
+	MLXSW_REG_PMTM_MODULE_TYPE_BP_4X,
+	/* QSFP */
+	MLXSW_REG_PMTM_MODULE_TYPE_BP_QSFP,
+	/* SFP */
+	MLXSW_REG_PMTM_MODULE_TYPE_BP_SFP,
+	/* Backplane with single lane */
+	MLXSW_REG_PMTM_MODULE_TYPE_BP_1X = 4,
+	/* Backplane with two lane */
+	MLXSW_REG_PMTM_MODULE_TYPE_BP_2X = 8,
+	/* Chip2Chip */
+	MLXSW_REG_PMTM_MODULE_TYPE_C2C = 10,
+};
+
+/* reg_pmtm_module_type
+ * Module type.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmtm, module_type, 0x04, 0, 4);
+
+static inline void mlxsw_reg_pmtm_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(pmtm, payload);
+	mlxsw_reg_pmtm_module_set(payload, module);
+}
+
+static inline void
+mlxsw_reg_pmtm_unpack(char *payload,
+		      enum mlxsw_reg_pmtm_module_type *module_type)
+{
+	*module_type = mlxsw_reg_pmtm_module_type_get(payload);
+}
+
 /* HTGT - Host Trap Group Table
  * ----------------------------
  * Configures the properties for forwarding to CPU.
@@ -10545,6 +10594,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
 	MLXSW_REG(pplr),
+	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
 	MLXSW_REG(rgcr),
-- 
2.21.0

