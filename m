Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7698E5B8AC
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfGAKFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:05:36 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:52561 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbfGAKFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:05:35 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id C6386240012;
        Mon,  1 Jul 2019 10:05:30 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next 4/8] MIPS: dts: mscc: describe the PTP ready interrupt
Date:   Mon,  1 Jul 2019 12:03:23 +0200
Message-Id: <20190701100327.6425-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701100327.6425-1-antoine.tenart@bootlin.com>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
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

