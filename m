Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C47E583E1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfF0Nxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45625 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfF0Nxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E9610221BD;
        Thu, 27 Jun 2019 09:53:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=beIA4HaohOB1UGUUKhrA2a8OWUveyS6ol9zLJ57nxGA=; b=KVfrpu9k
        tqOKvtVsJI9KBqj1vvvVI4oStQr4tXRYc5MpoK/jmsJWGudEHAUsryBFV94D/0BV
        HzNLeGwBpvhv8BleIjEtj0KMnPquISbErKCwVyI1jcjovHY9EEFXxjqc/gEnABUb
        MgZ0cZ/JVcWlvwyhYRvrwQ1iZlKGUcuFvAF/Bhv+qjSioeIIYm88oVj4G5ytxeH9
        FVw1GNWVdlLVhR8+7QmqETRaHANRW3SSifgURRB+cTd11CUKppsaUSw1tIBlJhu3
        61oCjiozZBblGhFEghZq8MvFUJYmAS2tH/GwhBS+j4prKNnqbL+zhjGrO7gQd4Ct
        0WHnCJnBBuqdJw==
X-ME-Sender: <xms:ZMoUXZrbq6w56NWbmER_qJbZvXyuSvdVoRQHhty0AdOENJjbS-bmkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:ZMoUXWqVw1p1KkbF8gdI0t4rZq32XqM0vWNjpbf-UeKxc2GM0O-mhA>
    <xmx:ZMoUXapv_wg1CV0BTyF_05VojUIVvVg1_Wrjbp7xw4FH9v5Wwf0AAQ>
    <xmx:ZMoUXVbxF01s4kUk30YJGaZYafEaXL0ByUhB4QSf1e2Kh7f3-04Vfg>
    <xmx:ZMoUXbfELEqYqcE3rmGKPjUx-21gxQlw9fv0ZOJ6tO5iQpiUC08Iug>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DE7E8006F;
        Thu, 27 Jun 2019 09:53:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/16] mlxsw: reg: Add Monitoring Time Precision Packet Port Configuration Register
Date:   Thu, 27 Jun 2019 16:52:44 +0300
Message-Id: <20190627135259.7292-2-idosch@idosch.org>
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

