Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E968B4E7C36
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiCYV6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiCYV6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:58:31 -0400
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E66E237F6;
        Fri, 25 Mar 2022 14:56:55 -0700 (PDT)
Received: by mail-oo1-f47.google.com with SMTP id i8-20020a4a6f48000000b00324ada4b9d9so1536740oof.11;
        Fri, 25 Mar 2022 14:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=07QZdweVT8s+Pmvjh4pehebYkWYellXCpkQyazdEVlM=;
        b=sJw/ngKR1FWs4daVNO1mrysf3hbCoNILglv/IBhYayn0UTMGxIs99DuYFvp+mfXVvs
         XWRicdvFduurnRGuxxcJG4CT9qdc/OgceQtA7V6xsn56RowfQkkyp+/LJyf0l/OSf6zm
         yTB3m/eiARJW4ZVUmYC3zMm6J7zsshZHnFWrkrM8E7e1zlWBdZtgOnPRqYlCS6oF/C9o
         9vIaieV9zlCJw4ntA5VkKiybQGYyecDP9XZDpORiP24g+O2/u/gqjf8pFazxVhE1n7FL
         IhNRMvbYu3rga295TgzgeVMJbj/0jCRi8qatj9h80bbWs5cWZ0q1t3fv2oypkw9sfAHP
         kK8g==
X-Gm-Message-State: AOAM5324AJuewbE7PNR/RSNL7lHoEqVYUZkVCl47u66o/yWW7mmfPD18
        wqrGJG2V7LVDqwuBAOHEnbFIhykyZg==
X-Google-Smtp-Source: ABdhPJzBZvXkR78XCZZ9Avn8UFj380HuRR3U/MKpgPGtSQdKJX3E0Ybiwo6MLU11DIhd07X+mmSXbQ==
X-Received: by 2002:a4a:ac01:0:b0:324:910a:5d04 with SMTP id p1-20020a4aac01000000b00324910a5d04mr4861546oon.87.1648245414547;
        Fri, 25 Mar 2022 14:56:54 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id r81-20020acaf354000000b002ecf46e8016sm3380537oih.51.2022.03.25.14.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 14:56:53 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mukesh Savaliya <msavaliy@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Bayi Cheng <bayi.cheng@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Min Guo <min.guo@mediatek.com>, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix missing '/schemas' in $ref paths
Date:   Fri, 25 Mar 2022 16:56:52 -0500
Message-Id: <20220325215652.525383-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Absolute paths in $ref should always begin with '/schemas'. The tools
mostly work with it omitted, but for correctness the path should be
everything except the hostname as that is taken from the schema's $id
value. This scheme is defined in the json-schema spec.

Cc: Hector Martin <marcan@marcan.st>
Cc: Sven Peter <sven@svenpeter.dev>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mukesh Savaliya <msavaliy@codeaurora.org>
Cc: Akash Asthana <akashast@codeaurora.org>
Cc: Bayi Cheng <bayi.cheng@mediatek.com>
Cc: Chuanhong Guo <gch981213@gmail.com>
Cc: Min Guo <min.guo@mediatek.com>
Cc: netdev@vger.kernel.org
Cc: linux-spi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/apple/apple,pmgr.yaml   | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml       | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml  | 2 +-
 .../devicetree/bindings/spi/mediatek,spi-mtk-nor.yaml         | 2 +-
 Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml | 2 +-
 Documentation/devicetree/bindings/spi/sprd,spi-adi.yaml       | 2 +-
 Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml      | 4 ++--
 Documentation/devicetree/bindings/usb/mediatek,musb.yaml      | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/apple/apple,pmgr.yaml b/Documentation/devicetree/bindings/arm/apple/apple,pmgr.yaml
index b6b5d3a912b3..0dc957a56d35 100644
--- a/Documentation/devicetree/bindings/arm/apple/apple,pmgr.yaml
+++ b/Documentation/devicetree/bindings/arm/apple/apple,pmgr.yaml
@@ -42,7 +42,7 @@ patternProperties:
     description:
       The individual power management domains within this controller
     type: object
