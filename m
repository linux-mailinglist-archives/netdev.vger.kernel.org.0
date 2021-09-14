Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C03F40A696
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239894AbhINGP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40325 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240146AbhINGPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5592D5C00AC;
        Tue, 14 Sep 2021 02:14:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 14 Sep 2021 02:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7V5JzF58nPG+EYpDwKJbl/cgbbw9+vj06Q0E9LB1AdA=; b=PxaJylCV
        usRJKfBaqkCJVonDzrX5g8uyK/DTiEK0WzGY1s6NY88957LPPssUfIzhNue1HZUA
        EgGv4ooXCWeSyfLyYVoHRMoLaUHBSSjxk81ds8ruyPEQmLI8h/7hbiin9lc7n4Hi
        t8U/Cc/JHhsXnEw0ex5aatSvWx2upQSmnrxpk68IbE2NYEpLR6GZWBM+Z3z5sOJQ
        U5TbcmOwgCZ3HboDZEwklMWXL0AKBUgEwHt7UzOAdC27GX5QdVFcfALK1QAblhZS
        2RfS0KQzBzXLx8GW33vQb1aGk7DdUSfljfWy0iIRyskDJMOxGK9o/Gasjke1Ur56
        BY6qj+ArYIz5wQ==
X-ME-Sender: <xms:yj1AYSaBvVYdlbbyXTpBOqVLeRJ3kDeGd5auZ08g1TuSssZ21jCS-w>
    <xme:yj1AYVY9tnv7ej0vZxovleI-u8GGbYmO5OnnhdtSMatytsDyL9-snE9qTPs7L-Ntq
    -IxdYF1iJ83_SE>
X-ME-Received: <xmr:yj1AYc-5W354H1voPw0FKPEIfXyRsAlf6Ue9obRGv2PVAe1PLDL1y7xn04-G6YeKMg4VWbHB_r3EQs1IS8bHC0QsXYHsic6kaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yj1AYUqDtUefL7U1tnl-QRBMUeis1lmSV_p8wRQOTdqGdtYKQiDRkA>
    <xmx:yj1AYdomuQy7nUjKPD4rgks6InIRX8nLoLsa7NmH7B9i0zjuyrnabA>
    <xmx:yj1AYSQDnCFola7gVGPMKLFUVHSrL61iACW6nx_wglvJGj_zBZ3N8g>
    <xmx:yj1AYUUp7PD4Gb9AUN8AR6DYFXft-hLPj_pmJyxGaPEYq_ps9CCa5w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: reg: Remove PMTM register
Date:   Tue, 14 Sep 2021 09:13:30 +0300
Message-Id: <20210914061330.226000-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

It is not used anymore, remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 64 -----------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 390e467050f3..8d87f3cc5711 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5970,69 +5970,6 @@ static inline void mlxsw_reg_pllp_unpack(char *payload, u8 *label_port,
 	*slot_index = mlxsw_reg_pllp_slot_index_get(payload);
 }
 
-/* PMTM - Port Module Type Mapping Register
- * ----------------------------------------
- * The PMTM allows query or configuration of module types.
- */
-#define MLXSW_REG_PMTM_ID 0x5067
-#define MLXSW_REG_PMTM_LEN 0x10
-
-MLXSW_REG_DEFINE(pmtm, MLXSW_REG_PMTM_ID, MLXSW_REG_PMTM_LEN);
-
-/* reg_pmtm_module
- * Module number.
- * Access: Index
- */
-MLXSW_ITEM32(reg, pmtm, module, 0x00, 16, 8);
-
-enum mlxsw_reg_pmtm_module_type {
-	/* Backplane with 4 lanes */
-	MLXSW_REG_PMTM_MODULE_TYPE_BP_4X,
-	/* QSFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_QSFP,
-	/* SFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_SFP,
-	/* Backplane with single lane */
-	MLXSW_REG_PMTM_MODULE_TYPE_BP_1X = 4,
-	/* Backplane with two lane */
-	MLXSW_REG_PMTM_MODULE_TYPE_BP_2X = 8,
-	/* Chip2Chip4x */
-	MLXSW_REG_PMTM_MODULE_TYPE_C2C4X = 10,
-	/* Chip2Chip2x */
-	MLXSW_REG_PMTM_MODULE_TYPE_C2C2X,
-	/* Chip2Chip1x */
-	MLXSW_REG_PMTM_MODULE_TYPE_C2C1X,
-	/* QSFP-DD */
-	MLXSW_REG_PMTM_MODULE_TYPE_QSFP_DD = 14,
-	/* OSFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_OSFP,
-	/* SFP-DD */
-	MLXSW_REG_PMTM_MODULE_TYPE_SFP_DD,
-	/* DSFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_DSFP,
-	/* Chip2Chip8x */
-	MLXSW_REG_PMTM_MODULE_TYPE_C2C8X,
-};
-
-/* reg_pmtm_module_type
- * Module type.
- * Access: RW
- */
-MLXSW_ITEM32(reg, pmtm, module_type, 0x04, 0, 4);
-
-static inline void mlxsw_reg_pmtm_pack(char *payload, u8 module)
-{
-	MLXSW_REG_ZERO(pmtm, payload);
-	mlxsw_reg_pmtm_module_set(payload, module);
-}
-
-static inline void
-mlxsw_reg_pmtm_unpack(char *payload,
-		      enum mlxsw_reg_pmtm_module_type *module_type)
-{
-	*module_type = mlxsw_reg_pmtm_module_type_get(payload);
-}
-
 /* HTGT - Host Trap Group Table
  * ----------------------------
  * Configures the properties for forwarding to CPU.
@@ -12314,7 +12251,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
 	MLXSW_REG(pllp),
-	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
 	MLXSW_REG(rgcr),
-- 
2.31.1

