Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C1E529224
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbiEPUv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348629AbiEPUvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C311381AA
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIg-0006Br-Nn
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:42 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B219C7FB6D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 227A07FB5E;
        Mon, 16 May 2022 20:26:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0a85ec5f;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 8/9] dt-bindings: can: ctucanfd: include common CAN controller bindings
Date:   Mon, 16 May 2022 22:26:24 +0200
Message-Id: <20220516202625.1129281-9-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit

| 1f9234401ce0 ("dt-bindings: can: add can-controller.yaml")

there is a common CAN controller binding. Add this to the ctucanfd
binding.

Cc: Ondrej Ille <ondrej.ille@gmail.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
index fb34d971dcb3..4635cb96fc64 100644
--- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -25,6 +25,9 @@ maintainers:
   - Ondrej Ille <ondrej.ille@gmail.com>
   - Martin Jerabek <martin.jerabek01@gmail.com>
 
+allOf:
+  - $ref: can-controller.yaml#
+
 properties:
   compatible:
     oneOf:
-- 
2.35.1


