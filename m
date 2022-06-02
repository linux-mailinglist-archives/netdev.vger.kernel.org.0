Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D0C53B814
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiFBLq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiFBLqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:46:55 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A805F8D5;
        Thu,  2 Jun 2022 04:46:53 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 252BkWTa051113;
        Thu, 2 Jun 2022 06:46:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654170392;
        bh=f9GK7cbBgx2kpL53tzDgWg4De0q55g5xKDEsV4UsA9U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=A7tbho1Qm1yqP0VVv9wpwh1+Y6PEYDih5Mhkyyp5CIfxRVScEK+VnyqOyOUVmuXZU
         3+B6Dr5o6dcoG5AvYXAarZfIKB9Fs98VMcwJkfftSHtcP/DYLFTzownv1ZMpvISQah
         kDyb8n4PBoDk5NV56h2R2GOt9LN0VxaoTRTjaZ9U=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 252BkWFh028334
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jun 2022 06:46:32 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 2
 Jun 2022 06:46:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 2 Jun 2022 06:46:31 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 252BkDxg035959;
        Thu, 2 Jun 2022 06:46:26 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
Date:   Thu, 2 Jun 2022 17:15:56 +0530
Message-ID: <20220602114558.6204-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220602114558.6204-1-s-vadapalli@ti.com>
References: <20220602114558.6204-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 140 ++++++++++++------
 1 file changed, 98 insertions(+), 42 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..ec57bde7ac26 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -57,6 +57,7 @@ properties:
       - ti,am654-cpsw-nuss
       - ti,j721e-cpsw-nuss
       - ti,am642-cpsw-nuss
+      - ti,j7200-cpswxg-nuss
 
   reg:
     maxItems: 1
@@ -108,48 +109,103 @@ properties:
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
+                - reg
+                - phys
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
+                - reg
+                - phys
+
+  additionalProperties: false
 
 patternProperties:
   "^mdio@[0-9a-f]+$":
-- 
2.36.1

