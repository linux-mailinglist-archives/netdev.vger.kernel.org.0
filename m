Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F171DD52E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgEURuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:50:07 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57766 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgEURsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:41 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmakl052548;
        Thu, 21 May 2020 12:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083316;
        bh=qhQtOVsMxgPk0cg+E+ELGnyG52HMDl3LZZ/21Yci1Ok=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nZH6NxmBG5zy+Uqxkr3FRdSHmI6d9eH0a8JLR98ai3PbxmvpuPrjls85k+/3y4TcU
         cb1866eA4DPuR3hhUYqY7fI8sAQ8OoVsg3I2uwdcGSGdo0GG2HRyJatZZL6o0iZBNZ
         TRk54B0jKJ6Om08edd9IxuNNZOmSUuw7HU39tgzo=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LHmacd128925
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 12:48:36 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:48:35 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:48:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmZSY058993;
        Thu, 21 May 2020 12:48:35 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [RFC PATCH net-next 3/4] dt-bindings: net: Add RGMII internal delay for DP83869
Date:   Thu, 21 May 2020 12:48:33 -0500
Message-ID: <20200521174834.3234-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174834.3234-1-dmurphy@ti.com>
References: <20200521174834.3234-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the internal delay values into the header and update the binding
with the internal delay properties.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83869.yaml      | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 5b69ef03bbf7..b2547b43e103 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -64,6 +64,20 @@ properties:
        Operational mode for the PHY.  If this is not set then the operational
        mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
 
+  rx-internal-delay:
+    $ref: "#/properties/rx-internal-delay"
+    description: Delay is in pico seconds
+    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
+            3250, 3500, 3750, 4000 ]
+    default: 2000
+
+  tx-internal-delay:
+    $ref: "#/properties/tx-internal-delay"
+    description: Delay is in pico seconds
+    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
+            3250, 3500, 3750, 4000 ]
+    default: 2000
+
 required:
   - reg
 
@@ -80,5 +94,7 @@ examples:
         ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
         ti,max-output-impedance = "true";
         ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
+        rx-internal-delay = <2000>;
+        tx-internal-delay = <2000>;
       };
     };
-- 
2.26.2

