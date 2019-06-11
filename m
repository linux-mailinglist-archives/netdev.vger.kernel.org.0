Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F933D137
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405155AbfFKPpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42663 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404136AbfFKPps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0548F2211E;
        Tue, 11 Jun 2019 11:45:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ghysz6zs7YpaMZHQWViOxCNqoDktk7z4D+tzWWbNOKw=; b=KVf26JP/
        2U244indCj8QBlSrvcGJLqRzpml8KWxBaHcIlIKCQR5aGJA6JIq7GZaBEw0UAeh9
        odG+U7bG++y/BLpOWPKE0J7bNkRnfK3GxhZ+ImglRl/WiJra0lvgVv4nGZYnEn89
        8Mq5CxcmtquW2FXCjx9ca792D99U3rjL/81i/qjbDJ1zF0E04sC+KIRa2VWeCNaI
        hPAfzuIR9CwgvFYm0899MOpucqVYdQqo/0IgyC/fZ0A0d4cu6FaIORjLC+HJIbqJ
        BRjRKnnMJ7/qDN1peEMWzISQm/AvrOwW7ibHssdM+jjEC0QcwxWxuY4KLi8te3TJ
        Vvwba4tRAASAZg==
X-ME-Sender: <xms:q8z_XNxuEKwxnDIdNSHWKDJkBauXzj3R1YbJOTdphM-0QLx8bPW_tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:q8z_XN9CYDAvf___dJ7Rd3EfHg74aiMZq9C9d1NzFsTeBLzrGFel4g>
    <xmx:q8z_XL2kdX_tbGll104Dv2pV2TxqWrrKG-6XJyBdpCJBtjqgXgdLNA>
    <xmx:q8z_XAB8p80LhSD_ER3drJYv2PjVoa84zSzIXssQFjK1JO1jatkQzQ>
    <xmx:q8z_XL-wIN_7g3oly2u13bgdYX7jfitvCVhf-DWx4MMwdLpxl31vGA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22681380087;
        Tue, 11 Jun 2019 11:45:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 4/9] mlxsw: reg: Add Management UTC Register
Date:   Tue, 11 Jun 2019 18:45:07 +0300
Message-Id: <20190611154512.17650-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
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

