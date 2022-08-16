Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB8D5954EA
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiHPIW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiHPIVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:21:37 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8326C138;
        Mon, 15 Aug 2022 23:02:19 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27G61n9J027011;
        Tue, 16 Aug 2022 01:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660629709;
        bh=dvNYDcirb5mwprL63fZk2VUKbuQ8Kt+3VgxaO2mNxJc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qQh6o5MOFgK/0/PcJRP1ebW1BeD4sYwFCv8Y+RdWjXpaTtPo8teRbqe5brK+mBt1U
         u8RoG+s84eLTEei+J20LaMVUUgptcy60ZCjoFAkIoPQLFwgz3fmvwKChC5PJQWoQA7
         P7/xk3uzGupwgOPeVL1UTB+g+k3/FJqvd3GQCMdg=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27G61ni9016685
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Aug 2022 01:01:49 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 16
 Aug 2022 01:01:49 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 16 Aug 2022 01:01:49 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27G61dq3114915;
        Tue, 16 Aug 2022 01:01:45 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
Date:   Tue, 16 Aug 2022 11:31:37 +0530
Message-ID: <20220816060139.111934-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816060139.111934-1-s-vadapalli@ti.com>
References: <20220816060139.111934-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml     | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..5366a367c387 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -57,6 +57,7 @@ properties:
       - ti,am654-cpsw-nuss
       - ti,j721e-cpsw-nuss
       - ti,am642-cpsw-nuss
+      - ti,j7200-cpswxg-nuss
 
   reg:
     maxItems: 1
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
@@ -151,6 +152,18 @@ properties:
 
     additionalProperties: false
 
+if:
+  not:
+    properties:
+      compatible:
+        contains:
+          const: ti,j7200-cpswxg-nuss
+then:
+  properties:
+    ethernet-ports:
+      patternProperties:
+        "^port@[3-4]$": false
+
 patternProperties:
   "^mdio@[0-9a-f]+$":
     type: object
-- 
2.25.1

