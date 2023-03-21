Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208F46C2E18
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCUJjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjCUJjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:39:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F8836463;
        Tue, 21 Mar 2023 02:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF84FCE17E3;
        Tue, 21 Mar 2023 09:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98FEC433D2;
        Tue, 21 Mar 2023 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679391548;
        bh=OO5zaDA6gWw6Yo8WQeWvzqILKDsdnOqeoGNGYtZyLVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj6ds/hJfqa48Lkwj+yTTqPF5GBJ2tyyUZzV1T+NVAmmgwUW81rWrVvQWsD4cuPSW
         fxRt6f0da841LGFKHab0jcMXRiOi7ro2LD84PFovx06dNiUbo8ZWVvAR/I/e3Xt8d5
         B1Lm7zTzeBwmyjo8rsDfRbaCfwZGV300ZZHAPq/KepoPpVCV2Km6FojLUVQCGFbaIS
         LMYChRIDYH9i3X1GROLo96CxwPoCmOEBdNrgb7M3HLJU+/IBR9e6cKkUredc2Df1SY
         u4Gdmv/g/ZR1fw5nV9bGXqcAf+YdsUm448oW3ChVCu2uLmT8AIy8XvwdhoooMEAMCv
         GJFPiOQ3duLkQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peYTo-0002Xy-AV; Tue, 21 Mar 2023 10:40:32 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: wireless: add ath11k pcie bindings
Date:   Tue, 21 Mar 2023 10:40:10 +0100
Message-Id: <20230321094011.9759-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321094011.9759-1-johan+linaro@kernel.org>
References: <20230321094011.9759-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6855
for which the calibration data variant may need to be described.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 .../net/wireless/qcom,ath11k-pci.yaml         | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
new file mode 100644
index 000000000000..817f02a8b481
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2023 Linaro Limited
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/qcom,ath11k-pci.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies ath11k wireless devices (PCIe)
+
+maintainers:
+  - Kalle Valo <kvalo@kernel.org>
+
+description: |
+  Qualcomm Technologies IEEE 802.11ax PCIe devices
+
+properties:
+  compatible:
+    enum:
+      - pci17cb,1103  # WCN6855
+
+  reg:
+    maxItems: 1
+
+  qcom,ath11k-calibration-variant:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: |
+      string to uniquely identify variant of the calibration data for designs
+      with colliding bus and device ids
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    pcie {
+        #address-cells = <3>;
+        #size-cells = <2>;
+
+        pcie@0 {
+            device_type = "pci";
+            reg = <0x0 0x0 0x0 0x0 0x0>;
+            #address-cells = <3>;
+            #size-cells = <2>;
+            ranges;
+
+            bus-range = <0x01 0xff>;
+
+            wifi@0 {
+                compatible = "pci17cb,1103";
+                reg = <0x10000 0x0 0x0 0x0 0x0>;
+
+                qcom,ath11k-calibration-variant = "LE_X13S";
+            };
+        };
+    };
-- 
2.39.2

