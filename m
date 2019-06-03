Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53B332F46
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfFCMNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35571 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfFCMNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7467D2214E;
        Mon,  3 Jun 2019 08:13:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=45kg7bHHUbzj0y2C8p4KK8bgKD+B5xhcHQcmQN6ItRc=; b=l182MiUZ
        DRs4lsrCClQ9tiCw/Lk10sZusGCz7098+UprOFVA/qT9Cy/uXF4i1xyhg+8g3Xcj
        2DVUyyU0MFZE8YO0BN2YiQyQrM5l3QtJ3i90wlR8ez3GyO5AJAx7ZXDVJ8QBAd42
        WjK38f3jtxK4iD4sfhNPWj6PE7uPvqTAqgnyvwawV+U53DzxAe+4u0Q5bq0WEII4
        GULaxW0SMKfTCmV9xvDbczh5Aq3YLN0TlIYwu6GAUIJ7euu12A+kewldma+jHnm8
        D5QdGh1FWWDijXW4NZTBvZqg4LyBzyG3o9PbgBGJUL7DGmzeGtMegKkSOBrf0r1g
        rcESUu5+xLRJ/w==
X-ME-Sender: <xms:_Q71XILGAn4od5HKFmOElfY0F8wfUqGOyYwwem4WmFl_xMPoZ8AwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:_Q71XFEP7HQ9SJIsvhzWFc07jBF419UKtBGfgVGoFTUHJtgZF4E1rA>
    <xmx:_Q71XEVp2q-fAew_DeYYz_OupcWQhAYA34qk01lZsG-qj8eCzkWfcQ>
    <xmx:_Q71XNxebSSgWONp4y24CdRImjrPqibfwa5vycq0Mhlvf5KMBV5SPA>
    <xmx:_Q71XCR5J9RMd5U9yu0xvR0WKISMOZI3bpOXBJL4QTrfVTngzq_SYA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3993380084;
        Mon,  3 Jun 2019 08:13:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] mlxsw: core: Add a new interface for reading the hardware free running clock
Date:   Mon,  3 Jun 2019 15:12:37 +0300
Message-Id: <20190603121244.3398-3-idosch@idosch.org>
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

Add two new bus operations for reading the hardware free running clock.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 182762898361..b49a6520386c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2011,6 +2011,18 @@ int mlxsw_core_resources_query(struct mlxsw_core *mlxsw_core, char *mbox,
 }
 EXPORT_SYMBOL(mlxsw_core_resources_query);
 
+u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_frc_h(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_frc_h);
+
+u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_frc_l(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_frc_l);
+
 static int __init mlxsw_core_module_init(void)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e3832cb5bdda..02d1e580e44f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -306,6 +306,9 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_fw_flash_start(struct mlxsw_core *mlxsw_core);
 void mlxsw_core_fw_flash_end(struct mlxsw_core *mlxsw_core);
 
+u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
+u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
+
 bool mlxsw_core_res_valid(struct mlxsw_core *mlxsw_core,
 			  enum mlxsw_res_id res_id);
 
@@ -336,6 +339,8 @@ struct mlxsw_bus {
 			char *in_mbox, size_t in_mbox_size,
 			char *out_mbox, size_t out_mbox_size,
 			u8 *p_status);
+	u32 (*read_frc_h)(void *bus_priv);
+	u32 (*read_frc_l)(void *bus_priv);
 	u8 features;
 };
 
@@ -353,7 +358,8 @@ struct mlxsw_bus_info {
 	struct mlxsw_fw_rev fw_rev;
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
-	u8 low_frequency;
+	u8 low_frequency:1,
+	   read_frc_capable:1;
 };
 
 struct mlxsw_hwmon;
-- 
2.20.1

