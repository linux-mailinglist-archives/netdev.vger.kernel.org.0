Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADB72D7C7C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393846AbgLKRJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:09:15 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47327 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394475AbgLKRHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 77D65B1D;
        Fri, 11 Dec 2020 12:05:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Nht3Sqm2rXu9/3+Q73wIFylFg6P1bhehK5mi+WuCtos=; b=gli770oZ
        ollF8KELDcCka3kETTzjYt90TkZNlARoRdQpOWvjtVEib6o1dvFkFk0gzz31Gvqp
        gEJUmrRhlllCmUKMYFqOFM8ljn6MRQoNwwIduTrtbt15cUmJf6DVuY1GGlReFmcO
        7/KF2YWf3kfBm6QnkCI6WqBpUCgElViHiHEw/ZgtpIrbEVohaCMMNSiSr1Ykzx8w
        sKqFWOfghum5bzFn6lDaZ/6Nop/qzNUunP+cGgkFgMtZfjAfvU7KXa3mCNAe3byv
        eE38FK4W/0H/Dby4FtyTRvlGwfWPePX7Z37UsFhxSw1KYkUTMPzS11EWMfITDGve
        mN8JC3uCF39KsQ==
X-ME-Sender: <xms:1abTX-8Hp7mbr7ZHJ-k-r-DG_ekWShPfCCq_kKilgEe8JQXFFe1MEQ>
    <xme:1abTX-s2iffwbyDjyZh5GgBnnZk6noOm6lxciTZ-44frvX7wc5GLX8VTN5D1aGUsy
    NvPoEQ7_Lw-tcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1abTX0Dcxw7S8hqpMfSaeKiyfBZ-hNSgeC1bCMHVEeZFtdADwiXhhA>
    <xmx:1abTX2ez3aoIvfofRKB4MJlgfEhb1nVRDpjt221GSqudxN8Djr8xrw>
    <xmx:1abTXzOxy-BPml9zhBQ8wQwyERCqISb9v7bUKL3J_GKeYoFGfEscNQ>
    <xmx:1qbTX8aReoPyhYRGiEbdXrNWvDDlEz0Uq1yFXFCdhVxRKdkUKcB7AA>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7F4D1080057;
        Fri, 11 Dec 2020 12:05:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: reg: Add Router LPM Cache ML Delete Register
Date:   Fri, 11 Dec 2020 19:04:09 +0200
Message-Id: <20201211170413.2269479-12-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RLCMLD register is used to bulk delete the XLT-LPM cache ML entries.
This can be used by SW when L is increased or decreased, thus need to
remove entries with old ML values.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 111 ++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0e3abb315e06..f1c5a532454e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8543,6 +8543,116 @@ static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v
 	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
 }
 
+/* RLCMLD - Router LPM Cache ML Delete Register
+ * --------------------------------------------
+ * The RLCMLD register is used to bulk delete the XLT-LPM cache ML entries.
+ * This can be used by SW when L is increased or decreased, thus need to
+ * remove entries with old ML values.
+ */
+
+#define MLXSW_REG_RLCMLD_ID 0x8055
+#define MLXSW_REG_RLCMLD_LEN 0x30
+
+MLXSW_REG_DEFINE(rlcmld, MLXSW_REG_RLCMLD_ID, MLXSW_REG_RLCMLD_LEN);
+
+enum mlxsw_reg_rlcmld_select {
+	MLXSW_REG_RLCMLD_SELECT_ML_ENTRIES,
+	MLXSW_REG_RLCMLD_SELECT_M_ENTRIES,
+	MLXSW_REG_RLCMLD_SELECT_M_AND_ML_ENTRIES,
+};
+
+/* reg_rlcmld_select
+ * Which entries to delete.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, select, 0x00, 16, 2);
+
+enum mlxsw_reg_rlcmld_filter_fields {
+	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_PROTOCOL = 0x04,
+	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_VIRTUAL_ROUTER = 0x08,
+	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_DIP = 0x10,
+};
+
+/* reg_rlcmld_filter_fields
+ * If a bit is '0' then the relevant field is ignored.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, filter_fields, 0x00, 0, 8);
+
+enum mlxsw_reg_rlcmld_protocol {
+	MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV4,
+	MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV6,
+};
+
+/* reg_rlcmld_protocol
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, protocol, 0x08, 0, 4);
+
+/* reg_rlcmld_virtual_router
+ * Virtual router ID.
+ * Range is 0..cap_max_virtual_routers-1
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, virtual_router, 0x0C, 0, 16);
+
+/* reg_rlcmld_dip
+ * The prefix of the route or of the marker that the object of the LPM
+ * is compared with. The most significant bits of the dip are the prefix.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, dip4, 0x1C, 0, 32);
+MLXSW_ITEM_BUF(reg, rlcmld, dip6, 0x10, 16);
+
+/* reg_rlcmld_dip_mask
+ * per bit:
+ * 0: no match
+ * 1: match
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rlcmld, dip_mask4, 0x2C, 0, 32);
+MLXSW_ITEM_BUF(reg, rlcmld, dip_mask6, 0x20, 16);
+
+static inline void __mlxsw_reg_rlcmld_pack(char *payload,
+					   enum mlxsw_reg_rlcmld_select select,
+					   enum mlxsw_reg_rlcmld_protocol protocol,
+					   u16 virtual_router)
+{
+	u8 filter_fields = MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_PROTOCOL |
+			   MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_VIRTUAL_ROUTER |
+			   MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_DIP;
+
+	MLXSW_REG_ZERO(rlcmld, payload);
+	mlxsw_reg_rlcmld_select_set(payload, select);
+	mlxsw_reg_rlcmld_filter_fields_set(payload, filter_fields);
+	mlxsw_reg_rlcmld_protocol_set(payload, protocol);
+	mlxsw_reg_rlcmld_virtual_router_set(payload, virtual_router);
+}
+
+static inline void mlxsw_reg_rlcmld_pack4(char *payload,
+					  enum mlxsw_reg_rlcmld_select select,
+					  u16 virtual_router,
+					  u32 dip, u32 dip_mask)
+{
+	__mlxsw_reg_rlcmld_pack(payload, select,
+				MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV4,
+				virtual_router);
+	mlxsw_reg_rlcmld_dip4_set(payload, dip);
+	mlxsw_reg_rlcmld_dip_mask4_set(payload, dip_mask);
+}
+
+static inline void mlxsw_reg_rlcmld_pack6(char *payload,
+					  enum mlxsw_reg_rlcmld_select select,
+					  u16 virtual_router,
+					  const void *dip, const void *dip_mask)
+{
+	__mlxsw_reg_rlcmld_pack(payload, select,
+				MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV6,
+				virtual_router);
+	mlxsw_reg_rlcmld_dip6_memcpy_to(payload, dip);
+	mlxsw_reg_rlcmld_dip_mask6_memcpy_to(payload, dip_mask);
+}
+
 /* Note that XLTQ, XMDR, XRMT and XRALXX register positions violate the rule
  * of ordering register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -11917,6 +12027,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rmft2),
 	MLXSW_REG(rxlte),
 	MLXSW_REG(rxltm),
+	MLXSW_REG(rlcmld),
 	MLXSW_REG(xltq),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xrmt),
-- 
2.29.2

