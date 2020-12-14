Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD22D976D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438016AbgLNLdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:33:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58341 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437876AbgLNLce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B07B65C00A9;
        Mon, 14 Dec 2020 06:31:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=7lI11MtjNSMgM14iF5Kd9tOuUEofnvUAdFw5IN/V48I=; b=DuB7zdk4
        OfwxVuVxbG5DcFc4qKy0cDJDDkq7NsRzcPx4ncbY8Hy660/tC/oFYNSvJ2Eg5yuU
        dtLPiF29el0prfDvfqHK494yZgAzUju0XxtESPfDlodLOmuePB8oTpjRwUKoIjp4
        eLjnPGUJyU0XfrdCzlpcPkll8J0Qtg34CU2tMTHX8OPno4nwmrhYG+p84Rt85Gsi
        s5yhD2IUGkVwZrhYxiz5PJsiHgdgvH+6CaGKRO5lc4MzyiO1dtw2ad0HlUoe52yz
        nVSLOJcnPsrYFHNI6HYw9i2Vt2w/DoPk0ZF82uIOpiaUol0F06ObKgcISLutveUg
        SlH146PUzaj/JQ==
X-ME-Sender: <xms:_EzXXzDC2tFgtTrgJ4nsBvwJlBH7tGlm4cAl3lCdM_aEDXUp720bbA>
    <xme:_EzXX5jq0dAPy9DqFxq0Y5EuxqRaYlrePA6xv6WVI7mLEo5A3aSonvz23It0ZnhNC
    04EbINYoKMrmIc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_EzXX-nKpY0zK23nQWnVTBLapYzchEw5hnYJXmIgH94FHTnMTlsm-g>
    <xmx:_EzXX1wnlKXoJRc3N0fQa9mMmYKZGQi2xaECELcF_wDDGgysRdV-ZA>
    <xmx:_EzXX4QuhegALh_6OFfaNhdLEvUsYNv-BN3sSnOzPyX9RhNuCLApKg>
    <xmx:_EzXXzcI7iKPYnwz2MFlhtK4uvyE9eDsoMkpNBp9USU8FO5ZlRpBOw>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E641108005F;
        Mon, 14 Dec 2020 06:31:07 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/15] mlxsw: reg: Add Router XLT M select Register
Date:   Mon, 14 Dec 2020 13:30:32 +0200
Message-Id: <20201214113041.2789043-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RXLTM configures and selects the M for the XM lookups.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ebde4fc860e2..07445db6a018 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8512,6 +8512,37 @@ static inline void mlxsw_reg_rxlte_pack(char *payload, u16 virtual_router,
 	mlxsw_reg_rxlte_lpm_xlt_en_set(payload, lpm_xlt_en);
 }
 
+/* RXLTM - Router XLT M select Register
+ * ------------------------------------
+ * The RXLTM configures and selects the M for the XM lookups.
+ */
+
+#define MLXSW_REG_RXLTM_ID 0x8051
+#define MLXSW_REG_RXLTM_LEN 0x14
+
+MLXSW_REG_DEFINE(rxltm, MLXSW_REG_RXLTM_ID, MLXSW_REG_RXLTM_LEN);
+
+/* reg_rxltm_m0_val_v6
+ * Global M0 value For IPv6.
+ * Range 0..128
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxltm, m0_val_v6, 0x10, 16, 8);
+
+/* reg_rxltm_m0_val_v4
+ * Global M0 value For IPv4.
+ * Range 0..32
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxltm, m0_val_v4, 0x10, 0, 6);
+
+static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v6)
+{
+	MLXSW_REG_ZERO(rxltm, payload);
+	mlxsw_reg_rxltm_m0_val_v6_set(payload, m0_val_v6);
+	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
+}
+
 /* Note that XMDR and XRALXX register positions violate the rule of ordering
  * register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -11798,6 +11829,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
 	MLXSW_REG(rxlte),
+	MLXSW_REG(rxltm),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
-- 
2.29.2

