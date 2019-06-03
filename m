Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2632F48
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfFCMNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53795 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfFCMNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F1ED32227B;
        Mon,  3 Jun 2019 08:13:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Ghysz6zs7YpaMZHQWViOxCNqoDktk7z4D+tzWWbNOKw=; b=g8sgxsSm
        1/PAUJXWmhFHSZdTZ38cp3GbrszCdplCqUb681yivU7iJFoLWq3mjH6Qtp437k7k
        G1vkdNuBT+6Kd8kPSNfNwULsJY6sybLIvj5X1YADXbi9P8jnvXv3X5MAlkN5NdDk
        Z9Q/8FV/jUzz3Bj53U9RzhOJq5ZeUql2QdutEFp4DM0p7NmDzUbqpCrfOWEFMUNr
        CddSlDsjiW2s1apkyuePuNGHV83zcwtgZO/HKU0mgIuRorn0dzZPwSmYHIwV9It6
        G2NXTuWwfAaJyQhPajRRLVMFEF3CeRiWieNLZkt8Gl2QYinFw1IBB11RpJG+A4v8
        1TUvx/qBw/pWCw==
X-ME-Sender: <xms:AA_1XIY7pPLRKJCVtYLbkef98ZrjBS3pmpPQ4e_YsLqKbj9Ez26GMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:AA_1XHqxFJJ0xXT05tOX2gr0SMwXsbs--PPw776V2TkOKVM8bC8uuQ>
    <xmx:AA_1XN8ZZvSjYVhKnHF4gvVw38A7046Yfa0ucHK-xaJ9X0ZDJVnTyQ>
    <xmx:AA_1XG9nShWaek_R1sQ5AQ9fmJUzX1ZZHcSKB8IdfxV1D4ByuVxk8A>
    <xmx:AA_1XGhME_TRSie-tVYDfiUV3inUcOBYXGyncspAqa6yLyIajxK7xQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3840438008C;
        Mon,  3 Jun 2019 08:13:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Date:   Mon,  3 Jun 2019 15:12:39 +0300
Message-Id: <20190603121244.3398-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603121244.3398-1-idosch@idosch.org>
References: <20190603121244.3398-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

The MTUTC register configures the HW UTC counter.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 45 +++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7348c5a5ad6a..9ec154975cb2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8691,6 +8691,50 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
 					   MLXSW_REG_MLCR_DURATION_MAX : 0);
 }
 
+/* MTUTC - Management UTC Register
+ * -------------------------------
+ * Configures the HW UTC counter.
+ */
+#define MLXSW_REG_MTUTC_ID 0x9055
+#define MLXSW_REG_MTUTC_LEN 0x1C
+
+MLXSW_REG_DEFINE(mtutc, MLXSW_REG_MTUTC_ID, MLXSW_REG_MTUTC_LEN);
+
+enum mlxsw_reg_mtutc_operation {
+	MLXSW_REG_MTUTC_OPERATION_SET_TIME_AT_NEXT_SEC = 0,
+	MLXSW_REG_MTUTC_OPERATION_ADJUST_FREQ = 3,
+};
+
+/* reg_mtutc_operation
+ * Operation.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mtutc, operation, 0x00, 0, 4);
+
+/* reg_mtutc_freq_adjustment
+ * Frequency adjustment: Every PPS the HW frequency will be
+ * adjusted by this value. Units of HW clock, where HW counts
+ * 10^9 HW clocks for 1 HW second.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtutc, freq_adjustment, 0x04, 0, 32);
+
+/* reg_mtutc_utc_sec
+ * UTC seconds.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mtutc, utc_sec, 0x10, 0, 32);
+
+static inline void
+mlxsw_reg_mtutc_pack(char *payload, enum mlxsw_reg_mtutc_operation oper,
+		     u32 freq_adj, u32 utc_sec)
+{
+	MLXSW_REG_ZERO(mtutc, payload);
+	mlxsw_reg_mtutc_operation_set(payload, oper);
+	mlxsw_reg_mtutc_freq_adjustment_set(payload, freq_adj);
+	mlxsw_reg_mtutc_utc_sec_set(payload, utc_sec);
+}
+
 /* MCQI - Management Component Query Information
  * ---------------------------------------------
  * This register allows querying information about firmware components.
@@ -10105,6 +10149,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
 	MLXSW_REG(mcqi),
 	MLXSW_REG(mcc),
-- 
2.20.1

