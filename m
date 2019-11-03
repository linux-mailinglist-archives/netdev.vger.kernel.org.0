Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60629ED298
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKCIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:33 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57167 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfKCIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 012D720E72;
        Sun,  3 Nov 2019 03:36:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=2cfvYZoprXi51CunqJM4/91WZMxxQZ3a+9W+EFt94K4=; b=i1TNGiAe
        zkyymKtma9K3l8zR0ydUfrVO0RGAxzK/0tgSTLpbwU4LBDMYBVgqnm//wfbd8Mep
        RiuG+lXhMbX5rnYOlT7+b3TgNyZrXB5tgIskGMQKIUCvb8ycnwzrIBvJBXi7Bg3F
        /gtoBJ9VSQEBczRyWuqHZDmI/hF8rrtwsp58Ay0dnqFZz0YGkmleyuR3MmRWvXjY
        3ZeA5fsZFSAIKgfMniEvVs53nmrAPiwW9KM+QDg+dz7ks3t4Bq/yiFWG8Hfhp47w
        AZq+XmUXXbYaQYguhJcKYZbG6jSQViOSKMUqfvIaASjT25ymfv/49PQVAh0YrxC7
        6LXkUnmNf8C5eQ==
X-ME-Sender: <xms:j5G-Xf3MtR4zTyGZMMvMa8EK6HgPbycctFB20RM5eGqXUMy5QwqBLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:j5G-XTWfztfXcA9tMK9TuK33HK8OkdNWexWkKIjDK7zLG6FSoQRgcg>
    <xmx:j5G-XRkHcxlIQr-vMsnc7G5_OoH9KELtpL1rI6P_CDaGYsAkAGwNnQ>
    <xmx:j5G-XdBxr5vLDr8-KCnSHIS4MjnL216U9gzEah9TEB-z-Oh46abNgw>
    <xmx:j5G-XV75onTyUUAHGMHrAxgSFNkFbIbq_peXIKqL56X4HT_mM5av7Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B51A306005F;
        Sun,  3 Nov 2019 03:36:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] mlxsw: core: Add support for EMAD string TLV parsing
Date:   Sun,  3 Nov 2019 10:35:52 +0200
Message-Id: <20191103083554.6317-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

During parsing of incoming EMADs, fill the string TLV's offset when it is
used.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1803b246d9b4..e166ce745150 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -382,17 +382,32 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 
 struct mlxsw_emad_tlv_offsets {
 	u16 op_tlv;
+	u16 string_tlv;
 	u16 reg_tlv;
 };
 
+static bool mlxsw_emad_tlv_is_string_tlv(const char *tlv)
+{
+	u8 tlv_type = mlxsw_emad_string_tlv_type_get(tlv);
+
+	return tlv_type == MLXSW_EMAD_TLV_TYPE_STRING;
+}
+
 static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
 {
 	struct mlxsw_emad_tlv_offsets *offsets =
 		(struct mlxsw_emad_tlv_offsets *) skb->cb;
 
 	offsets->op_tlv = MLXSW_EMAD_ETH_HDR_LEN;
+	offsets->string_tlv = 0;
 	offsets->reg_tlv = MLXSW_EMAD_ETH_HDR_LEN +
 			   MLXSW_EMAD_OP_TLV_LEN * sizeof(u32);
+
+	/* If string TLV is present, it must come after the operation TLV. */
+	if (mlxsw_emad_tlv_is_string_tlv(skb->data + offsets->reg_tlv)) {
+		offsets->string_tlv = offsets->reg_tlv;
+		offsets->reg_tlv += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
+	}
 }
 
 static char *mlxsw_emad_op_tlv(const struct sk_buff *skb)
-- 
2.21.0

