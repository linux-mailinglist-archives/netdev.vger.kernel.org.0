Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF5583E2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfF0Nxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34341 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfF0Nxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E9F7B221BD;
        Thu, 27 Jun 2019 09:53:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QSEkdqppHWhbjU+QrdfUi4aKcumM+V5FL9ofE79/r5U=; b=mK6ITTAU
        zQSPlg3Fcw9ocS3qEGmj5dNkyL4c+HsxvDZr4Aj9MadNdVTID8rH4CBJfVISU6m6
        N1qj7rgFSBqPTiuYE0dJ3uEbs+0fKAm7csYI2LylZAVkiMD/cVAbrjjT0yWckFq4
        kMfZSCKho215ew+g90sr36SmZN8nE4N1nSwE5uv7unMEXhfFmzKG1TyN5PjOdzoC
        8EqisGuCsIq+XcnbpfKtnt4BqOyCfLlagN4fLLl+lb1wS+mYtGnNn7fTRMCaWwq+
        0qGGU2nE8gysZePSSGgCA2d3V/txfppDCvw358qCiDeNe9nihXnXiXBgsoTD7O/+
        9EOWw4ZWlhc7dg==
X-ME-Sender: <xms:ZsoUXa6uiEtd7Vvwlro9OsbEacnAQ7alCXHMD5trwvd4xerRiXlwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:ZsoUXVI5K5h-ov5-kAeERzjh2OUpS3fXWuxCDTSCIZEfR662HqSeTw>
    <xmx:ZsoUXbO4SDrao33l7ZKQ4R2zOGJM4CPyRpIL8Rak3H9EEYD7rAfZhA>
    <xmx:ZsoUXQnPaPbliy9QN6oklnCxRfyCrAMeYc2kGFOGKK3cL4Wjz8bxrw>
    <xmx:ZsoUXWBjy6g2cLOTjCorZ2Rk87yN8fGFz8y2S909qRPLOdczZuY5KQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AF0180062;
        Thu, 27 Jun 2019 09:53:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/16] mlxsw: reg: Add Monitoring Precision Time Protocol Trap Register
Date:   Thu, 27 Jun 2019 16:52:45 +0300
Message-Id: <20190627135259.7292-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This register is used for configuring under which trap to deliver PTP
packets depending on type of the packet.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 971e336aa9ac..5c5f63289468 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9185,6 +9185,44 @@ static inline void mlxsw_reg_mtpppc_pack(char *payload, u16 ing, u16 egr)
 	mlxsw_reg_mtpppc_egr_timestamp_message_type_set(payload, egr);
 }
 
+/* MTPTPT - Monitoring Precision Time Protocol Trap Register
+ * ---------------------------------------------------------
+ * This register is used for configuring under which trap to deliver PTP
+ * packets depending on type of the packet.
+ */
+#define MLXSW_REG_MTPTPT_ID 0x9092
+#define MLXSW_REG_MTPTPT_LEN 0x08
+
+MLXSW_REG_DEFINE(mtptpt, MLXSW_REG_MTPTPT_ID, MLXSW_REG_MTPTPT_LEN);
+
+enum mlxsw_reg_mtptpt_trap_id {
+	MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
+	MLXSW_REG_MTPTPT_TRAP_ID_PTP1,
+};
+
+/* reg_mtptpt_trap_id
+ * Trap id.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtptpt, trap_id, 0x00, 0, 4);
+
+/* reg_mtptpt_message_type
+ * Bitwise vector of PTP message types to trap. This is a necessary but
+ * non-sufficient condition since need to enable also per port. See MTPPPC.
+ * Message types are defined by IEEE 1588 Each bit corresponds to a value (e.g.
+ * Bit0: Sync, Bit1: Delay_Req)
+ */
+MLXSW_ITEM32(reg, mtptpt, message_type, 0x04, 0, 16);
+
+static inline void mlxsw_reg_mtptptp_pack(char *payload,
+					  enum mlxsw_reg_mtptpt_trap_id trap_id,
+					  u16 message_type)
+{
+	MLXSW_REG_ZERO(mtptpt, payload);
+	mlxsw_reg_mtptpt_trap_id_set(payload, trap_id);
+	mlxsw_reg_mtptpt_message_type_set(payload, message_type);
+}
+
 /* MGPIR - Management General Peripheral Information Register
  * ----------------------------------------------------------
  * MGPIR register allows software to query the hardware and
@@ -10254,6 +10292,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mtpppc),
+	MLXSW_REG(mtptpt),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
-- 
2.20.1

