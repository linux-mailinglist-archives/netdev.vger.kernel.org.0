Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1672D834
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfE2Irs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47501 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbfE2Irq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 51B2621FC3;
        Wed, 29 May 2019 04:47:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=BXOHbl9TfNqPZA7B2pO1yRbkMN5DiNfxSKjrJ5CXuE8=; b=8Xl0lsUT
        J+vwx1fsmMEAlL0y6CKgjf5/BIfb4BM7TvWjSlVfaAprKQltDi01m2wwnu6j8ohn
        D5NxIr2TopFQGHnggf7uByTqVmmJz8Vu2+nKTx64+Dr7P1wqIe6iw6ycVMbENYkF
        qW8hKvl0gpS3AR4T77G/tYRIh8zICYCfJ7Lux6MG8CW+2TgkExONZnOo6sAqpazX
        5LsszvaUreVYjuYLGwuEwWkX2lUd4mnacPGA8FplVkjUQ7sga6w4zeDPA/Fu60vS
        0dqZny4Wgu5hoT8NqECYA4dSNamWamnOWRwWLhNJW18Pj0mxbpdTleICQjExknw8
        PbfoHbLI/4RfdQ==
X-ME-Sender: <xms:MkfuXPY_W_wn-wqqgY7HhRD-_0fxJds-m9KxiW5eAo48m4-cF7bwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:MkfuXN_9sIbja31EDA23VGWZiK_ncavWKyQYsqUtRje8vDgxsBg63A>
    <xmx:MkfuXGATuiYURSPhOGslmODUNiLfUSnOccV0o3hnWLtcH2LEOr5gJw>
    <xmx:MkfuXFYPlXpFV2G5wrNon6zENL3Syx0dOk1WL2d9MD3LuQCfuBhtwQ>
    <xmx:MkfuXFnfpALgOSljJtJbppYIFQ4EUJLr6maS6qgQ_KdUq5MrHnrGLg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D73448005B;
        Wed, 29 May 2019 04:47:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/8] mlxsw: reg: Add Management General Peripheral Information Register
Date:   Wed, 29 May 2019 11:47:19 +0300
Message-Id: <20190529084722.22719-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Add MGPIR - Management General Peripheral Information Register, which
allows software to query the hardware and firmware general information
of peripheral entities as Gearboxes etc.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 52 +++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index a689bf991dbd..ec1ae66a0b36 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9044,6 +9044,57 @@ static inline void mlxsw_reg_mprs_pack(char *payload, u16 parsing_depth,
 	mlxsw_reg_mprs_vxlan_udp_dport_set(payload, vxlan_udp_dport);
 }
 
+/* MGPIR - Management General Peripheral Information Register
+ * ----------------------------------------------------------
+ * MGPIR register allows software to query the hardware and
+ * firmware general information of peripheral entities.
+ */
+#define MLXSW_REG_MGPIR_ID 0x9100
+#define MLXSW_REG_MGPIR_LEN 0xA0
+
+MLXSW_REG_DEFINE(mgpir, MLXSW_REG_MGPIR_ID, MLXSW_REG_MGPIR_LEN);
+
+enum mlxsw_reg_mgpir_device_type {
+	MLXSW_REG_MGPIR_DEVICE_TYPE_NONE,
+	MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE,
+};
+
+/* device_type
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, device_type, 0x00, 24, 4);
+
+/* devices_per_flash
+ * Number of devices of device_type per flash (can be shared by few devices).
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, devices_per_flash, 0x00, 16, 8);
+
+/* num_of_devices
+ * Number of devices of device_type.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, num_of_devices, 0x00, 0, 8);
+
+static inline void mlxsw_reg_mgpir_pack(char *payload)
+{
+	MLXSW_REG_ZERO(mgpir, payload);
+}
+
+static inline void
+mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
+		       enum mlxsw_reg_mgpir_device_type *device_type,
+		       u8 *devices_per_flash)
+{
+	if (num_of_devices)
+		*num_of_devices = mlxsw_reg_mgpir_num_of_devices_get(payload);
+	if (device_type)
+		*device_type = mlxsw_reg_mgpir_device_type_get(payload);
+	if (devices_per_flash)
+		*devices_per_flash =
+				mlxsw_reg_mgpir_devices_per_flash_get(payload);
+}
+
 /* TNGCR - Tunneling NVE General Configuration Register
  * ----------------------------------------------------
  * The TNGCR register is used for setting up the NVE Tunneling configuration.
@@ -10059,6 +10110,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mcda),
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
+	MLXSW_REG(mgpir),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
 	MLXSW_REG(tnqcr),
-- 
2.20.1

