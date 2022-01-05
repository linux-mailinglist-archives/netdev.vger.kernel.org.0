Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17C8484F2F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbiAEISo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiAEISo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:18:44 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9032BC061761;
        Wed,  5 Jan 2022 00:18:43 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 196so34561812pfw.10;
        Wed, 05 Jan 2022 00:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=erOKNKcWGj0Q2RkA2u/GhMrsfJ7aHTH2irNlMrJp4T6pm/XZdlA7zBq442ddZCCgtE
         oQemKQ5ug7zygphpKsj/A1z5XacsCrb+Abz4gEHdp/MBvZG9kKWP6bOtgKyoPU7bBHgv
         oG9JT5oj+oI9ngaUmnf6s6m0unBWw1bcCGylTn29SXNn84wWQ1cCj+EF0oipYUJo+0Ra
         BJAiZHwGYoLa8WOB6PnApBrGiU26uqhj/f+Vsos/VktY6rU9Qka2UClZ0sNFQc0y0YWe
         WWVezdTDjMeOsJcL3KSsLSnyl2UHmnbf/9w0JpWIVnfo6ydQt7EDU1WJYFbT9uQdOxrB
         IZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=Ds5cQDfMz6FJzpA2qZ3DOBzFu+p7NXasPQ8Vl+B8MrQ63jJfIpJM1t807zbclMehCT
         yE6ei3PE3ReHXNXV4ponm/Kf/8q/S3NMGnGdQXgQ0g3tmaBDjiUbwD44qMIIoCj5+l2k
         gugtrUzKgLG3s6hYrCxyJFLC+fnUrBUoZkwpXntWXNPrA+f3ZJxwT5iUQFG2ZCTdr+EU
         Xb6SsvSNvRkY8P2Ns8adNW/2hVlBZgrG/qkqHOOOIZV6YmDHit61IHJ2OtrOUGLW/+OV
         EXG7CzC2i3/dahVwXh9ugtb8YHmtekbQjE/sx8cnXpTsehjDDfvhNrJLAaP6ZyuHv/V5
         qEOA==
X-Gm-Message-State: AOAM532AhPCthuxqG8/dGR0yhULi+SnCfr6wvd+c1b1PXCCz3guALV5Q
        Y3Qc2HFlWBojVkMZkMomvc8=
X-Google-Smtp-Source: ABdhPJwhzTfX2Yw+Y35JLwLUK2bcZlQ+b4A8Ua/36vJ1PqtkQy2gkM3gmMYiCI4a7wZSMWmO0HtscQ==
X-Received: by 2002:a63:b211:: with SMTP id x17mr43512945pge.416.1641370723013;
        Wed, 05 Jan 2022 00:18:43 -0800 (PST)
Received: from localhost.localdomain (61-231-122-238.dynamic-ip.hinet.net. [61.231.122.238])
        by smtp.gmail.com with ESMTPSA id s7sm22115809pfu.133.2022.01.05.00.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 00:18:42 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v10, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Wed,  5 Jan 2022 16:17:27 +0800
Message-Id: <20220105081728.4289-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220105081728.4289-1-josright123@gmail.com>
References: <20220105081728.4289-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JosephCHANG <josright123@gmail.com>

This is a new yaml base data file for configure davicom dm9051 with
device tree

Signed-off-by: JosephCHANG <josright123@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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
2.20.1

