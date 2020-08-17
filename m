Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B122466B2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgHQMwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:52:55 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:53713 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728460AbgHQMwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:52:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id BA6493CA;
        Mon, 17 Aug 2020 08:52:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9Yq33ndBPm2JTNKrE2BgBjBPYn1WEP/sFtVlS8Smhq0=; b=awfjKvdn
        sNkYpmmEApkoGjgvhXKuaDhZN06jPiCQR0mdqqvxEltVmlZ8/7tFurk2exhYBPCL
        UobOcGIs/117RuVLM64BsGdKVmp4v5R3c1QfjC9+vfGsaSe2VroRuiJJFqssAe+Z
        tV+D1f3vLf6Zsk9mZE9n08BJEzgBy3g6+svQKyGszqKnGPild73no9SHflhA42IU
        BqJMbPZ+lmiZLJ6KeI3VeIbMh9yJ7oXwoCdLUBaV7AVdPlV3/9OSHvqMclhOdxr4
        lWkabrYjjlv/L123/3ri7l+Nvt3UvQVDR936aFVBbkv6GhHuOerq+hmuoc2h+WOt
        KF68sMCjmNQlWw==
X-ME-Sender: <xms:pH06X4DWMfOJAIEEDqki3tY5yYQ3k23cxOc20Sy02lga_SoqpJ4Zjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:pH06X6hw5VgCKviHp6DcUhPO9bEiloCYPx5GOifEq9v7vmtWqUnXmA>
    <xmx:pH06X7k_KH-JKePGzl62RInLMm8aE71uncj2LI-50MmBuQr-cTrCjw>
    <xmx:pH06X-zD0r5-tTzjPvxenCwaNDRLquPJqo0o5OETY3DqRyITy8W_QQ>
    <xmx:pH06XzDZL0woxLx_hZeXLOR20acRC_A6N-QlvSaTYRk5xTAbGbaNwzNJL_8>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD2C03060067;
        Mon, 17 Aug 2020 08:52:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/6] mlxsw: reg: Add Tunneling NVE Counters Register
Date:   Mon, 17 Aug 2020 15:50:57 +0300
Message-Id: <20200817125059.193242-5-idosch@idosch.org>
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

The TNCR register exposes counters of NVE encapsulation and
decapsulation on Spectrum-1.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 51 +++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 079b080de7f7..9f19127caf83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10070,6 +10070,56 @@ static inline void mlxsw_reg_tngcr_pack(char *payload,
 	mlxsw_reg_tngcr_nve_group_size_flood_set(payload, 1);
 }
 
+/* TNCR - Tunneling NVE Counters Register
+ * --------------------------------------
+ * The TNCR register exposes counters of NVE encapsulation and decapsulation.
+ *
+ * Note: Not supported by Spectrum-2 onwards.
+ */
+#define MLXSW_REG_TNCR_ID 0xA002
+#define MLXSW_REG_TNCR_LEN 0x30
+
+MLXSW_REG_DEFINE(tncr, MLXSW_REG_TNCR_ID, MLXSW_REG_TNCR_LEN);
+
+/* reg_tncr_clear_counters
+ * Clear counters.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, tncr, clear_counters, 0x00, 31, 1);
+
+/* reg_tncr_count_encap
+ * Count number of packets which did encapsulation to an NVE tunnel.
+ * Access: RO
+ *
+ * Note: Multicast packets which are encapsulated multiple times are counted
+ * multiple times.
+ */
+MLXSW_ITEM64(reg, tncr, count_encap, 0x10, 0, 64);
+
+/* reg_tncr_count_decap
+ * Count number of packets which did decapsulation from an NVE tunnel.
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, tncr, count_decap, 0x18, 0, 64);
+
+/* reg_tncr_count_decap_errors
+ * Count number of packets which had decapsulation errors from an NVE tunnel.
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, tncr, count_decap_errors, 0x20, 0, 64);
+
+/* reg_tncr_count_decap_discards
+ * Count number of packets which had decapsulation discards from an NVE tunnel.
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, tncr, count_decap_discards, 0x28, 0, 64);
+
+static inline void mlxsw_reg_tncr_pack(char *payload, bool clear_counters)
+{
+	MLXSW_REG_ZERO(tncr, payload);
+	mlxsw_reg_tncr_clear_counters_set(payload, clear_counters);
+}
+
 /* TNUMT - Tunneling NVE Underlay Multicast Table Register
  * -------------------------------------------------------
  * The TNUMT register is for building the underlay MC table. It is used
@@ -11001,6 +11051,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtptpt),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(tngcr),
+	MLXSW_REG(tncr),
 	MLXSW_REG(tnumt),
 	MLXSW_REG(tnqcr),
 	MLXSW_REG(tnqdr),
-- 
2.26.2

