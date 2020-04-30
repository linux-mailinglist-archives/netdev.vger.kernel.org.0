Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3191BF3C6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgD3JHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726902AbgD3JHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 05:07:37 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75933C09B040
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 02:07:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so5907413wrs.9
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 02:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aSnhROolTmuNxKQ1QNrIfCpkc60JhptC2Ev7o1MMRIs=;
        b=2NFtPuDai2GU04crZKM1empmfPhhA0Bls4/L4/QBIxjpleOLdh4HhLB8HS2qu8LTWe
         PTryYB1/x9f2RDQCnTnTXXDUhXqeXtQhj4/3kN0tl9iOGOBXLAMWe9DmN/abE5PjLg6v
         RRi+qi6mmiywapKBX4rE2ggqBde5iCJ6UrTKbhjMjJs5Ps+bjIgwVkttddT/E1YWAnxJ
         Odbv1sZjCOx1PajkLcUeuK/Oka3YY7QlUPVr1LJAarWD7ghoRjAE2iBp3hF944f+PytA
         iSYC5OoPZpEw/iOLkUXRWpd8uGTA+AONLKX2CYK0BXkBvzXDyvCo2322CldgdrdTaIPy
         arEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aSnhROolTmuNxKQ1QNrIfCpkc60JhptC2Ev7o1MMRIs=;
        b=qEH2MFnRwZNvq/tfpBo8xX0gUu5kfMOWnZ8Iizt9MjkU4dJVaGO67Jw61UbS6tByy0
         0NtAR3wjpZsXTy3IiP5lmd/SLZqN9nmWrswMlaFQyaH0YZ5Gf9zkFkkA0oTARazbU+Fd
         dG1TT7xmOAvODkq+ya7imEdDUKrjo3PgshwTwDE0rk1J9gvNBWBgGMH04Kk+YB9noiui
         QfSGcmIgYjWJaWnkEg1jeH7h+770D6G3e2EcsJj23Q/UA2iAFtfqrApSbvqotmDbdekf
         Zbe4H/yfOPKfPuWJWAvDcXLReVRkz0oQTY0Ju1buEx1FnwNrG2vObPQEaeALdPAJdaJz
         KDwg==
X-Gm-Message-State: AGi0Puadq5O49zi6ms54Zn3/j7DmA+Kg71BgO42tmIYNJlP+zz5er5jJ
        c2S/Wy/9twhaPMj0ypdXOZd2gez9/5HRmw==
X-Google-Smtp-Source: APiQypL+whDX5YNFdXzbe4mSiXm401XyLwWMRAoZ34VLjzYsrzmdjvMTFU4y44SUGA4hPfEVMtYeIw==
X-Received: by 2002:a5d:4b90:: with SMTP id b16mr3110846wrt.16.1588237654217;
        Thu, 30 Apr 2020 02:07:34 -0700 (PDT)
Received: from localhost.localdomain ([2a0e:b107:830:0:47e5:c676:4796:5818])
        by smtp.googlemail.com with ESMTPSA id t20sm10962025wmi.2.2020.04.30.02.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 02:07:33 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH net-next v5 2/3] dt-bindings: add Qualcomm IPQ4019 MDIO bindings
Date:   Thu, 30 Apr 2020 11:07:06 +0200
Message-Id: <20200430090707.24810-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430090707.24810-1-robert.marko@sartura.hr>
References: <20200430090707.24810-1-robert.marko@sartura.hr>
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

