Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C592A1E5A
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgKANmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:42:53 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33005 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgKANmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:42:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 629F55C00BD;
        Sun,  1 Nov 2020 08:42:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 08:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=e80ZeTL1w6jhNfDUB6TOcSibKSn9M2I2Nz8dFaa3D74=; b=cGvVajNQ
        VH2pPnG0B18GArP48FTMFq6kS3KfJcv1Ecjc4ZMrCVS+28u0Pgt/yVdvPMn/j9yP
        yQTyJYcx8n3FmAWALCqi+gQoaQSbgPJK0N9oBoZqTZuHJa8IHWu1ZyUqNX7JCvVk
        9lvl59kz9twtq5yfW/cZLmntsFyWAkpHjBMVTC+zJ/fiEipNsYn6jn93JI+NKHJz
        q9HapnEzkNq7y9IT/JFliX1qGINMrQvH+7QH9bIvCaSeXx4rZ4fZ9X1VaYfrvvO7
        nKMpba4HCqBSo6LUPhSuyC8qMl2y25MB0bQUSIONet0S1A6WfTkiE9EdUVjUFbGl
        /Ugpa3mQhklryA==
X-ME-Sender: <xms:W7ueX9kJgW-QFgY4D2PEXZ025HWJ-iRQS1-u_gjIh7wpMYgdcQk2XA>
    <xme:W7ueX41DzPK8Y8J1GR6LdnL-jDcNKOnU1veC5cGKU9H_L3YKXwBp7jWBIgTlazk1P
    JWq4v9VDRVGTbk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheehrddukedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W7ueXzrJBWkXEkHDS_V-zB9Gwu3L0aEpiCaJ7S82tWMnFfVln72QYw>
    <xmx:W7ueX9k1nPzwUbk5xUuFpsXk73IAI2HioleusU123BQa8wnL9q_iIA>
    <xmx:W7ueX72nM_VMGwM-WELk1HLnTOhr6phlMsB45X9_GKSin0e-P8Jg3g>
    <xmx:W7ueX5AP8w4KB6ROGRdFpabAVDyvFod5U-WV1LPaqW_JFq9p8mbSiQ>
Received: from shredder.mtl.com (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAF533064674;
        Sun,  1 Nov 2020 08:42:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] mlxsw: reg: Add XRALXX Registers
Date:   Sun,  1 Nov 2020 15:42:14 +0200
Message-Id: <20201101134215.713708-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201101134215.713708-1-idosch@idosch.org>
References: <20201101134215.713708-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add a couple of registers used to manipulate LPM trees on XM:
The XRALTA is used to allocate the XLT LPM trees.
The XRALST is used to set and query the structure of an XLT LPM tree.
The XRALTB register is used to bind virtual router and protocol to
an allocated LPM tree.

Since the XM registers are identical to the legacy router registers
with a fixed offset, re-use their pack functions.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 83 +++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 39eff6a57ba2..73aab72877fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8245,6 +8245,86 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
+/* Note that XRALXX register position violates the rule of ordering register
+ * definition by the ID. However, XRALXX pack helpers are using RALXX pack
+ * helpers, RALXX registers have higher IDs.
+ */
+
+/* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
+ * -----------------------------------------------------------
+ * The XRALTA is used to allocate the XLT LPM trees.
+ *
+ * This register embeds original RALTA register.
+ */
+#define MLXSW_REG_XRALTA_ID 0x7811
+#define MLXSW_REG_XRALTA_LEN 0x08
+#define MLXSW_REG_XRALTA_RALTA_OFFSET 0x04
+
+MLXSW_REG_DEFINE(xralta, MLXSW_REG_XRALTA_ID, MLXSW_REG_XRALTA_LEN);
+
+static inline void mlxsw_reg_xralta_pack(char *payload, bool alloc,
+					 enum mlxsw_reg_ralxx_protocol protocol,
+					 u8 tree_id)
+{
+	char *ralta_payload = payload + MLXSW_REG_XRALTA_RALTA_OFFSET;
+
+	MLXSW_REG_ZERO(xralta, payload);
+	mlxsw_reg_ralta_pack(ralta_payload, alloc, protocol, tree_id);
+}
+
+/* XRALST - XM Router Algorithmic LPM Structure Tree Register
+ * ----------------------------------------------------------
+ * The XRALST is used to set and query the structure of an XLT LPM tree.
+ *
+ * This register embeds original RALST register.
+ */
+#define MLXSW_REG_XRALST_ID 0x7812
+#define MLXSW_REG_XRALST_LEN 0x108
+#define MLXSW_REG_XRALST_RALST_OFFSET 0x04
+
+MLXSW_REG_DEFINE(xralst, MLXSW_REG_XRALST_ID, MLXSW_REG_XRALST_LEN);
+
+static inline void mlxsw_reg_xralst_pack(char *payload, u8 root_bin, u8 tree_id)
+{
+	char *ralst_payload = payload + MLXSW_REG_XRALST_RALST_OFFSET;
+
+	MLXSW_REG_ZERO(xralst, payload);
+	mlxsw_reg_ralst_pack(ralst_payload, root_bin, tree_id);
+}
+
+static inline void mlxsw_reg_xralst_bin_pack(char *payload, u8 bin_number,
+					     u8 left_child_bin,
+					     u8 right_child_bin)
+{
+	char *ralst_payload = payload + MLXSW_REG_XRALST_RALST_OFFSET;
+
+	mlxsw_reg_ralst_bin_pack(ralst_payload, bin_number, left_child_bin,
+				 right_child_bin);
+}
+
+/* XRALTB - XM Router Algorithmic LPM Tree Binding Register
+ * --------------------------------------------------------
+ * The XRALTB register is used to bind virtual router and protocol
+ * to an allocated LPM tree.
+ *
+ * This register embeds original RALTB register.
+ */
+#define MLXSW_REG_XRALTB_ID 0x7813
+#define MLXSW_REG_XRALTB_LEN 0x08
+#define MLXSW_REG_XRALTB_RALTB_OFFSET 0x04
+
+MLXSW_REG_DEFINE(xraltb, MLXSW_REG_XRALTB_ID, MLXSW_REG_XRALTB_LEN);
+
+static inline void mlxsw_reg_xraltb_pack(char *payload, u16 virtual_router,
+					 enum mlxsw_reg_ralxx_protocol protocol,
+					 u8 tree_id)
+{
+	char *raltb_payload = payload + MLXSW_REG_XRALTB_RALTB_OFFSET;
+
+	MLXSW_REG_ZERO(xraltb, payload);
+	mlxsw_reg_raltb_pack(raltb_payload, virtual_router, protocol, tree_id);
+}
+
 /* MFCR - Management Fan Control Register
  * --------------------------------------
  * This register controls the settings of the Fan Speed PWM mechanism.
@@ -11195,6 +11275,9 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
+	MLXSW_REG(xralta),
+	MLXSW_REG(xralst),
+	MLXSW_REG(xraltb),
 	MLXSW_REG(mfcr),
 	MLXSW_REG(mfsc),
 	MLXSW_REG(mfsm),
-- 
2.26.2

