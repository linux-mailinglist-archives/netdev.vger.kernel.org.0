Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3411171C4
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLIQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38007 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLIQdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:06 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy4-0001up-TJ; Mon, 09 Dec 2019 17:33:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Rob Herring <robh@kernel.org>, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 11/13] dt-bindings: tcan4x5x: Make wake-gpio an optional gpio
Date:   Mon,  9 Dec 2019 17:32:54 +0100
Message-Id: <20191209163256.12000-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

The wake-up of the device can be configured as an optional feature of
the device. Move the wake-up gpio from a requried property to an
optional property.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Cc: Rob Herring <robh@kernel.org>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index e8aa21d9174e..6bdcc3f84bd3 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -10,7 +10,6 @@ Required properties:
 	- #size-cells: 0
 	- spi-max-frequency: Maximum frequency of the SPI bus the chip can
 			     operate at should be less than or equal to 18 MHz.
-	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
 	- interrupt-parent: the phandle to the interrupt controller which provides
                     the interrupt.
 	- interrupts: interrupt specification for data-ready.
@@ -23,6 +22,7 @@ Optional properties:
 		       reset.
 	- device-state-gpios: Input GPIO that indicates if the device is in
 			      a sleep state or if the device is active.
+	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
 
 Example:
 tcan4x5x: tcan4x5x@0 {
-- 
2.24.0

