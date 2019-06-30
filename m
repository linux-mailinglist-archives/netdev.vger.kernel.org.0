Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AA35AEC8
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF3GFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:05:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53533 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbfF3GFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:05:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A7FCC21C0F;
        Sun, 30 Jun 2019 02:05:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=beIA4HaohOB1UGUUKhrA2a8OWUveyS6ol9zLJ57nxGA=; b=KiESOAMq
        kHbWMO4Q2RVsonuGgbjThi7COrNfeS613iF1V4XubTIwdesBmJ9KkcMHIVa3nrVs
        ekzRinRiskMfqllzhT1miqw4LLe7UVH1Vd1Admddg3QOFrml7pvrz+t8Fe2HCiG9
        C4kFA06nzYkXR4FP6d31LOY3A5ll0YqGDYmRBnmDxpOGpSKe+7oQxvhc1qmORJXv
        BrPUiUozqI2TwnvEzBRyLD69m37lKnar1GC8wu3T6BZ9YYUTr6Gs3t1Iybo966sa
        Jf9239ulPyLYF9rWcFOJrldIoJhZ3MX7jwUs6Rvyl35iXexl+MtZuA9L6faO3iRS
        iaViidlt47j5mQ==
X-ME-Sender: <xms:OVEYXfzqAojSDmMJPnQal83EOxJ4V3GW9k47qj5oBmErPLlrFB4mVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:OVEYXeHazFTp05Rr-mkP7uZpMgBgSr0qoPBv8Z5LME_Cku-cRhuDYw>
    <xmx:OVEYXSTu2OreFzzQb_kye5SkPIULJiIgXJdvXM-My8Rg6QQ0PJkF2Q>
    <xmx:OVEYXcWIg707V4nvF-2ldShm0W3LdNAZNeJ9xjIwK4jKmkXb5Z8Wtw>
    <xmx:OVEYXexl-bsohxDKpMbOtCUBEM1mNIqWcIhURJxEDHNuAVw9pRTaNw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 055018005B;
        Sun, 30 Jun 2019 02:05:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/16] mlxsw: reg: Add Monitoring Time Precision Packet Port Configuration Register
Date:   Sun, 30 Jun 2019 09:04:45 +0300
Message-Id: <20190630060500.7882-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This register serves for configuration of which PTP messages should be
timestamped. This is a global configuration, despite the register name.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 38 +++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e5f6bfd8a35a..971e336aa9ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9148,6 +9148,43 @@ static inline void mlxsw_reg_mprs_pack(char *payload, u16 parsing_depth,
 	mlxsw_reg_mprs_vxlan_udp_dport_set(payload, vxlan_udp_dport);
 }
 
+/* MTPPPC - Time Precision Packet Port Configuration
+ * -------------------------------------------------
+ * This register serves for configuration of which PTP messages should be
+ * timestamped. This is a global configuration, despite the register name.
+ *
+ * Reserved when Spectrum-2.
+ */
+#define MLXSW_REG_MTPPPC_ID 0x9090
+#define MLXSW_REG_MTPPPC_LEN 0x28
+
+MLXSW_REG_DEFINE(mtpppc, MLXSW_REG_MTPPPC_ID, MLXSW_REG_MTPPPC_LEN);
+
+/* reg_mtpppc_ing_timestamp_message_type
+ * Bitwise vector of PTP message types to timestamp at ingress.
+ * MessageType field as defined by IEEE 1588
+ * Each bit corresponds to a value (e.g. Bit0: Sync, Bit1: Delay_Req)
+ * Default all 0
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpppc, ing_timestamp_message_type, 0x08, 0, 16);
+
+/* reg_mtpppc_egr_timestamp_message_type
+ * Bitwise vector of PTP message types to timestamp at egress.
+ * MessageType field as defined by IEEE 1588
+ * Each bit corresponds to a value (e.g. Bit0: Sync, Bit1: Delay_Req)
+ * Default all 0
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpppc, egr_timestamp_message_type, 0x0C, 0, 16);
+
+static inline void mlxsw_reg_mtpppc_pack(char *payload, u16 ing, u16 egr)
+{
+	MLXSW_REG_ZERO(mtpppc, payload);
+	mlxsw_reg_mtpppc_ing_timestamp_message_type_set(payload, ing);
+	mlxsw_reg_mtpppc_egr_timestamp_message_type_set(payload, egr);
+}
+
 /* MGPIR - Management General Peripheral Information Register
  * ----------------------------------------------------------
  * MGPIR register allows software to query the hardware and
@@ -10216,6 +10253,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mcda),
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
+	MLXSW_REG(mtpppc),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
-- 
2.20.1

