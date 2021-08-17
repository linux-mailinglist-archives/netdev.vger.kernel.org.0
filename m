Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5F3EE558
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhHQENw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHQENu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:13:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AE0C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 21:13:18 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFqTN-0003BZ-S1; Tue, 17 Aug 2021 06:13:09 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFqTM-0006ZG-6e; Tue, 17 Aug 2021 06:13:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: [PATCH v2 1/3] dt-bindings: can-controller: add support for termination-gpios
Date:   Tue, 17 Aug 2021 06:13:04 +0200
Message-Id: <20210817041306.25185-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817041306.25185-1-o.rempel@pengutronix.de>
References: <20210817041306.25185-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some boards provide GPIO controllable termination resistor. Provide
binding to make use of it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/can/can-controller.yaml      | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/can-controller.yaml b/Documentation/devicetree/bindings/net/can/can-controller.yaml
index 9cf2ae097156..298ce69a8208 100644
--- a/Documentation/devicetree/bindings/net/can/can-controller.yaml
+++ b/Documentation/devicetree/bindings/net/can/can-controller.yaml
@@ -13,6 +13,15 @@ properties:
   $nodename:
     pattern: "^can(@.*)?$"
 
+  termination-gpios:
+    description: GPIO pin to enable CAN bus termination.
+
+  termination-ohms:
+    description: The resistance value of the CAN bus termination resistor.
+    $ref: /schemas/types.yaml#/definitions/uint16-array
+    minimum: 1
+    maximum: 65535
+
 additionalProperties: true
 
 ...
-- 
2.30.2

