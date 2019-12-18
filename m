Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945421252BE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfLRUIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:08:40 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34779 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfLRUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:08:40 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcc-0004WU-MA; Wed, 18 Dec 2019 21:08:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcb-0004be-8b; Wed, 18 Dec 2019 21:08:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de, devicetree@vger.kernel.org
Subject: [PATCH v2 4/4] dt-bindings: net: dsa: document additional Microchip KSZ8863/8873 switch
Date:   Wed, 18 Dec 2019 21:08:31 +0100
Message-Id: <20191218200831.13796-5-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
References: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a 3-Port 10/100 Ethernet Switch. One CPU-Port and two
Switch-Ports.

Cc: devicetree@vger.kernel.org
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
v1 -> v2: - nothing changes
          - already Acked-by Rob Herring

 Documentation/devicetree/bindings/net/dsa/ksz.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
index 95e91e84151c3..a5d71862f53cb 100644
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
@@ -8,6 +8,8 @@ Required properties:
   - "microchip,ksz8765"
   - "microchip,ksz8794"
   - "microchip,ksz8795"
+  - "microchip,ksz8863"
+  - "microchip,ksz8873"
   - "microchip,ksz9477"
   - "microchip,ksz9897"
   - "microchip,ksz9896"
-- 
2.24.0

