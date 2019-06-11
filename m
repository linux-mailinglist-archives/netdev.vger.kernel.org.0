Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6BC3D13B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405325AbfFKPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51375 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405210AbfFKPpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B880722304;
        Tue, 11 Jun 2019 11:45:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9H41v8EGBNI/jJT/3nxPSvBDDOGRAc6oWyzIY4e6cCw=; b=epIA/vCv
        RFXJ4tdi9gyYEPTLgCqAn7WloGvAmZ/ZPpB0ACN5ltnPt1fAwIExVTjpvYsK0dz4
        PsrUGXk4P9FpKM2WTvf1sRj3DF+dPUUaT1PQL2f4qQTwjZHsemTXUgpkOctWyFfv
        QL9ZDPLIzHXg9wnHYuSntfWLzPTGFDgj8VEiq1VQEb/ZEkYF4KwmOutcp2nXTxkS
        qW63f44qVUJmHYdJnfrUX6YhAT24sHn5btUWYVvVOvwBACMAEWwQOP9UAVnpMPLQ
        1/SJer0NHMB0SEO+S09o9i70q/Fy7iMgS1uxVfj6yOGjQTUJ+ynJHZcknB5U9iVk
        97KtlJAzAdDF/A==
X-ME-Sender: <xms:rcz_XIx27sfZlLxAaiBvLHYj-kr6uN2Vd_8kp5Zr29QvwWyOaGc9sQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rcz_XNeUPU3_Z6sTqcAVJus2PkPAod5omLso4Ivld01qguiWYCtkdQ>
    <xmx:rcz_XKxz4MOi3X05FAVaklbWDtPmWTG0iuekZo8G5rw-t4Vw6vQ9JA>
    <xmx:rcz_XP5LWVV8wMV5Vzb-w2HK3Uun8saCjqa7lhOGV3qky0Vap0muPA>
    <xmx:rcz_XARW35SsCASLjpqBWSiTeq43xCbQHxcg6ivOpdxkYXjPxAsn2Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD705380073;
        Tue, 11 Jun 2019 11:45:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 5/9] mlxsw: reg: Add Management Pulse Per Second Register
Date:   Tue, 11 Jun 2019 18:45:08 +0300
Message-Id: <20190611154512.17650-6-idosch@idosch.org>
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

The MTPPS register provides the device PPS capabilities, configure the PPS
in and out modules and holds the PPS in time stamp.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 58 +++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 9ec154975cb2..d8eb9ef01646 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8691,6 +8691,63 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
 					   MLXSW_REG_MLCR_DURATION_MAX : 0);
 }
 
+/* MTPPS - Management Pulse Per Second Register
+ * --------------------------------------------
+ * This register provides the device PPS capabilities, configure the PPS in and
+ * out modules and holds the PPS in time stamp.
+ */
+#define MLXSW_REG_MTPPS_ID 0x9053
+#define MLXSW_REG_MTPPS_LEN 0x3C
+
+MLXSW_REG_DEFINE(mtpps, MLXSW_REG_MTPPS_ID, MLXSW_REG_MTPPS_LEN);
+
+/* reg_mtpps_enable
+ * Enables the PPS functionality the specific pin.
+ * A boolean variable.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpps, enable, 0x20, 31, 1);
+
+enum mlxsw_reg_mtpps_pin_mode {
+	MLXSW_REG_MTPPS_PIN_MODE_VIRTUAL_PIN = 0x2,
+};
+
+/* reg_mtpps_pin_mode
+ * Pin mode to be used. The mode must comply with the supported modes of the
+ * requested pin.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpps, pin_mode, 0x20, 8, 4);
+
+#define MLXSW_REG_MTPPS_PIN_SP_VIRTUAL_PIN	7
+
+/* reg_mtpps_pin
+ * Pin to be configured or queried out of the supported pins.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtpps, pin, 0x20, 0, 8);
+
+/* reg_mtpps_time_stamp
+ * When pin_mode = pps_in, the latched device time when it was triggered from
+ * the external GPIO pin.
+ * When pin_mode = pps_out or virtual_pin or pps_out_and_virtual_pin, the target
+ * time to generate next output signal.
+ * Time is in units of device clock.
+ * Access: RW
+ */
+MLXSW_ITEM64(reg, mtpps, time_stamp, 0x28, 0, 64);
+
+static inline void
+mlxsw_reg_mtpps_vpin_pack(char *payload, u64 time_stamp)
+{
+	MLXSW_REG_ZERO(mtpps, payload);
+	mlxsw_reg_mtpps_pin_set(payload, MLXSW_REG_MTPPS_PIN_SP_VIRTUAL_PIN);
+	mlxsw_reg_mtpps_pin_mode_set(payload,
+				     MLXSW_REG_MTPPS_PIN_MODE_VIRTUAL_PIN);
+	mlxsw_reg_mtpps_enable_set(payload, true);
+	mlxsw_reg_mtpps_time_stamp_set(payload, time_stamp);
+}
+
 /* MTUTC - Management UTC Register
  * -------------------------------
  * Configures the HW UTC counter.
@@ -10149,6 +10206,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
 	MLXSW_REG(mcqi),
-- 
2.20.1

