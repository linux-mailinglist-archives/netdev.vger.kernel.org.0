Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743522466B3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgHQMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:53:07 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:51495 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728317AbgHQMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:53:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 9643E3D4;
        Mon, 17 Aug 2020 08:53:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1y0pxL/D4napyzVCBXtQaBi7cF5gb039FBxvu0mwCDg=; b=C/cZorCy
        8Yg0JYXYbuFOR+hzifEjHoDVqOghAGKu9TkB1NuOSsKIDXty39hjzDRe453ty/nL
        wD7WJj9iSr4WY33zaTXRJ6ZzWMyjce2wPQgqThNUlSkKu8ww9rvwtskQmSS3fuQG
        e3Udgfx7izK1WLAHusJpvtthU6M80DyThwAIRie2vv7nQ9fjs01lUCX+N0iK+6yv
        7mOX7EaGM8Dr6+5BLSs9YfSoaBrlY4VT4uXAO1+iaGJuneTAmNe9eBJLRRNyjzI2
        Md9irkCwCnkq0jLOV7/Lxr14viUWDeqvv/SnqrMOmCOMoUrHZREa+1mj1wF9ju4E
        aLzQkmPIYmYihA==
X-ME-Sender: <xms:sH06X6LdhCvyiRC7GOOuqtLOYyvXgOfS7eOpOjEjKJH0drK_YXt8cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sH06XyIGAPyXvFyzMha4ssbM1-fVsh4rB7VinZPQJe0LprAq1NE7DQ>
    <xmx:sH06X6uAPWxKQhYLO_l8dTaHsxwArkKzefCd-li4j-RhG76ShGQExQ>
    <xmx:sH06X_bWUIT5axZTl2Nzi4fWjCzCtwL8ulF5qvpzGQ-izO3a92Yb-A>
    <xmx:sH06X1qRUdkE2nfhXYbt8likiqxOK068a61qFeUqTaC8BeYh0id3FLWoZRE>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3950030600A3;
        Mon, 17 Aug 2020 08:52:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 5/6] mlxsw: reg: Add Tunneling NVE Counters Register Version 2
Date:   Mon, 17 Aug 2020 15:50:58 +0300
Message-Id: <20200817125059.193242-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The TNCR-V2 register exposes counters of NVE encapsulation and
decapsulation on Spectrum-2 onwards.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 9f19127caf83..c891fc590ddd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10210,6 +10210,58 @@ static inline void mlxsw_reg_tnumt_pack(char *payload,
 	mlxsw_reg_tnumt_record_size_set(payload, record_size);
 }
 
+/* TNCR-V2 - Tunneling NVE Counters Register Version 2
+ * ---------------------------------------------------
+ * The TNCR-V2 register exposes counters of NVE encapsulation and
+ * decapsulation.
+ *
+ * Note: Not supported by Spectrum-1.
+ */
+#define MLXSW_REG_TNCR2_ID 0xA004
+#define MLXSW_REG_TNCR2_LEN 0x38
+
+MLXSW_REG_DEFINE(tncr2, MLXSW_REG_TNCR2_ID, MLXSW_REG_TNCR2_LEN);
+
+/* reg_tncr2_clear_counters
+ * Clear counters.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, tncr2, clear_counters, 0x00, 31, 1);
+
+enum mlxsw_reg_tncr2_tunnel_port {
+	MLXSW_REG_TNCR2_TUNNEL_PORT_NVE,
+	MLXSW_REG_TNCR2_TUNNEL_PORT_VPLS,
+	MLXSW_REG_TNCR2_TUNNEL_FLEX_TUNNEL0,
+	MLXSW_REG_TNCR2_TUNNEL_FLEX_TUNNEL1,
+};
+
+/* reg_tncr2_tunnel_port
+ * Tunnel port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, tncr2, tunnel_port, 0x00, 0, 4);
+
+/* reg_tncr2_count_decap_discards
+ * Count number of packets which had decapsulation discards from an NVE tunnel.
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, tncr2, count_decap_discards, 0x28, 0, 64);
+
+/* reg_tncr2_count_encap_discards
+ * Count number of packets which had encapsulation discards to an NVE tunnel.
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, tncr2, count_encap_discards, 0x30, 0, 64);
+
+static inline void mlxsw_reg_tncr2_pack(char *payload,
+					enum mlxsw_reg_tncr2_tunnel_port tport,
+					bool clear_counters)
+{
+	MLXSW_REG_ZERO(tncr2, payload);
+	mlxsw_reg_tncr2_clear_counters_set(payload, clear_counters);
+	mlxsw_reg_tncr2_tunnel_port_set(payload, tport);
+}
+
 /* TNQCR - Tunneling NVE QoS Configuration Register
  * ------------------------------------------------
  * The TNQCR register configures how QoS is set in encapsulation into the
@@ -11053,6 +11105,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tncr),
 	MLXSW_REG(tnumt),
+	MLXSW_REG(tncr2),
 	MLXSW_REG(tnqcr),
 	MLXSW_REG(tnqdr),
 	MLXSW_REG(tneem),
-- 
2.26.2

