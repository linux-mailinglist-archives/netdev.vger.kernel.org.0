Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6427355A9D9
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiFYMGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiFYMGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09714D07
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YF-0002QO-IJ
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0B9949F240
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7B4439F20B;
        Sat, 25 Jun 2022 12:04:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 024318a8;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Conor Dooley <conor.dooley@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN controllers
Date:   Sat, 25 Jun 2022 14:03:29 +0200
Message-Id: <20220625120335.324697-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

PolarFire SoC has a pair of CAN controllers, but as they were
undocumented there were omitted from the device tree. Add them.

Link: https://lore.kernel.org/all/20220607065459.2035746-3-conor.dooley@microchip.com
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index 8c3259134194..737e0e70c432 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -330,6 +330,24 @@ i2c1: i2c@2010b000 {
 			status = "disabled";
 		};
 
+		can0: can@2010c000 {
+			compatible = "microchip,mpfs-can";
+			reg = <0x0 0x2010c000 0x0 0x1000>;
+			clocks = <&clkcfg CLK_CAN0>;
+			interrupt-parent = <&plic>;
+			interrupts = <56>;
+			status = "disabled";
+		};
+
+		can1: can@2010d000 {
+			compatible = "microchip,mpfs-can";
+			reg = <0x0 0x2010d000 0x0 0x1000>;
+			clocks = <&clkcfg CLK_CAN1>;
+			interrupt-parent = <&plic>;
+			interrupts = <57>;
+			status = "disabled";
+		};
+
 		mac0: ethernet@20110000 {
 			compatible = "cdns,macb";
 			reg = <0x0 0x20110000 0x0 0x2000>;
-- 
2.35.1


