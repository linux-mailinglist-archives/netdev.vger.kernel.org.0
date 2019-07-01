Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512D65B8BA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfGAKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:10:07 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:47383 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfGAKKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:10:07 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 784D32000E;
        Mon,  1 Jul 2019 10:10:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next 1/8] Documentation/bindings: net: ocelot: document the PTP bank
Date:   Mon,  1 Jul 2019 12:03:20 +0200
Message-Id: <20190701100327.6425-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701100327.6425-1-antoine.tenart@bootlin.com>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One additional register range needs to be described within the Ocelot
device tree node: the PTP. This patch documents the binding needed to do
so.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 Documentation/devicetree/bindings/net/mscc-ocelot.txt | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc-ocelot.txt b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
index 9e5c17d426ce..0afadfaa33ee 100644
--- a/Documentation/devicetree/bindings/net/mscc-ocelot.txt
+++ b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
@@ -12,6 +12,7 @@ Required properties:
   - "sys"
   - "rew"
   - "qs"
+  - "ptp"
   - "qsys"
   - "ana"
   - "portX" with X from 0 to the number of last port index available on that
@@ -44,6 +45,7 @@ Example:
 		reg = <0x1010000 0x10000>,
 		      <0x1030000 0x10000>,
 		      <0x1080000 0x100>,
+		      <0x10e0000 0x10000>,
 		      <0x11e0000 0x100>,
 		      <0x11f0000 0x100>,
 		      <0x1200000 0x100>,
@@ -57,9 +59,10 @@ Example:
 		      <0x1280000 0x100>,
 		      <0x1800000 0x80000>,
 		      <0x1880000 0x10000>;
-		reg-names = "sys", "rew", "qs", "port0", "port1", "port2",
-			    "port3", "port4", "port5", "port6", "port7",
-			    "port8", "port9", "port10", "qsys", "ana";
+		reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+			    "port2", "port3", "port4", "port5", "port6",
+			    "port7", "port8", "port9", "port10", "qsys",
+			    "ana";
 		interrupts = <21 22>;
 		interrupt-names = "xtr", "inj";
 
-- 
2.21.0

