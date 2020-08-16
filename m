Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30D2245927
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgHPTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:07:58 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:25279 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgHPTHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 15:07:49 -0400
X-IronPort-AV: E=Sophos;i="5.76,321,1592838000"; 
   d="scan'208";a="54478021"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 17 Aug 2020 04:07:48 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 107FF40062C7;
        Mon, 17 Aug 2020 04:07:44 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/3] pinctrl: sh-pfc: r8a7790: Add CAN pins, groups and functions
Date:   Sun, 16 Aug 2020 20:07:30 +0100
Message-Id: <20200816190732.6905-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pins, groups and functions for the CAN0 and CAN1 interface.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c | 86 +++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
index 39ba1e7cc1c3..0863c412b3e1 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
@@ -1871,6 +1871,68 @@ static const unsigned int avb_gmii_mux[] = {
 	AVB_TX_EN_MARK, AVB_TX_ER_MARK, AVB_TX_CLK_MARK,
 	AVB_COL_MARK,
 };
+/* - CAN0 ----------------------------------------------------------------- */
+static const unsigned int can0_data_pins[] = {
+	/* CAN0 RX */
+	RCAR_GP_PIN(1, 17),
+	/* CAN0 TX */
+	RCAR_GP_PIN(1, 19),
+};
+static const unsigned int can0_data_mux[] = {
+	CAN0_RX_MARK,
+	CAN0_TX_MARK,
+};
+static const unsigned int can0_data_b_pins[] = {
+	/* CAN0 RXB */
+	RCAR_GP_PIN(4, 5),
+	/* CAN0 TXB */
+	RCAR_GP_PIN(4, 4),
+};
+static const unsigned int can0_data_b_mux[] = {
+	CAN0_RX_B_MARK,
+	CAN0_TX_B_MARK,
+};
+static const unsigned int can0_data_c_pins[] = {
+	/* CAN0 RXC */
+	RCAR_GP_PIN(4, 26),
+	/* CAN0 TXC */
+	RCAR_GP_PIN(4, 23),
+};
+static const unsigned int can0_data_c_mux[] = {
+	CAN0_RX_C_MARK,
+	CAN0_TX_C_MARK,
+};
+static const unsigned int can0_data_d_pins[] = {
+	/* CAN0 RXD */
+	RCAR_GP_PIN(4, 26),
+	/* CAN0 TXD */
+	RCAR_GP_PIN(4, 18),
+};
+static const unsigned int can0_data_d_mux[] = {
+	CAN0_RX_D_MARK,
+	CAN0_TX_D_MARK,
+};
+/* - CAN1 ----------------------------------------------------------------- */
+static const unsigned int can1_data_pins[] = {
+	/* CAN1 RX */
+	RCAR_GP_PIN(1, 22),
+	/* CAN1 TX */
+	RCAR_GP_PIN(1, 18),
+};
+static const unsigned int can1_data_mux[] = {
+	CAN1_RX_MARK,
+	CAN1_TX_MARK,
+};
+static const unsigned int can1_data_b_pins[] = {
+	/* CAN1 RXB */
+	RCAR_GP_PIN(4, 7),
+	/* CAN1 TXB */
+	RCAR_GP_PIN(4, 6),
+};
+static const unsigned int can1_data_b_mux[] = {
+	CAN1_RX_B_MARK,
+	CAN1_TX_B_MARK,
+};
 /* - DU RGB ----------------------------------------------------------------- */
 static const unsigned int du_rgb666_pins[] = {
 	/* R[7:2], G[7:2], B[7:2] */
@@ -3946,7 +4008,7 @@ static const unsigned int vin3_clk_mux[] = {
 };
 
 static const struct {
-	struct sh_pfc_pin_group common[290];
+	struct sh_pfc_pin_group common[296];
 	struct sh_pfc_pin_group automotive[1];
 } pinmux_groups = {
 	.common = {
@@ -3963,6 +4025,12 @@ static const struct {
 		SH_PFC_PIN_GROUP(avb_mdio),
 		SH_PFC_PIN_GROUP(avb_mii),
 		SH_PFC_PIN_GROUP(avb_gmii),
+		SH_PFC_PIN_GROUP(can0_data),
+		SH_PFC_PIN_GROUP(can0_data_b),
+		SH_PFC_PIN_GROUP(can0_data_c),
+		SH_PFC_PIN_GROUP(can0_data_d),
+		SH_PFC_PIN_GROUP(can1_data),
+		SH_PFC_PIN_GROUP(can1_data_b),
 		SH_PFC_PIN_GROUP(du_rgb666),
 		SH_PFC_PIN_GROUP(du_rgb888),
 		SH_PFC_PIN_GROUP(du_clk_out_0),
@@ -4265,6 +4333,18 @@ static const char * const avb_groups[] = {
 	"avb_gmii",
 };
 
+static const char * const can0_groups[] = {
+	"can0_data",
+	"can0_data_b",
+	"can0_data_c",
+	"can0_data_d",
+};
+
+static const char * const can1_groups[] = {
+	"can1_data",
+	"can1_data_b",
+};
+
 static const char * const du_groups[] = {
 	"du_rgb666",
 	"du_rgb888",
@@ -4706,13 +4786,15 @@ static const char * const vin3_groups[] = {
 };
 
 static const struct {
-	struct sh_pfc_function common[55];
+	struct sh_pfc_function common[57];
 	struct sh_pfc_function automotive[1];
 } pinmux_functions = {
 	.common = {
 		SH_PFC_FUNCTION(audio_clk),
 		SH_PFC_FUNCTION(avb),
 		SH_PFC_FUNCTION(du),
+		SH_PFC_FUNCTION(can0),
+		SH_PFC_FUNCTION(can1),
 		SH_PFC_FUNCTION(du0),
 		SH_PFC_FUNCTION(du1),
 		SH_PFC_FUNCTION(du2),
-- 
2.17.1

