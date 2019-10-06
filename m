Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1247CCCEFE
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfJFGfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55289 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfJFGfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 54E5A20D7C;
        Sun,  6 Oct 2019 02:35:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=tBaQ0si7RKfF0Z9cXEvGw2uc2VSDSQ5ueyiLBFtr5Bs=; b=iQR/sB07
        mUVzxmk2+/1OUwdU4wzQB3TRb2AKEj7ul2oaKOFctCruoxP8jrti9ES1QqLdOaS9
        ixtzz+DTDte+C16Q3htCIGgIR1VSc40wdsyEuTCe0W/53/OpEB+2Sf+gEsMJZwdh
        DobDKPpMKqUNnFQvNx/smmsW9rY9GYeuV8amSkefa09FknQM4Vsy5bM1eSb0n/KZ
        MMqRU1x4TScROECVQnTfnyPpxxSwr5XAfkl7cjt4LEQHkBen+3dQHoD8yEXyOK5v
        C2sfAQNZKFjDHHsTofcna8Pq+1J4cc1kgkS0/YQMnRBQzDUh7FH9p77ZlQ3LziJg
        pviq0N0ny+RzrA==
X-ME-Sender: <xms:J4uZXQZdO_xlowdI2JAXw42QMH-Gw7v1e-MSkUMqmCn4TaEvyZnOJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:J4uZXc5oM_q2V9sK5sxgkRDQblv7da_PDrsUTVzj-g_b2oZpvitliw>
    <xmx:J4uZXfgSBD7dZS5IUCgv1cPX1Jp08jf5gqrBoBlF9adZS6w1dYkyEQ>
    <xmx:J4uZXaKNWEFSYviFkELQ5CLyM9uyAInewICWX3fXHuprv1vpluT4vg>
    <xmx:J4uZXefW5GZDR3ynK47HQoMJlu6eFG0jIS2nMoqL9m-jiJ77gYIsfA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9176D60057;
        Sun,  6 Oct 2019 02:35:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] mlxsw: reg: Extend MGPIR register with new field exposing the number of QSFP modules
Date:   Sun,  6 Oct 2019 09:34:48 +0300
Message-Id: <20191006063452.7666-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Extend MGPIR - Management General Peripheral Information Register
with new field "num_of_modules" exposing the number of modules
supported by specific system.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 10 +++++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 5b00726c4346..69c192839bf9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -590,7 +590,7 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, NULL, NULL);
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, NULL, NULL, NULL);
 	if (!gbox_num)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 35a1dc89c28a..b2c76a95f671 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -913,7 +913,8 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &thermal->tz_gearbox_num, NULL, NULL);
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &thermal->tz_gearbox_num, NULL, NULL,
+			       NULL);
 	if (!thermal->tz_gearbox_num)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5494cf93f34c..7b538e698a3d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9531,6 +9531,12 @@ MLXSW_ITEM32(reg, mgpir, devices_per_flash, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mgpir, num_of_devices, 0x00, 0, 8);
 
+/* num_of_modules
+ * Number of modules.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, num_of_modules, 0x04, 0, 8);
+
 static inline void mlxsw_reg_mgpir_pack(char *payload)
 {
 	MLXSW_REG_ZERO(mgpir, payload);
@@ -9539,7 +9545,7 @@ static inline void mlxsw_reg_mgpir_pack(char *payload)
 static inline void
 mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 		       enum mlxsw_reg_mgpir_device_type *device_type,
-		       u8 *devices_per_flash)
+		       u8 *devices_per_flash, u8 *num_of_modules)
 {
 	if (num_of_devices)
 		*num_of_devices = mlxsw_reg_mgpir_num_of_devices_get(payload);
@@ -9548,6 +9554,8 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 	if (devices_per_flash)
 		*devices_per_flash =
 				mlxsw_reg_mgpir_devices_per_flash_get(payload);
+	if (num_of_modules)
+		*num_of_modules = mlxsw_reg_mgpir_num_of_modules_get(payload);
 }
 
 /* TNGCR - Tunneling NVE General Configuration Register
-- 
2.21.0

