Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3935F33F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfGDHJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56363 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbfGDHJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A2CC21F8A;
        Thu,  4 Jul 2019 03:08:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=o6zFjEJt0f0TD5rZbKQQUz5oiTIr2DjELjvu+6P3y9o=; b=nd5hum1G
        m0ifm/gb0uZ3dHROYFvg9gL/6RRiVe9Xv4dw3VF6PPg8KEiatV3Kvg5l90BQpICI
        f0WJO0i5E2iHqNSHhcyxRFwzvzOEtwpBax0EvLDN172QmJN0dcIwfdwG8GE4zKV2
        EYtrV7Rr6d7UvUNrSG+K3kzMOD5tdc9Lu8sGQGtZkh5R7cAF4wkctH1e5oCO6IhY
        MdXHr8pV7WFIMeShnTmRAz+7KUDHYDTVHV9H3TlafJyac0Z37WxuKyUm4SSZrEQR
        eWgigTQChqjytmr60F0kuuYJNBUshtknKwyLc/MmgrDNFcgxBPs8qvFSEcUwHY8T
        sGzGISSYDb4+RA==
X-ME-Sender: <xms:C6YdXeVj-WSH8AtDghfs59AiEfPHcTAHMXcqVBOjFxmLht-pt5Nomw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:C6YdXb733FhvjAS10GD4majLRXJwJnijPrjI0Fki4MG1glGKxnVLFA>
    <xmx:C6YdXXA0AR8qBkOmk6kZ9qSq5VCbkTkMgYq30BeCH4p3mY5C_z11Hw>
    <xmx:C6YdXYCbm2pzAnhEN7WLEOjYOfrYPyJl3Imvs_6aPi-GuB53zEqT1Q>
    <xmx:C6YdXSI7flfqqwskl6yymjuH8E497sf8M35uxFqPp-oIY7CuknY-yw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6DE6380087;
        Thu,  4 Jul 2019 03:08:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/8] mlxsw: reg: Add ptps field in QoS ETS Element Configuration Register
Date:   Thu,  4 Jul 2019 10:07:33 +0300
Message-Id: <20190704070740.302-2-idosch@idosch.org>
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

The PTP Shaper field is used for enabling and disabling of port-rate based
shaper which is slightly lower than port rate.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 76ff5b217c04..d2e2a75f7983 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3515,6 +3515,18 @@ MLXSW_ITEM32(reg, qeec, next_element_index, 0x08, 0, 8);
  */
 MLXSW_ITEM32(reg, qeec, mise, 0x0C, 31, 1);
 
+/* reg_qeec_ptps
+ * PTP shaper
+ * 0: regular shaper mode
+ * 1: PTP oriented shaper
+ * Allowed only for hierarchy 0
+ * Not supported for CPU port
+ * Note that ptps mode may affect the shaper rates of all hierarchies
+ * Supported only on Spectrum-1
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, ptps, 0x0C, 29, 1);
+
 enum {
 	MLXSW_REG_QEEC_BYTES_MODE,
 	MLXSW_REG_QEEC_PACKETS_MODE,
@@ -3601,6 +3613,16 @@ static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
 	mlxsw_reg_qeec_next_element_index_set(payload, next_index);
 }
 
+static inline void mlxsw_reg_qeec_ptps_pack(char *payload, u8 local_port,
+					    bool ptps)
+{
+	MLXSW_REG_ZERO(qeec, payload);
+	mlxsw_reg_qeec_local_port_set(payload, local_port);
+	mlxsw_reg_qeec_element_hierarchy_set(payload,
+					     MLXSW_REG_QEEC_HIERARCY_PORT);
+	mlxsw_reg_qeec_ptps_set(payload, ptps);
+}
+
 /* QRWE - QoS ReWrite Enable
  * -------------------------
  * This register configures the rewrite enable per receive port.
-- 
2.20.1

