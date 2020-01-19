Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2F3141DF3
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgASNBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:55 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56283 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbgASNBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7323B21E44;
        Sun, 19 Jan 2020 08:01:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ONgu2GQ1RmdVNHauxBJHOpoKg9EIMOKfMoKKubSqPcc=; b=Vlyu6EHB
        L/EaTzNsX0ECGN/jGyy+gvWxlid49zzCCXheFdvWZhu7dNT/ioeN19QyPRICeYhL
        V07FyzTt5O46c1eSHwpVvkqw1Y4a5Pxn8LQ4xdc1xYzGZuEjGGg6u0wQlB35OSNx
        eYUQoWJo8wYsDNClg8cyxTLxKUb0LuhmHKB8jeG2ks8EksW1bT7xdbCIzTuFCHZh
        GPbvsHqBPIP/S/qi/XA+M+wuUZ6+MlCE68fa2ZPdVnBI8S/Qn2T+7tuVnMICEyAI
        KZsOZ7p1DRsbaUTXBH/GOLxF4guBI2H+SEdtYDq+4npz7bGwLatyYM9UZppwYpZT
        +178yY2daChaAQ==
X-ME-Sender: <xms:LVMkXlKbL8QhLoN9nU8UpbiZPQsrmkYsLRGnRoKHC4jjwyGhC1lRsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:LVMkXp0b2AuHZWR6oYYI6oTJXJjp6UkK4Q8LJBXSZE9vbVi4Wv2ymw>
    <xmx:LVMkXtpkFMIwu1PEzD4jNrjtdQfLt2T9QklroCuINYD7MC9UAfTvkw>
    <xmx:LVMkXi7FpMcjCV_BqkrZ_I1xcybtWeCW34Qoklv6vcqIDw6qKf_vow>
    <xmx:LVMkXtZWvg6ZVM-lLH-RI-DJpKH8TJgVjQ7cOLOnPmJUthdddAQnAg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3279480062;
        Sun, 19 Jan 2020 08:01:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/15] mlxsw: reg: Add Tunneling IPinIP Decapsulation ECN Mapping Register
Date:   Sun, 19 Jan 2020 15:00:51 +0200
Message-Id: <20200119130100.3179857-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

This register configures the actions that are done during IPinIP
decapsulation based on the ECN bits.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 57 +++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 19a84641d485..47c29776d5d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10170,6 +10170,62 @@ static inline void mlxsw_reg_tieem_pack(char *payload, u8 overlay_ecn,
 	mlxsw_reg_tieem_underlay_ecn_set(payload, underlay_ecn);
 }
 
+/* TIDEM - Tunneling IPinIP Decapsulation ECN Mapping Register
+ * -----------------------------------------------------------
+ * The TIDEM register configures the actions that are done in the
+ * decapsulation.
+ */
+#define MLXSW_REG_TIDEM_ID 0xA813
+#define MLXSW_REG_TIDEM_LEN 0x0C
+
+MLXSW_REG_DEFINE(tidem, MLXSW_REG_TIDEM_ID, MLXSW_REG_TIDEM_LEN);
+
+/* reg_tidem_underlay_ecn
+ * ECN field of the IP header in the underlay network.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, tidem, underlay_ecn, 0x04, 24, 2);
+
+/* reg_tidem_overlay_ecn
+ * ECN field of the IP header in the overlay network.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, tidem, overlay_ecn, 0x04, 16, 2);
+
+/* reg_tidem_eip_ecn
+ * Egress IP ECN. ECN field of the IP header of the packet which goes out
+ * from the decapsulation.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, tidem, eip_ecn, 0x04, 8, 2);
+
+/* reg_tidem_trap_en
+ * Trap enable:
+ * 0 - No trap due to decap ECN
+ * 1 - Trap enable with trap_id
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, tidem, trap_en, 0x08, 28, 4);
+
+/* reg_tidem_trap_id
+ * Trap ID. Either DECAP_ECN0 or DECAP_ECN1.
+ * Reserved when trap_en is '0'.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, tidem, trap_id, 0x08, 0, 9);
+
+static inline void mlxsw_reg_tidem_pack(char *payload, u8 underlay_ecn,
+					u8 overlay_ecn, u8 eip_ecn,
+					bool trap_en, u16 trap_id)
+{
+	MLXSW_REG_ZERO(tidem, payload);
+	mlxsw_reg_tidem_underlay_ecn_set(payload, underlay_ecn);
+	mlxsw_reg_tidem_overlay_ecn_set(payload, overlay_ecn);
+	mlxsw_reg_tidem_eip_ecn_set(payload, eip_ecn);
+	mlxsw_reg_tidem_trap_en_set(payload, trap_en);
+	mlxsw_reg_tidem_trap_id_set(payload, trap_id);
+}
+
 /* SBPR - Shared Buffer Pools Register
  * -----------------------------------
  * The SBPR configures and retrieves the shared buffer pools and configuration.
@@ -10715,6 +10771,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(tnpc),
 	MLXSW_REG(tigcr),
 	MLXSW_REG(tieem),
+	MLXSW_REG(tidem),
 	MLXSW_REG(sbpr),
 	MLXSW_REG(sbcm),
 	MLXSW_REG(sbpm),
-- 
2.24.1

