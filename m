Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776762D82D
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfE2Irt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60615 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbfE2Irp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E5D8B222B2;
        Wed, 29 May 2019 04:47:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8AVODrUQaY1UnksUyzZR57Rjt7HMvi4slv4x8Nho0Ho=; b=PuL6eljn
        +PNQ2XkAk2Tw6pVyaRNNQ529CRE+Y4TF2H/7gMknG/O3YWD6Stl5k0B0nbanrHxJ
        XHdxomDzUMTSU/O1M6dQQQI0GhLUMTAfFwdfrGGAB3PMyF8IDA/DpAP84+7UjqoF
        GcgwJIqZD9qYuhM57nPb18MsIAMczSrQ/Dl4kFJ9pfvcYSNVdD6ZZU7n1w5fcaB0
        jwydYX0iVVAB/STpLsHtoOFQ1RhPX6025pnzoDsWchfMF332jcrU+NstGUpC7tsp
        dxLvJUxtuSwN8Eaub0HYm6IJ+pf536Jm6NX4QcaTH3igDjMLxRqDt/Ympvi+8D7p
        ESGmnqwe8UCERw==
X-ME-Sender: <xms:MEfuXCMEOPEmB3nQbcjaYnH4Qk9duolWW9Flo5yX66dAE2zydajzwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:MEfuXDgGQ9JTDmtIDoc0XqpQ0ZtfFlKQF3lnpAE3AnKdEwKdYqqGdA>
    <xmx:MEfuXKP0pfmbp3cbGr7NmEbvhyGgN6pZUDUKWT03q0UiK1DpuCYpgQ>
    <xmx:MEfuXHu5mc7E9jkc9gimAJZVjn3jMOt9TRpuuJ5PPvP1RuXZDIcDBg>
    <xmx:MEfuXFu4mjalzykvSSHpfoTmkI8b1uzjAjDI6ohVyHj6r3PTjNyeCw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 800A280064;
        Wed, 29 May 2019 04:47:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/8] mlxsw: reg: Extend sensor index field size of Management Temperature Register
Date:   Wed, 29 May 2019 11:47:18 +0300
Message-Id: <20190529084722.22719-5-idosch@idosch.org>
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

Extend the size of sensor_index field of MTMP (Management Temperature
Register), from 8 to 12 bits due to hardware change.
Add define for sensor index for Gear Box (inter-connects) temperature
reading.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e8002bfc1e8f..a689bf991dbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8039,13 +8039,14 @@ MLXSW_ITEM32(reg, mtcap, sensor_count, 0x00, 0, 7);
 
 MLXSW_REG_DEFINE(mtmp, MLXSW_REG_MTMP_ID, MLXSW_REG_MTMP_LEN);
 
+#define MLXSW_REG_MTMP_GBOX_INDEX_MIN 256
 /* reg_mtmp_sensor_index
  * Sensors index to access.
  * 64-127 of sensor_index are mapped to the SFP+/QSFP modules sequentially
  * (module 0 is mapped to sensor_index 64).
  * Access: Index
  */
-MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 7);
+MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 11);
 
 /* Convert to milli degrees Celsius */
 #define MLXSW_REG_MTMP_TEMP_TO_MC(val) (val * 125)
@@ -8107,7 +8108,7 @@ MLXSW_ITEM32(reg, mtmp, temperature_threshold_lo, 0x10, 0, 16);
  */
 MLXSW_ITEM_BUF(reg, mtmp, sensor_name, 0x18, MLXSW_REG_MTMP_SENSOR_NAME_SIZE);
 
-static inline void mlxsw_reg_mtmp_pack(char *payload, u8 sensor_index,
+static inline void mlxsw_reg_mtmp_pack(char *payload, u16 sensor_index,
 				       bool max_temp_enable,
 				       bool max_temp_reset)
 {
-- 
2.20.1

