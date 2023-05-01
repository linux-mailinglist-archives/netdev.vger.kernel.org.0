Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647D96F3A84
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjEAWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjEAWcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:32:10 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F4830E4;
        Mon,  1 May 2023 15:32:07 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341MVMEs014801;
        Mon, 1 May 2023 17:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682980282;
        bh=sJojSr8Wpe0gZ6WbySQHjNOucNb6OIRfQCVF8zDaBpM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=l02eWcsc3PheABDBW5Rpsq9hAUkyYI6WMy5ylB8N0YEpLX46m2hmVFddbiamvyCHC
         wvKTn1bR6vtpoyxa9hNAFb63krE3HDNSsCId2CuwRoIMrvk8Ri4sXaO84KE48hZzNQ
         G7+8VDwW8fKZxmV6Kw3s+vKoiVuvl/7jPg1R2WlE=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341MVMNU027912
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 17:31:22 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 17:31:21 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 17:31:22 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341MVLEH023009;
        Mon, 1 May 2023 17:31:21 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v3 1/4] dt-bindings: net: can: Add poll-interval for MCAN
Date:   Mon, 1 May 2023 17:31:18 -0500
Message-ID: <20230501223121.21663-2-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230501223121.21663-1-jm@ti.com>
References: <20230501223121.21663-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
routed to A53 Linux, instead they will use software interrupt by
hrtimer. To enable timer method, interrupts should be optional so
remove interrupts property from required section and introduce
poll-interval property.

Signed-off-by: Judith Mendez <jm@ti.com>
---
Changelog:
v3:
 1. Move binding patch to first in series
 2. Update description for poll-interval
 3. Add oneOf to specify using interrupts/interrupt-names or poll-interval
 4. Fix example property: add comment below 'example'

v2:
  1. Add poll-interval property to enable timer polling method
  2. Add example using poll-interval property

 .../bindings/net/can/bosch,m_can.yaml         | 36 +++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 67879aab623b..c024ee49962c 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -14,6 +14,13 @@ maintainers:
 allOf:
   - $ref: can-controller.yaml#
 
+oneOf:
+  - required:
+      - interrupts
+      - interrupt-names
+  - required:
+      - poll-interval
+
 properties:
   compatible:
     const: bosch,m_can
@@ -40,6 +47,14 @@ properties:
       - const: int1
     minItems: 1
 
+  poll-interval:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description: Enable hrtimer polling method for an M_CAN device.
+      If this property is defined in MCAN node, it tells the driver to
+      enable polling method for an MCAN device. If for an MCAN device,
+      hardware interrupt is found and hrtimer polling method is enabled,
+      the driver will use hardware interrupt method.
+
   clocks:
     items:
       - description: peripheral clock
@@ -122,8 +137,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - clocks
   - clock-names
   - bosch,mram-cfg
@@ -132,6 +145,7 @@ additionalProperties: false
 
 examples:
   - |
+    // Example with interrupts
     #include <dt-bindings/clock/imx6sx-clock.h>
     can@20e8000 {
       compatible = "bosch,m_can";
@@ -149,4 +163,22 @@ examples:
       };
     };
 
+  - |
+    // Example with timer polling
+    #include <dt-bindings/clock/imx6sx-clock.h>
+    can@20e8000 {
+      compatible = "bosch,m_can";
+      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
+      reg-names = "m_can", "message_ram";
+      poll-interval;
+      clocks = <&clks IMX6SX_CLK_CANFD>,
+               <&clks IMX6SX_CLK_CANFD>;
+      clock-names = "hclk", "cclk";
+      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
+
+      can-transceiver {
+        max-bitrate = <5000000>;
+      };
+    };
+
 ...
-- 
2.17.1

