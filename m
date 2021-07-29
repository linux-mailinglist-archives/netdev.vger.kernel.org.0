Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767093DA370
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhG2Myx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:54:53 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:55061 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbhG2Myk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:54:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627563278; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=iMK8FI0oEPFlRjYP5P/2YGSoZeIKf/5Pdthi5xora9I=; b=t+zIhOEbs7RaiEDWsoWbgXNHKraPsbV9ABA73G/gJ5us9lTvYxodVJ21OAt3sMIXdxCdxQRA
 R2Fj7MTX5eLVvp+V7Wy/uHVt4jXbplEEdAGgqat6K3JVv4RRpxiDxvXc+G7lnQTwEL7cJrE4
 vpoC/nBWxkRENtrYHr59gxExJ7E=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6102a50a17c2b4047d44b4d8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 29 Jul 2021 12:54:34
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1B4E9C4338A; Thu, 29 Jul 2021 12:54:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 91D1BC4338A;
        Thu, 29 Jul 2021 12:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 91D1BC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
Date:   Thu, 29 Jul 2021 20:53:58 +0800
Message-Id: <20210729125358.5227-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210729125358.5227-1-luoj@codeaurora.org>
References: <20210729125358.5227-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rename ipq4019-mdio.yaml to ipq-mdio.yaml for supporting more
ipq boards such as ipq40xx, ipq807x, ipq60xx and ipq50xx.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 ...m,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/net/{qcom,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} (58%)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
similarity index 58%
rename from Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
rename to Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
index 0c973310ada0..5bdeb461523b 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/qcom,ipq4019-mdio.yaml#
+$id: http://devicetree.org/schemas/net/qcom,ipq-mdio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
+title: Qualcomm IPQ MDIO Controller Device Tree Bindings
 
 maintainers:
   - Robert Marko <robert.marko@sartura.hr>
@@ -14,7 +14,9 @@ allOf:
 
 properties:
   compatible:
-    const: qcom,ipq4019-mdio
+    oneOf:
+      - const: qcom,ipq4019-mdio
+      - const: qcom,ipq-mdio
 
   "#address-cells":
     const: 1
@@ -23,7 +25,29 @@ properties:
     const: 0
 
   reg:
-    maxItems: 1
+    maxItems: 2
+
+  clocks:
+    items:
+      - description: MDIO clock
+
+  clock-names:
+    items:
+      - const: gcc_mdio_ahb_clk
+
+  resets:
+    items:
+      - description: MDIO reset & GEPHY hardware reset
+
+  reset-names:
+    items:
+      - const: gephy_mdc_rst
+
+  phy-reset-gpios:
+    maxItems: 3
+    description:
+      The phandle and specifier for the GPIO that controls the RESET
+      lines of PHY devices on that MDIO bus.
 
 required:
   - compatible
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

