Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8016E286A40
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgJGVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbgJGVce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D555EC0613DE
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:20 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2p-0005qi-1n; Wed, 07 Oct 2020 23:32:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        devicetree <devicetree@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 13/17] dt-bindings: can: flexcan: remove ack_grp and ack_bit from fsl,stop-mode
Date:   Wed,  7 Oct 2020 23:31:55 +0200
Message-Id: <20201007213159.1959308-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit:

    048e3a34a2e7 can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment

the driver polls the IP core's internal bit MCR[LPM_ACK] as stop mode
acknowledge and not the acknowledgment on chip level.

This means the 4th and 5th value of the property "fsl,stop-mode" isn't used
anymore. It will be removed from the driver in the next patch, so remove it
from the binding documentation.

Link: http://lore.kernel.org/r/20201006203748.1750156-14-mkl@pengutronix.de
Fixes: 048e3a34a2e7 ("can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment")
Cc: devicetree <devicetree@vger.kernel.org>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index c6152dc2d2d0..e10b6eb955e1 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -31,12 +31,10 @@ Optional properties:
               endian.
 
 - fsl,stop-mode: register bits of stop mode control, the format is
-		 <&gpr req_gpr req_bit ack_gpr ack_bit>.
+		 <&gpr req_gpr req_bit>.
 		 gpr is the phandle to general purpose register node.
 		 req_gpr is the gpr register offset of CAN stop request.
 		 req_bit is the bit offset of CAN stop request.
-		 ack_gpr is the gpr register offset of CAN stop acknowledge.
-		 ack_bit is the bit offset of CAN stop acknowledge.
 
 - fsl,clk-source: Select the clock source to the CAN Protocol Engine (PE).
 		  It's SoC Implementation dependent. Refer to RM for detailed
-- 
2.28.0

