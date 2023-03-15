Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DAF6BAA3F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjCOIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbjCOIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:00:16 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432C4664E8;
        Wed, 15 Mar 2023 01:00:14 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32F7xwe0047075;
        Wed, 15 Mar 2023 02:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678867198;
        bh=N5BHiqpixzK6YQc2G5jFoOiavln10/7MVw9NuZ9azB8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=j5+D76okKzd2VD9U3usJDTY/uc+IvVVaXrZOD6X4Q+g5ORVf1AN2+SuYq/PWgEYx8
         036Ls8+jP1wSxHX4eqsmJIZakYyhyrM29gB081ghcbJfb13KhTou3LpD1ZAZ6ufH2G
         fFFKXK7Oo3Vz/9odzwdpuMKmApr6HBa8pDGMhU9w=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32F7xwFF026301
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 02:59:58 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 02:59:57 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 02:59:57 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32F7xmKc042755;
        Wed, 15 Mar 2023 02:59:53 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Fix compatible order
Date:   Wed, 15 Mar 2023 13:29:47 +0530
Message-ID: <20230315075948.1683120-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315075948.1683120-1-s-vadapalli@ti.com>
References: <20230315075948.1683120-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder compatibles to follow alphanumeric order.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 628d63e1eb1f..6f56add1919b 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -54,11 +54,11 @@ properties:
 
   compatible:
     enum:
+      - ti,am642-cpsw-nuss
       - ti,am654-cpsw-nuss
       - ti,j7200-cpswxg-nuss
       - ti,j721e-cpsw-nuss
       - ti,j721e-cpswxg-nuss
-      - ti,am642-cpsw-nuss
 
   reg:
     maxItems: 1
@@ -215,8 +215,8 @@ allOf:
           compatible:
             contains:
               enum:
-                - ti,j721e-cpswxg-nuss
                 - ti,j7200-cpswxg-nuss
+                - ti,j721e-cpswxg-nuss
     then:
       properties:
         ethernet-ports:
-- 
2.25.1