-    $ref: /power/apple,pmgr-pwrstate.yaml#
+    $ref: /schemas/power/apple,pmgr-pwrstate.yaml#
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index e60867c7c571..07a85f7b17e0 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -15,7 +15,7 @@ description:
   Ethernet switch port Description
 
 allOf:
-  - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
+  - $ref: /schemas/net/ethernet-controller.yaml#
 
 properties:
   reg:
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
index a776cd37c297..95fcb43675d6 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
@@ -103,7 +103,7 @@ patternProperties:
                  supports up to 50MHz, up to four chip selects, programmable
                  data path from 4 bits to 32 bits and numerous protocol
                  variants.
-    $ref: /spi/spi-controller.yaml#
+    $ref: /schemas/spi/spi-controller.yaml#
 
     properties:
       compatible:
diff --git a/Documentation/devicetree/bindings/spi/mediatek,spi-mtk-nor.yaml b/Documentation/devicetree/bindings/spi/mediatek,spi-mtk-nor.yaml
index be3cc7faed53..41e60fe4b09f 100644
--- a/Documentation/devicetree/bindings/spi/mediatek,spi-mtk-nor.yaml
+++ b/Documentation/devicetree/bindings/spi/mediatek,spi-mtk-nor.yaml
@@ -18,7 +18,7 @@ description: |
   capability of this controller.
 
 allOf:
-  - $ref: /spi/spi-controller.yaml#
+  - $ref: /schemas/spi/spi-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
index 055524fe8327..5a60fba14bba 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
@@ -16,7 +16,7 @@ description: The QSPI controller allows SPI protocol communication in single,
   as NOR flash.
 
 allOf:
-  - $ref: /spi/spi-controller.yaml#
+  - $ref: /schemas/spi/spi-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/spi/sprd,spi-adi.yaml b/Documentation/devicetree/bindings/spi/sprd,spi-adi.yaml
index fe014020da69..a3ab1a1f1eb4 100644
--- a/Documentation/devicetree/bindings/spi/sprd,spi-adi.yaml
+++ b/Documentation/devicetree/bindings/spi/sprd,spi-adi.yaml
@@ -44,7 +44,7 @@ description: |
   compatibility.
 
 allOf:
-  - $ref: /spi/spi-controller.yaml#
+  - $ref: /schemas/spi/spi-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml b/Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml
index 77db1233516e..df766f8de872 100644
--- a/Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml
+++ b/Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml
@@ -132,7 +132,7 @@ properties:
     default: host
 
   connector:
-    $ref: /connector/usb-connector.yaml#
+    $ref: /schemas/connector/usb-connector.yaml#
     description:
       Connector for dual role switch, especially for "gpio-usb-b-connector"
     type: object
@@ -191,7 +191,7 @@ properties:
 patternProperties:
   "^usb@[0-9a-f]+$":
     type: object
-    $ref: /usb/mediatek,mtk-xhci.yaml#
+    $ref: /schemas/usb/mediatek,mtk-xhci.yaml#
     description:
       The xhci should be added as subnode to mtu3 as shown in the following
       example if the host mode is enabled.
diff --git a/Documentation/devicetree/bindings/usb/mediatek,musb.yaml b/Documentation/devicetree/bindings/usb/mediatek,musb.yaml
index 03d62d60ce5f..11a33f9b1f17 100644
--- a/Documentation/devicetree/bindings/usb/mediatek,musb.yaml
+++ b/Documentation/devicetree/bindings/usb/mediatek,musb.yaml
@@ -63,7 +63,7 @@ properties:
     maxItems: 1
 
   connector:
-    $ref: /connector/usb-connector.yaml#
+    $ref: /schemas/connector/usb-connector.yaml#
     description: Connector for dual role switch
     type: object
 
-- 
2.32.0

