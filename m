Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69D4729BD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGXITN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:19:13 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:38839 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfGXITM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:19:12 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 8FD1DFF803;
        Wed, 24 Jul 2019 08:19:10 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next v3 3/8] Documentation/bindings: net: ocelot: document the PTP ready IRQ
Date:   Wed, 24 Jul 2019 10:17:10 +0200
Message-Id: <20190724081715.29159-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190724081715.29159-1-antoine.tenart@bootlin.com>
References: <20190724081715.29159-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One additional interrupt needs to be described within the Ocelot device
tree node: the PTP ready one. This patch documents the binding needed to
do so.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 Documentation/devicetree/bindings/net/mscc-ocelot.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc-ocelot.txt b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
index 4d05a3b0f786..3b6290b45ce5 100644
--- a/Documentation/devicetree/bindings/net/mscc-ocelot.txt
+++ b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
@@ -17,9 +17,10 @@ Required properties:
   - "ana"
   - "portX" with X from 0 to the number of last port index available on that
     switch
-- interrupts: Should contain the switch interrupts for frame extraction and
-  frame injection
-- interrupt-names: should contain the interrupt names: "xtr", "inj"
+- interrupts: Should contain the switch interrupts for frame extraction,
+  frame injection and PTP ready.
+- interrupt-names: should contain the interrupt names: "xtr", "inj". Can contain
+  "ptp_rdy" which is optional due to backward compatibility.
 - ethernet-ports: A container for child nodes representing switch ports.
 
 The ethernet-ports container has the following properties
@@ -63,8 +64,8 @@ Example:
 			    "port2", "port3", "port4", "port5", "port6",
 			    "port7", "port8", "port9", "port10", "qsys",
 			    "ana";
-		interrupts = <21 22>;
-		interrupt-names = "xtr", "inj";
+		interrupts = <18 21 22>;
+		interrupt-names = "ptp_rdy", "xtr", "inj";
 
 		ethernet-ports {
 			#address-cells = <1>;
-- 
2.21.0

