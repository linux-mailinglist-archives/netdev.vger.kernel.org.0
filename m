Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B423729BC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfGXITM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:19:12 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:42859 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXITL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:19:11 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id E644BFF80C;
        Wed, 24 Jul 2019 08:19:08 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next v3 2/8] MIPS: dts: mscc: describe the PTP register range
Date:   Wed, 24 Jul 2019 10:17:09 +0200
Message-Id: <20190724081715.29159-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190724081715.29159-1-antoine.tenart@bootlin.com>
References: <20190724081715.29159-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds one register range within the mscc,vsc7514-switch node,
to describe the PTP registers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Acked-by: Paul Burton <paul.burton@mips.com>
---
 arch/mips/boot/dts/mscc/ocelot.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
index 33ae74aaa1bb..1e55a778def5 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -120,6 +120,7 @@
 			reg = <0x1010000 0x10000>,
 			      <0x1030000 0x10000>,
 			      <0x1080000 0x100>,
+			      <0x10e0000 0x10000>,
 			      <0x11e0000 0x100>,
 			      <0x11f0000 0x100>,
 			      <0x1200000 0x100>,
@@ -134,7 +135,7 @@
 			      <0x1800000 0x80000>,
 			      <0x1880000 0x10000>,
 			      <0x1060000 0x10000>;
-			reg-names = "sys", "rew", "qs", "port0", "port1",
+			reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
 				    "port2", "port3", "port4", "port5", "port6",
 				    "port7", "port8", "port9", "port10", "qsys",
 				    "ana", "s2";
-- 
2.21.0

