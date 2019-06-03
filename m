Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8C632F49
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfFCMN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50765 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbfFCMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 816C522220;
        Mon,  3 Jun 2019 08:13:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9H41v8EGBNI/jJT/3nxPSvBDDOGRAc6oWyzIY4e6cCw=; b=SW1TRh3Z
        TET/7kMd1lijgNdSwGe3nZFhTHUufZ2sIi4tFcJCn3lX+/mrV9js7Lm2kt8GYSgk
        UORfwvzucvmPpZKDqEDiuJEwjKvwhyQdXxYxea0WT7U6AbPHnKqUzm6vpxbWeFXO
        DQ+xxj2lcFTpKZrVyP0orNKH9Np7Q1sJeW9g9aw2U3xTisvLBOOkpGjItCbOmOcE
        pUy7y1PE51Us72qPL2LYNvBoFw0DXf8Wzjp5I8A68F+/z5Hmn681nwW3O1OiG9QR
        bSpSMA6CdWoscd7hQ2sb/Hg/T4N9y+gu6dwLmVaCXjpVRLLWoGwdo03t4izz5/wd
        0h2PHQp1SQ/EIw==
X-ME-Sender: <xms:Ag_1XFZw6-Z0LA9CbJYz9b2gKi3wPC2GxFCul5Jtq5z3rBTQXYPt-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:Ag_1XC6OAO5Bv085sOBekLd72YGXRVdKiOPWFv3laeQ_DGmMD3a8xw>
    <xmx:Ag_1XLJ-XitMrudTRmL-H9h5Gz_9Pzj2qRkL2ufDQyTlcrDUieIZEA>
    <xmx:Ag_1XNpyiMNxA7Xg21hLlkcME3VG_KMDouWhnDYcyndPxHRHzFwvEg>
    <xmx:Ag_1XEddHR2_Gisj35KJeoqcU0n40yzXVI6drbdpNrFSUF3CBIvyzw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5E1B38008B;
        Mon,  3 Jun 2019 08:13:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] mlxsw: reg: Add Management Pulse Per Second Register
Date:   Mon,  3 Jun 2019 15:12:40 +0300
Message-Id: <20190603121244.3398-6-idosch@idosch.org>
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

