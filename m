Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99EF4719AA
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 11:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhLLKpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 05:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhLLKpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 05:45:12 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0367C061714;
        Sun, 12 Dec 2021 02:45:11 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 8so12499798pfo.4;
        Sun, 12 Dec 2021 02:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Th6+Jl1xmPKdgTEdCjnHkThFigHSCAUZHkw9mjFCqbo=;
        b=YSfPfW5dRLGbKpr8mscURCHOA95Yk0g1EIIUQqQT8hfTiFrADEKxhTM8vGNTWWj3V8
         9sluxYp90oc7B/fXIvI+MAWQfroM+1XtlKFsqrqNnQT4dxL92rzXHK924R/4Tsx52ent
         8KQMc86WxbAbGkM9Ba6nxSvI1JIWkYDhnVY5fD1U53t0RUMa1SSJAhQmsdyDj/sNIxWq
         5e3Ki3vVIkMLxayj4VbJVg1Bo0PXEHOL7feuYr58fAWjLPOCHDMIn1pX+n+QnIgKvI6k
         ZxokBGvO36Cg/5b0m1vYd57vgkbqKqpISEoYaSAuOCrTZw1KS7YrmM5Fvy/71RchKFFT
         kqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Th6+Jl1xmPKdgTEdCjnHkThFigHSCAUZHkw9mjFCqbo=;
        b=JaeGQd6o66Ba5kU4lFU+Z6l/NUntpaYqDFjgOW+h/YxEm4G/hhTL03qGZyvP+H3Loe
         BMH7BV3Y+0J8Yw5zroYeFN6XVoP0KdzlqXgmcpH6D5y1AunAmErWwwtF3MskObzoewr1
         qAAnSgUSPp2nL5uGIG3RFN901/gqk/5Vdbd9A9uWfNNIhbLB+CJXRe9yRhbHm0Vr4wD4
         kE7lI2gdKug87XuS6hhzZH3cxuX4ogwIR6wwTrTkswnwHFs+t/3l6XVvImJGx7e418xI
         iTQxcjmHL0BfoVVFBYBIg1W3ZCHKFVbTKScQRJnvSEXYVfL4SAwf9VNVb/9enuTPJ5Of
         2gxQ==
X-Gm-Message-State: AOAM531qkk3EyLro4MzP0jViZmvTI2fh/JHfwxMpFICS40xoa/yREkWz
        72cK58qjaeWbnyUEEvM9R+xMewggRSPc2w==
X-Google-Smtp-Source: ABdhPJwbSmgXYd5WbI4P0pQu+JZ0GOmzKfBwxIIYsF8UwSeLCVBYbsjFzcLHN6o0kLQmg1bSgeQO3w==
X-Received: by 2002:a63:b59:: with SMTP id a25mr8368099pgl.463.1639305911223;
        Sun, 12 Dec 2021 02:45:11 -0800 (PST)
Received: from LAPTOP-M5MOLEEC.localdomain (111-243-35-130.dynamic-ip.hinet.net. [111.243.35.130])
        by smtp.gmail.com with ESMTPSA id k19sm8291722pff.20.2021.12.12.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 02:45:10 -0800 (PST)
From:   Joseph CHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Sun, 12 Dec 2021 18:46:03 +0800
Message-Id: <20211212104604.20334-2-josright123@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211212104604.20334-1-josright123@gmail.com>
References: <20211212104604.20334-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new yaml base data file for configure davicom dm9051 with
device tree

Signed-off-by: Joseph CHANG <josright123@gmail.com>
---
 .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..52e852fef753
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/davicom,dm9051.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Davicom DM9051 SPI Ethernet Controller
+
+maintainers:
+  - Joseph CHANG <josright123@gmail.com>
+
+description: |
+  The DM9051 is a fully integrated and cost-effective low pin count single
+  chip Fast Ethernet controller with a Serial Peripheral Interface (SPI).
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: davicom,dm9051
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 45000000
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  # Raspberry Pi platform
+  - |
+    /* for Raspberry Pi with pin control stuff for GPIO irq */
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            local-mac-address = [00 00 00 00 00 00];
+            interrupt-parent = <&gpio>;
+            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <31200000>;
+        };
+    };
-- 
2.25.1

