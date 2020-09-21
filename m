Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF76C272638
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgIUNrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26700C0613A6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:14 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8x-0003ED-LU; Mon, 21 Sep 2020 15:46:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Timo=20Schl=C3=BC=C3=9Fler?= <schluessler@krause.de>
Subject: [PATCH 25/38] dt-bindings: can: mcp251x: document GPIO support
Date:   Mon, 21 Sep 2020 15:45:44 +0200
Message-Id: <20200921134557.2251383-26-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The next patch adds gpio controller support to the mcp251x driver. This
patch updates the binding accordingly.

Cc: Timo Schlüßler <schluessler@krause.de>
Link: https://lore.kernel.org/r/20200915223527.1417033-26-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../devicetree/bindings/net/can/microchip,mcp251x.txt        | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
index e689506ac38d..381f8fb3e865 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
@@ -12,6 +12,9 @@ Required properties:
 Optional properties:
  - vdd-supply: Regulator that powers the CAN controller.
  - xceiver-supply: Regulator that powers the CAN transceiver.
+ - gpio-controller: Indicates this device is a GPIO controller.
+ - #gpio-cells: Should be two. The first cell is the pin number and
+                the second cell is used to specify the gpio polarity.
 
 Example:
 	can0: can@1 {
@@ -22,4 +25,6 @@ Example:
 		interrupts = <13 IRQ_TYPE_LEVEL_LOW>;
 		vdd-supply = <&reg5v0>;
 		xceiver-supply = <&reg5v0>;
+		gpio-controller;
+		#gpio-cells = <2>;
 	};
-- 
2.28.0

