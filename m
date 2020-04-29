Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B6B1BDA51
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 13:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgD2LHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 07:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726765AbgD2LHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 07:07:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF8C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so1549125wmh.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aSnhROolTmuNxKQ1QNrIfCpkc60JhptC2Ev7o1MMRIs=;
        b=QwXmhE5qWDAkWjzdHbjpiTsLA+p3V43d0fbmYy8GvFDksu36JE4zXU+86t7Lxg7Fet
         dovlmBqmVxNL42ccpHeogzWqvaWR+kRxQhpCvYkUSBuk8JClKGqYGEXVdB0MM0h9d+I+
         ZifFG0zbI+ZPSzM+Uz2PgPA1NLxsXoAeu9aKrCA8NRdXDVkqzK2oRL68T+uLM9HlVBJb
         aetBsbAKSz2dTjA/8zJ2IiZlvUMXhG9IGL+Ize4Qh9EWYnMWaEh2YhkWt9sfbTpbW3rG
         PU7PZD1/09P8oLJIOqcmsGZFkSaQkbAV1ToEG3gdv1k21ZtLWwWU4WyQZqpFLyCDAR1K
         TyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aSnhROolTmuNxKQ1QNrIfCpkc60JhptC2Ev7o1MMRIs=;
        b=WmkTLarJUhQvY7YbNWaFE9FEtJIxZX11srkjHKB1XYVlwSs/RLiDV9CyHcHMeHac7P
         VFopwHOQGoXVYiaTejb2YToiePRtuLm4RSUPNfXgoAjJeDrVtW1xm25OPNwJ8wLWQfGD
         aqxKACAB8CRgFPZwjw0P3vH5a22S5iAsuAY5gIg+AcE/XQi9Oh0kAjr61HGxe9R0ii+n
         tE7HUZJaw+27eozTrIhJD8Y5FSyfMNe+7pOrvasGPNrSoMCcKG3aMEnbN8q/na3LAjPt
         DPiv9ekextzFiCjGtDLx/HCARrerAYbSSmaH4PmBCY29hcapHakCfO4FtJWXSXPWMPVX
         70Tw==
X-Gm-Message-State: AGi0PuaYzC6oIten7rnKC0XhCn6+J/rzuMtCJQBC1Vi5kNhuQ+vWA/UK
        2R2HN21YdmcCAJqjbv/0XvZJkw==
X-Google-Smtp-Source: APiQypLmUgpJaxB5VPlSnHJSesl0RQ8e4JIIM5bsCt3hYva+UhaVRRCprLFOqSedCafGW2tkSNzoTg==
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr2731954wmj.34.1588158469477;
        Wed, 29 Apr 2020 04:07:49 -0700 (PDT)
Received: from localhost.localdomain ([2a0e:b107:830:0:47e5:c676:4796:5818])
        by smtp.googlemail.com with ESMTPSA id u7sm7679963wmg.41.2020.04.29.04.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 04:07:48 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH net-next v4 2/3] dt-bindings: add Qualcomm IPQ4019 MDIO bindings
Date:   Wed, 29 Apr 2020 13:07:26 +0200
Message-Id: <20200429110726.448625-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429110726.448625-1-robert.marko@sartura.hr>
References: <20200429110726.448625-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the binding document for the IPQ40xx MDIO driver.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
Changes from v3 to v4:
* Change compatible to IPQ4019

Changes from v2 to v3:
* Remove status from example

 .../bindings/net/qcom,ipq4019-mdio.yaml       | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
new file mode 100644
index 000000000000..13555a89975f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipq4019-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
+
+maintainers:
+  - Robert Marko <robert.marko@sartura.hr>
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: qcom,ipq4019-mdio
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    mdio@90000 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "qcom,ipq4019-mdio";
+      reg = <0x90000 0x64>;
+
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+      };
+
+      ethphy1: ethernet-phy@1 {
+        reg = <1>;
+      };
+
+      ethphy2: ethernet-phy@2 {
+        reg = <2>;
+      };
+
+      ethphy3: ethernet-phy@3 {
+        reg = <3>;
+      };
+
+      ethphy4: ethernet-phy@4 {
+        reg = <4>;
+      };
+    };
-- 
2.26.2

