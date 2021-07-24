Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD1A3D48D1
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhGXQjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhGXQjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:39:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C8AC061575
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 10:20:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7LJi-0002Th-EB
        for netdev@vger.kernel.org; Sat, 24 Jul 2021 19:20:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2F4166569D9
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 17:19:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D83D46569AD;
        Sat, 24 Jul 2021 17:19:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 700f5537;
        Sat, 24 Jul 2021 17:19:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/6] arm64: dts: imx8mp: remove fallback compatible string for FlexCAN
Date:   Sat, 24 Jul 2021 19:19:42 +0200
Message-Id: <20210724171947.547867-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724171947.547867-1-mkl@pengutronix.de>
References: <20210724171947.547867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

FlexCAN on i.MX8MP is not derived from i.MX6Q, instead reuses from
i.MX8QM with extra ECC added and default is enabled, so that the FlexCAN
would be put into freeze mode without FLEXCAN_QUIRK_DISABLE_MECR quirk.

This patch removes "fsl,imx6q-flexcan" fallback compatible string since
it's not compatible with the i.MX6Q.

Link: https://lore.kernel.org/r/20210719073437.32078-1-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index ca38d0d6c3c4..f4eaab3ecf03 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -579,7 +579,7 @@ uart2: serial@30890000 {
 			};
 
 			flexcan1: can@308c0000 {
-				compatible = "fsl,imx8mp-flexcan", "fsl,imx6q-flexcan";
+				compatible = "fsl,imx8mp-flexcan";
 				reg = <0x308c0000 0x10000>;
 				interrupts = <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
@@ -594,7 +594,7 @@ flexcan1: can@308c0000 {
 			};
 
 			flexcan2: can@308d0000 {
-				compatible = "fsl,imx8mp-flexcan", "fsl,imx6q-flexcan";
+				compatible = "fsl,imx8mp-flexcan";
 				reg = <0x308d0000 0x10000>;
 				interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,

base-commit: 5aa1959d18003472cc741dc490c3335c5bd804e2
-- 
2.30.2


