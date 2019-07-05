Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3B960BF1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGETzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:55:22 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:48429 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfGETzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:55:22 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 4A8BD20002;
        Fri,  5 Jul 2019 19:55:15 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next v2 4/8] MIPS: dts: mscc: describe the PTP ready interrupt
Date:   Fri,  5 Jul 2019 21:52:09 +0200
Message-Id: <20190705195213.22041-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190705195213.22041-1-antoine.tenart@bootlin.com>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a description of the PTP ready interrupt, which can be
triggered when a PTP timestamp is available on an hardware FIFO.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 arch/mips/boot/dts/mscc/ocelot.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
index 1e55a778def5..797d336db54d 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -139,8 +139,8 @@
 				    "port2", "port3", "port4", "port5", "port6",
 				    "port7", "port8", "port9", "port10", "qsys",
 				    "ana", "s2";
-			interrupts = <21 22>;
-			interrupt-names = "xtr", "inj";
+			interrupts = <18 21 22>;
+			interrupt-names = "ptp_rdy", "xtr", "inj";
 
 			ethernet-ports {
 				#address-cells = <1>;
-- 
2.21.0

