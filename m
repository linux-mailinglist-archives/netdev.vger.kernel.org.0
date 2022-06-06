Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35BD53EB7F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiFFLFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiFFLFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:05:49 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5111AD591;
        Mon,  6 Jun 2022 04:05:47 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 256B5TM3102695;
        Mon, 6 Jun 2022 06:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654513529;
        bh=o/NbVWeD7+vJKSMmPKEOtJ1ogeQqv2aRPGTrxTqU9x0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=LjRyUOCBCOEwIOa35bBuWq4WeK390GcCbAIJH7DK1jCfRHndYw36/F2xODkMQJ3S5
         ZgvbtBZYFOJ6ndhJGYy9Gh+b9dw4H3gmBGeSLgz8wvZBu4VMUo+inGtZygfrnnLRuG
         kPFATHVbAjVVC1f5Y/7X4INmqyi7bXo5WdqmrKPo=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 256B5TMG031538
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Jun 2022 06:05:29 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Jun 2022 06:05:29 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 6 Jun 2022 06:05:29 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 256B57G3072083;
        Mon, 6 Jun 2022 06:05:23 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v3 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
Date:   Mon, 6 Jun 2022 16:34:41 +0530
Message-ID: <20220606110443.30362-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220606110443.30362-1-s-vadapalli@ti.com>
References: <20220606110443.30362-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
ports) CPSW5G module and add compatible for it.

Changes made:
    - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
    - Extend pattern properties for new compatible.
    - Change maximum number of CPSW ports to 4 for new compatible.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 135 ++++++++++++------
 1 file changed, 93 insertions(+), 42 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..49f63aaf5a08 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -57,6 +57,7 @@ properties:
       - ti,am654-cpsw-nuss
       - ti,j721e-cpsw-nuss
       - ti,am642-cpsw-nuss
+      - ti,j7200-cpswxg-nuss
 
   reg:
     maxItems: 1
@@ -108,48 +109,98 @@ properties:
         const: 1
       '#size-cells':
         const: 0
-
-    patternProperties:
-      port@[1-2]:
-        type: object
-        description: CPSWxG NUSS external ports
-
-        $ref: ethernet-controller.yaml#
-
-        properties:
-          reg:
-            minimum: 1
-            maximum: 2
-            description: CPSW port number
-
-          phys:
-            maxItems: 1
-            description: phandle on phy-gmii-sel PHY
-
-          label:
-            description: label associated with this port
-
-          ti,mac-only:
-            $ref: /schemas/types.yaml#/definitions/flag
-            description:
-              Specifies the port works in mac-only mode.
-
-          ti,syscon-efuse:
-            $ref: /schemas/types.yaml#/definitions/phandle-array
-            items:
-              - items:
-                  - description: Phandle to the system control device node which
-                      provides access to efuse
-                  - description: offset to efuse registers???
-            description:
-              Phandle to the system control device node which provides access
-              to efuse IO range with MAC addresses
-
-        required:
-          - reg
-          - phys
-
-    additionalProperties: false
+    allOf:
+      - if:
+          properties:
+            compatible:
+              contains:
+                enum:
+                  - ti,am654-cpsw-nuss
+                  - ti,j721e-cpsw-nuss
+                  - ti,am642-cpsw-nuss
+        then:
+          patternProperties:
+            port@[1-2]:
+              type: object
+              description: CPSWxG NUSS external ports
+
+              $ref: ethernet-controller.yaml#
+
+              properties:
+                reg:
+                  minimum: 1
+                  maximum: 2
+                  description: CPSW port number
+
+              required:
+                - reg
+      - if:
+          properties:
+            compatible:
+              contains:
+                enum:
+                  - ti,j7200-cpswxg-nuss
+        then:
+          patternProperties:
+            port@[1-4]:
+              type: object
+              description: CPSWxG NUSS external ports
+
+              $ref: ethernet-controller.yaml#
+
+              properties:
+                reg:
+                  minimum: 1
+                  maximum: 4
+                  description: CPSW port number
+
+              required:
+                - reg
+      - if:
+          properties:
+            compatible:
+              contains:
+                enum:
+                  - ti,am654-cpsw-nuss
+                  - ti,j721e-cpsw-nuss
+                  - ti,am642-cpsw-nuss
+                  - ti,j7200-cpswxg-nuss
+        then:
+          patternProperties:
+            port@[*]:
+              type: object
+              description: CPSWxG NUSS external ports
+
+              $ref: ethernet-controller.yaml#
+
+              properties:
+                phys:
+                  maxItems: 1
+                  description: phandle on phy-gmii-sel PHY
+
+                label:
+                  description: label associated with this port
+
+                ti,mac-only:
+                  $ref: /schemas/types.yaml#/definitions/flag
+                  description:
+                    Specifies the port works in mac-only mode.
+
+                ti,syscon-efuse:
+                  $ref: /schemas/types.yaml#/definitions/phandle-array
+                  items:
+                    - items:
+                        - description: Phandle to the system control device node which
+                            provides access to efuse
+                        - description: offset to efuse registers???
+                  description:
+                    Phandle to the system control device node which provides access
+                    to efuse IO range with MAC addresses
+
+              required:
+                - phys
+
+  additionalProperties: false
 
 patternProperties:
   "^mdio@[0-9a-f]+$":
-- 
2.36.1

