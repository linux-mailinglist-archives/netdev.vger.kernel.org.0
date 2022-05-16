Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A8D529260
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347865AbiEPUwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348623AbiEPUvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A3A366AC
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIg-0006At-4o
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:42 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4C27D7FB63
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CC6B57FB56;
        Mon, 16 May 2022 20:26:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5ae4276d;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 7/9] dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required
Date:   Mon, 16 May 2022 22:26:23 +0200
Message-Id: <20220516202625.1129281-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The Renesas R-Car CAN FD Controller always uses two or more interrupts.
Make the interrupt-names properties a required property, to make it
easier to identify the individual interrupts.

Update the example accordingly.

Link: https://lore.kernel.org/all/a68e65955e0df4db60233d468f348203c2e7b940.1651512451.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml        | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 9fc137fafed9..6f71fc96bc4e 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -88,6 +88,7 @@ required:
   - compatible
   - reg
   - interrupts
+  - interrupt-names
   - clocks
   - clock-names
   - power-domains
@@ -136,7 +137,6 @@ then:
         - const: rstc_n
 
   required:
-    - interrupt-names
     - reset-names
 else:
   properties:
@@ -167,6 +167,7 @@ examples:
             reg = <0xe66c0000 0x8000>;
             interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
                          <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "ch_int", "g_int";
             clocks = <&cpg CPG_MOD 914>,
                      <&cpg CPG_CORE R8A7795_CLK_CANFD>,
                      <&can_clk>;
-- 
2.35.1


