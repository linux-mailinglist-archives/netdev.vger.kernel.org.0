Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5182599B6E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348773AbiHSMBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbiHSMBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:01:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89E9E42F6
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:01:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0ge-0007mg-NM; Fri, 19 Aug 2022 14:01:16 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0gc-000hbU-AV; Fri, 19 Aug 2022 14:01:14 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0ga-00GBah-81; Fri, 19 Aug 2022 14:01:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH net-next v1 1/7] dt-bindings: net: pse-dt: add bindings for generic PSE controller
Date:   Fri, 19 Aug 2022 14:01:03 +0200
Message-Id: <20220819120109.3857571-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819120109.3857571-1-o.rempel@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

Add binding for generic Ethernet PSE controller.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../bindings/net/pse-pd/generic-pse.yaml      | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml

diff --git a/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
new file mode 100644
index 0000000000000..64f91efa79a56
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pse-pd/generic-pse.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Power Sourcing Equipment
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: |
+  Generic PSE controller. The device must be referenced by the PHY node
+  to control power injection to the Ethernet cable.
+
+properties:
+  compatible:
+    const: ieee802.3-podl-pse-generic
+
+  '#pse-cells':
+    const: 0
+
+  ieee802.3-podl-pse-supply:
+    description: |
+      Power supply for the PSE controller
+
+additionalProperties: false
+
+required:
+  - compatible
+  - '#pse-cells'
+  - ieee802.3-podl-pse-supply
+
+examples:
+  - |
+    ethernet-pse-1 {
+      compatible = "ieee802.3-podl-pse-generic";
+      ieee802.3-podl-pse-supply = <&reg_t1l1>;
+      #pse-cells = <0>;
+    };
-- 
2.30.2

