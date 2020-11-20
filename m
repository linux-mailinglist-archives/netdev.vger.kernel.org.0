Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF822BAB4A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgKTNdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgKTNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059AFC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XX-0006Fn-HK; Fri, 20 Nov 2020 14:33:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [net-next 14/25] dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
Date:   Fri, 20 Nov 2020 14:33:07 +0100
Message-Id: <20201120133318.3428231-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
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

Add IMX_SC_R_CAN(x) macro for CAN.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201106105627.31061-5-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/dt-bindings/firmware/imx/rsrc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/firmware/imx/rsrc.h b/include/dt-bindings/firmware/imx/rsrc.h
index 54278d5c1856..43885056557c 100644
--- a/include/dt-bindings/firmware/imx/rsrc.h
+++ b/include/dt-bindings/firmware/imx/rsrc.h
@@ -111,6 +111,7 @@
 #define IMX_SC_R_CAN_0			105
 #define IMX_SC_R_CAN_1			106
 #define IMX_SC_R_CAN_2			107
+#define IMX_SC_R_CAN(x)			(IMX_SC_R_CAN_0 + (x))
 #define IMX_SC_R_DMA_1_CH0		108
 #define IMX_SC_R_DMA_1_CH1		109
 #define IMX_SC_R_DMA_1_CH2		110
-- 
2.29.2

