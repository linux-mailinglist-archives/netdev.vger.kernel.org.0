Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138D235DBD0
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbhDMJwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbhDMJwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:52:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF3C06175F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFiO-0002Qn-4L
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:12 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9C29B60DA77
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 314AF60DA42;
        Tue, 13 Apr 2021 09:52:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9924105a;
        Tue, 13 Apr 2021 09:52:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 01/14] dt-bindings: net: can: rcar_can: Document r8a77961 support
Date:   Tue, 13 Apr 2021 11:51:48 +0200
Message-Id: <20210413095201.2409865-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413095201.2409865-1-mkl@pengutronix.de>
References: <20210413095201.2409865-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Document SoC specific bindings for R-Car M3-W+ (r8a77961) SoC.

Also as R8A7796 is now called R8A77960 so that update those
references.

Link: https://lore.kernel.org/r/20210409000020.2317696-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/rcar_can.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
index 6a5956347816..90ac4fef23f5 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
@@ -19,7 +19,8 @@ Required properties:
 	      "renesas,can-r8a7793" if CAN controller is a part of R8A7793 SoC.
 	      "renesas,can-r8a7794" if CAN controller is a part of R8A7794 SoC.
 	      "renesas,can-r8a7795" if CAN controller is a part of R8A7795 SoC.
-	      "renesas,can-r8a7796" if CAN controller is a part of R8A7796 SoC.
+	      "renesas,can-r8a7796" if CAN controller is a part of R8A77960 SoC.
+	      "renesas,can-r8a77961" if CAN controller is a part of R8A77961 SoC.
 	      "renesas,can-r8a77965" if CAN controller is a part of R8A77965 SoC.
 	      "renesas,can-r8a77990" if CAN controller is a part of R8A77990 SoC.
 	      "renesas,can-r8a77995" if CAN controller is a part of R8A77995 SoC.
@@ -40,7 +41,7 @@ Required properties:
 - pinctrl-names: must be "default".
 
 Required properties for R8A774A1, R8A774B1, R8A774C0, R8A774E1, R8A7795,
-R8A7796, R8A77965, R8A77990, and R8A77995:
+R8A77960, R8A77961, R8A77965, R8A77990, and R8A77995:
 For the denoted SoCs, "clkp2" can be CANFD clock. This is a div6 clock and can
 be used by both CAN and CAN FD controller at the same time. It needs to be
 scaled to maximum frequency if any of these controllers use it. This is done

base-commit: 8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2
-- 
2.30.2


