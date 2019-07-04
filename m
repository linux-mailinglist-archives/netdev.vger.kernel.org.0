Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E085F340
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfGDHJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:04 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32915 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727326AbfGDHJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 87BC721F8A;
        Thu,  4 Jul 2019 03:09:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LmJFtUixKlQXxNg4mD7J1Z5u0HuA7hkaa7hYgBtO3fI=; b=vyRrlIk+
        PIxo4MKSCkt76WGdGZkVsohgQYWTb+DW1ylDEVZlAchZJfRnK7CUGuqDk3t+92qn
        z64uuROjfnUCefQ9A9+xpwRiPQ8v9p7BhYQrXO/eAzZyWIO50z8TKQNrOFnhvzBV
        s/CpgRNYbKpQl83GTd/y9T41mWlQbQ8uu1qnCt//Iy0kAuBjCT8gU2oip7UvlVQL
        tqrwcdwkmEFTlaAP94Kt9GMQn0S/uThDHiwlKEJyWbyEVobOpYL1t///9n59NWvC
        EgLMV8JdYItqqhqxpI/sNW3D420xldeGhxhk0abKfTOfaDfFtHJmkRxp0pZ3BWG8
        QjTmevYxjdXmvA==
X-ME-Sender: <xms:DqYdXW6i8wJn0oyM2rRLn-I1xslhC_Qu3-JVJJzwhkkoAehDWkY7Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:DqYdXW1a9lsHuQwVwtNeQMH_ISsCrfHxXB_r18l67DXEJt9RbTiIKg>
    <xmx:DqYdXajAjRHkSy4c9A5a_IipRPGPPAdaSVrHYwx96eWtcLqiPS0KwQ>
    <xmx:DqYdXaQvCET5vFajSwJefllYbgsfB6c5LjWD4GkUVeEgfq2cynBeyw>
    <xmx:DqYdXQwAGy2tkaUUk5twvWUNVpFwcU1-QXVAUzXnPywRla8yzxD-kA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3304380086;
        Thu,  4 Jul 2019 03:09:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/8] mlxsw: reg: Add QoS PTP Shaper Configuration Register
Date:   Thu,  4 Jul 2019 10:07:35 +0300
Message-Id: <20190704070740.302-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

The QPSC allows advanced configuration of the PTP shapers.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 107 ++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d2e2a75f7983..ead36702549a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3836,6 +3836,112 @@ mlxsw_reg_qtctm_pack(char *payload, u8 local_port, bool mc)
 	mlxsw_reg_qtctm_mc_set(payload, mc);
 }
 
+/* QPSC - QoS PTP Shaper Configuration Register
+ * --------------------------------------------
+ * The QPSC allows advanced configuration of the shapers when QEEC.ptps=1.
+ * Supported only on Spectrum-1.
+ */
+#define MLXSW_REG_QPSC_ID 0x401B
+#define MLXSW_REG_QPSC_LEN 0x28
+
+MLXSW_REG_DEFINE(qpsc, MLXSW_REG_QPSC_ID, MLXSW_REG_QPSC_LEN);
+
+enum mlxsw_reg_qpsc_port_speed {
+	MLXSW_REG_QPSC_PORT_SPEED_100M,
+	MLXSW_REG_QPSC_PORT_SPEED_1G,
+	MLXSW_REG_QPSC_PORT_SPEED_10G,
+	MLXSW_REG_QPSC_PORT_SPEED_25G,
+};
+
+/* reg_qpsc_port_speed
+ * Port speed.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, qpsc, port_speed, 0x00, 0, 4);
+
+/* reg_qpsc_shaper_time_exp
+ * The base-time-interval for updating the shapers tokens (for all hierarchies).
+ * shaper_update_rate = 2 ^ shaper_time_exp * (1 + shaper_time_mantissa) * 32nSec
+ * shaper_rate = 64bit * shaper_inc / shaper_update_rate
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, shaper_time_exp, 0x04, 16, 4);
+
+/* reg_qpsc_shaper_time_mantissa
+ * The base-time-interval for updating the shapers tokens (for all hierarchies).
+ * shaper_update_rate = 2 ^ shaper_time_exp * (1 + shaper_time_mantissa) * 32nSec
+ * shaper_rate = 64bit * shaper_inc / shaper_update_rate
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, shaper_time_mantissa, 0x04, 0, 5);
+
+/* reg_qpsc_shaper_inc
+ * Number of tokens added to shaper on each update.
+ * Units of 8B.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, shaper_inc, 0x08, 0, 5);
+
+/* reg_qpsc_shaper_bs
+ * Max shaper Burst size.
+ * Burst size is 2 ^ max_shaper_bs * 512 [bits]
+ * Range is: 5..25 (from 2KB..2GB)
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, shaper_bs, 0x0C, 0, 6);
+
+/* reg_qpsc_ptsc_we
+ * Write enable to port_to_shaper_credits.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, qpsc, ptsc_we, 0x10, 31, 1);
+
+/* reg_qpsc_port_to_shaper_credits
+ * For split ports: range 1..57
+ * For non-split ports: range 1..112
+ * Written only when ptsc_we is set.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, port_to_shaper_credits, 0x10, 0, 8);
+
+/* reg_qpsc_ing_timestamp_inc
+ * Ingress timestamp increment.
+ * 2's complement.
+ * The timestamp of MTPPTR at ingress will be incremented by this value. Global
+ * value for all ports.
+ * Same units as used by MTPPTR.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, ing_timestamp_inc, 0x20, 0, 32);
+
+/* reg_qpsc_egr_timestamp_inc
+ * Egress timestamp increment.
+ * 2's complement.
+ * The timestamp of MTPPTR at egress will be incremented by this value. Global
+ * value for all ports.
+ * Same units as used by MTPPTR.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpsc, egr_timestamp_inc, 0x24, 0, 32);
+
+static inline void
+mlxsw_reg_qpsc_pack(char *payload, enum mlxsw_reg_qpsc_port_speed port_speed,
+		    u8 shaper_time_exp, u8 shaper_time_mantissa, u8 shaper_inc,
+		    u8 shaper_bs, u8 port_to_shaper_credits,
+		    int ing_timestamp_inc, int egr_timestamp_inc)
+{
+	MLXSW_REG_ZERO(qpsc, payload);
+	mlxsw_reg_qpsc_port_speed_set(payload, port_speed);
+	mlxsw_reg_qpsc_shaper_time_exp_set(payload, shaper_time_exp);
+	mlxsw_reg_qpsc_shaper_time_mantissa_set(payload, shaper_time_mantissa);
+	mlxsw_reg_qpsc_shaper_inc_set(payload, shaper_inc);
+	mlxsw_reg_qpsc_shaper_bs_set(payload, shaper_bs);
+	mlxsw_reg_qpsc_ptsc_we_set(payload, true);
+	mlxsw_reg_qpsc_port_to_shaper_credits_set(payload, port_to_shaper_credits);
+	mlxsw_reg_qpsc_ing_timestamp_inc_set(payload, ing_timestamp_inc);
+	mlxsw_reg_qpsc_egr_timestamp_inc_set(payload, egr_timestamp_inc);
+}
+
 /* PMLP - Ports Module to Local Port Register
  * ------------------------------------------
  * Configures the assignment of modules to local ports.
@@ -10396,6 +10502,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(qpdsm),
 	MLXSW_REG(qpdpm),
 	MLXSW_REG(qtctm),
+	MLXSW_REG(qpsc),
 	MLXSW_REG(pmlp),
 	MLXSW_REG(pmtu),
 	MLXSW_REG(ptys),
-- 
2.20.1

