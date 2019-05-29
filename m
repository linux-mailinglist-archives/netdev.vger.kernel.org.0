Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E762D82E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfE2Irv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45855 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfE2Irt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 157EE223AD;
        Wed, 29 May 2019 04:47:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8GKu44wO0Y8YVbHUm8R4rzDbMyMEFfs1h93s/Jx8ueQ=; b=gmcCmpqf
        0xldavTmuadU8C0yeUnNTfaovxLuK0ulP3g1F70/a3LKxptBBm4QCR8/ybwtFIXV
        WaMZdGBFPeoEs2OOe9BguRvKB+SDKAFe3a9OpDna7tdCe7L/UKgnEpUahQFOdVzW
        R33qc0sobf3EFx/H32XZxThLceaIlthnagnqCaWv1gEcUshWhx7Ba9Kg9HKCGUe3
        eqZb1QPE5sAmhJT6lXn8Q3ZfJgDJ9OwRzqAXUx+s892yBebA1PBis9s6sK7iF3To
        g86w/mWEqQq+3i9ceZIHYBF76Kc4iAbLkrC6YUCJ0bCeKVs0jDjydJmjj867wOgI
        dw+d86j9hV7fbg==
X-ME-Sender: <xms:NEfuXOpuJ4bn_RZH_tBQ23BfwmGomk01e1UTZKsoLq7S0UUdMLJ6GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:NEfuXA5rTVl2JLQzVO7C1NC2YlcniDzo2cGLvGe1MEV4XKRb6fhpOg>
    <xmx:NEfuXOMVuCq7K_OrDxUlDQKs8UkcJPKdYIg_97UUfwsKGs9peRDcwQ>
    <xmx:NEfuXCNNTqr3Q99ptMcxbZGtmLTue_AMEVE3jCUSwrFvnYWCCTmcWg>
    <xmx:NUfuXIKojNaRSLR5s8ykPDZ6ClgxSLGayYks1UOIwAfuQP0X024tjw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 98B648005B;
        Wed, 29 May 2019 04:47:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/8] mlxsw: core: Extend the index size for temperature sensors readout
Date:   Wed, 29 May 2019 11:47:21 +0300
Message-Id: <20190529084722.22719-8-idosch@idosch.org>
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

Extend sensor index size for Management Temperature Bulk Register
(MTBR) and Management Temperature Register (MTMP) upto 12 bits in
order to align registers description with new version of PRM document.
Add define for base sensor index for SFP modules temperature reading
for MTMP register.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ec1ae66a0b36..7348c5a5ad6a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8039,6 +8039,7 @@ MLXSW_ITEM32(reg, mtcap, sensor_count, 0x00, 0, 7);
 
 MLXSW_REG_DEFINE(mtmp, MLXSW_REG_MTMP_ID, MLXSW_REG_MTMP_LEN);
 
+#define MLXSW_REG_MTMP_MODULE_INDEX_MIN 64
 #define MLXSW_REG_MTMP_GBOX_INDEX_MIN 256
 /* reg_mtmp_sensor_index
  * Sensors index to access.
@@ -8046,7 +8047,7 @@ MLXSW_REG_DEFINE(mtmp, MLXSW_REG_MTMP_ID, MLXSW_REG_MTMP_LEN);
  * (module 0 is mapped to sensor_index 64).
  * Access: Index
  */
-MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 11);
+MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 12);
 
 /* Convert to milli degrees Celsius */
 #define MLXSW_REG_MTMP_TEMP_TO_MC(val) (val * 125)
@@ -8157,7 +8158,7 @@ MLXSW_REG_DEFINE(mtbr, MLXSW_REG_MTBR_ID, MLXSW_REG_MTBR_LEN);
  * 64-127 are mapped to the SFP+/QSFP modules sequentially).
  * Access: Index
  */
-MLXSW_ITEM32(reg, mtbr, base_sensor_index, 0x00, 0, 7);
+MLXSW_ITEM32(reg, mtbr, base_sensor_index, 0x00, 0, 12);
 
 /* reg_mtbr_num_rec
  * Request: Number of records to read
@@ -8184,7 +8185,7 @@ MLXSW_ITEM32_INDEXED(reg, mtbr, rec_max_temp, MLXSW_REG_MTBR_BASE_LEN, 16,
 MLXSW_ITEM32_INDEXED(reg, mtbr, rec_temp, MLXSW_REG_MTBR_BASE_LEN, 0, 16,
 		     MLXSW_REG_MTBR_REC_LEN, 0x00, false);
 
-static inline void mlxsw_reg_mtbr_pack(char *payload, u8 base_sensor_index,
+static inline void mlxsw_reg_mtbr_pack(char *payload, u16 base_sensor_index,
 				       u8 num_rec)
 {
 	MLXSW_REG_ZERO(mtbr, payload);
-- 
2.20.1

