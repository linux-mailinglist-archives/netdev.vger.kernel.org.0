Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9487C1171BB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLIQdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33631 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbfLIQdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:06 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy4-0001up-G8; Mon, 09 Dec 2019 17:33:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 10/13] dt-bindings: can: tcan4x5x: reset pin is active high
Date:   Mon,  9 Dec 2019 17:32:53 +0100
Message-Id: <20191209163256.12000-11-mkl@pengutronix.de>
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

From: Sean Nyekjaer <sean@geanix.com>

Change the reset pin example to active high to be in line with
the datasheet

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index 27e1b4cebfbd..e8aa21d9174e 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -36,5 +36,5 @@ tcan4x5x: tcan4x5x@0 {
 		interrupts = <14 GPIO_ACTIVE_LOW>;
 		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 		device-wake-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+		reset-gpios = <&gpio1 27 GPIO_ACTIVE_HIGH>;
 };
-- 
2.24.0

