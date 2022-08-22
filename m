Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F43C59B9EF
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiHVHCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 03:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiHVHB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 03:01:56 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DF728728;
        Mon, 22 Aug 2022 00:01:55 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27M71bx0088354;
        Mon, 22 Aug 2022 02:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1661151697;
        bh=qjOW2wm6UMJez5b9j/jTpRUxMd5e111mN/pClFPohg0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tpGrezxHXbALbqL0RjBpv9AOfIcjdGFE/JpUYbIQKfdeOMH8a3u6oEpnrzGWGtoLX
         sdlHNZFzx9mdv71G1rTh9qqosp3ndslPsHsddfMnxAJmKB1gPvzMWSwB2dodAvuQBA
         1EryykrY0Lmw/8jM6kpAd8RLtdZiX48JL32zcZ4k=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27M71bSN034033
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Aug 2022 02:01:37 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Mon, 22
 Aug 2022 02:01:37 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Mon, 22 Aug 2022 02:01:36 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27M71Qls030502;
        Mon, 22 Aug 2022 02:01:32 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v5 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
Date:   Mon, 22 Aug 2022 12:31:23 +0530
Message-ID: <20220822070125.28236-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822070125.28236-1-s-vadapalli@ti.com>
References: <20220822070125.28236-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml    | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..9ef11913052c 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -55,6 +55,7 @@ properties:
   compatible:
     enum:
       - ti,am654-cpsw-nuss
+      - ti,j7200-cpswxg-nuss
       - ti,j721e-cpsw-nuss
       - ti,am642-cpsw-nuss
 
@@ -110,7 +111,7 @@ properties:
         const: 0
 
     patternProperties:
-      port@[1-2]:
+      "^port@[1-4]$":
         type: object
         description: CPSWxG NUSS external ports
 
@@ -119,7 +120,7 @@ properties:
         properties:
           reg:
             minimum: 1
-            maximum: 2
+            maximum: 4
             description: CPSW port number
 
           phys:
@@ -178,6 +179,19 @@ required:
   - '#address-cells'
   - '#size-cells'
 
+allOf:
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: ti,j7200-cpswxg-nuss
+    then:
+      properties:
+        ethernet-ports:
+          patternProperties:
+            "^port@[3-4]$": false
+
 additionalProperties: false
 
 examples:
-- 
2.25.1

