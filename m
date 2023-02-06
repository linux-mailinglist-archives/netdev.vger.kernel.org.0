Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036A168BDB5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjBFNST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBFNSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F37A23D96
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N7-0007ea-G7
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6E32B171309
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 734C517129A;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 517a73d2;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/47] dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
Date:   Mon,  6 Feb 2023 14:15:37 +0100
Message-Id: <20230206131620.2758724-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Despite the name, R-Car V3U is the first member of the R-Car Gen4
family.  Hence generalize this by introducing a family-specific
compatible value for R-Car Gen4.

While at it, replace "both channels" by "all channels", as the numbers
of channels may differ from two.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/all/4dea4b7dd76d4f859ada85f97094b7adeef5169f.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/renesas,rcar-canfd.yaml          | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 1eb98c9a1a26..899efa8a0614 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -28,6 +28,11 @@ properties:
               - renesas,r8a77995-canfd     # R-Car D3
           - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,r8a779a0-canfd     # R-Car V3U
+          - const: renesas,rcar-gen4-canfd # R-Car Gen4
+
       - items:
           - enum:
               - renesas,r9a07g043-canfd    # RZ/G2UL and RZ/Five
@@ -35,8 +40,6 @@ properties:
               - renesas,r9a07g054-canfd    # RZ/V2L
           - const: renesas,rzg2l-canfd     # RZ/G2L family
 
-      - const: renesas,r8a779a0-canfd      # R-Car V3U
-
   reg:
     maxItems: 1
 
@@ -60,7 +63,7 @@ properties:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
       The controller can operate in either CAN FD only mode (default) or
-      Classical CAN only mode.  The mode is global to both the channels.
+      Classical CAN only mode.  The mode is global to all channels.
       Specify this property to put the controller in Classical CAN only mode.
 
   assigned-clocks:
@@ -159,7 +162,7 @@ allOf:
         properties:
           compatible:
             contains:
-              const: renesas,r8a779a0-canfd
+              const: renesas,rcar-gen4-canfd
     then:
       patternProperties:
         "^channel[2-7]$": false
-- 
2.39.1


