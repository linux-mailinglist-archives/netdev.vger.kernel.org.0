Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72DD538FE2
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiEaLbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbiEaLbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:31:49 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99575F95;
        Tue, 31 May 2022 04:31:48 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24VBVR8f111480;
        Tue, 31 May 2022 06:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653996687;
        bh=8AW/TNqafQO2lzCkWyyFfbkOlBVfF6tFwTj7x8a6nKQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IPy3nLZ9GIAzi9nIE2p6Lr/BY+v3nps/rKaBDXjOHYmU9jItQQGsFZhm9fXP/k47I
         3G/voKTZk1sIvsaYv4jBF4PdXuTfp54LNXIximRk08UFq3filxSnuods5dKJcbnZnn
         jNx1G3d5Kt7zimiztJ7pWmZQ5C/8tJlxvZPTRncM=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24VBVRtI031078
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 06:31:27 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 06:31:26 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 06:31:26 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24VBV92p064165;
        Tue, 31 May 2022 06:31:21 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
Date:   Tue, 31 May 2022 17:00:56 +0530
Message-ID: <20220531113058.23708-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531113058.23708-1-s-vadapalli@ti.com>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
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
ports) in order to support CPSW5G.

Changes made:
    - Change pattern properties to support 4 ports.
    - Change maximum number of CPSW ports to 4.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..f9e6eb600b41 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -110,7 +110,7 @@ properties:
         const: 0
 
     patternProperties:
-      port@[1-2]:
+      port@[1-4]:
         type: object
         description: CPSWxG NUSS external ports
 
@@ -119,7 +119,7 @@ properties:
         properties:
           reg:
             minimum: 1
-            maximum: 2
+            maximum: 4
             description: CPSW port number
 
           phys:
-- 
2.36.1

