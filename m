Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB49D46D252
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhLHLlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbhLHLlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:18 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04972C061746;
        Wed,  8 Dec 2021 03:37:47 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r138so1796603pgr.13;
        Wed, 08 Dec 2021 03:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Vib6fTpSPyiRjlf+YMprwfiuhHMhomZU0woXAjWHHs=;
        b=kfri6vQ7OPPlIbrxczeLfIggFlrvY5Iqv/vN+lQPgqX160JHx5Cmcc3EGwhNYXZSCI
         yduZ2u46PlOF56iAoT50nEYEq75Sz7bK/FswYUM7G8Ezih+OCQAtRpMCfbRmSEZjH89o
         y5orWpRROgHMa30prhdWXBhznuwqOyAZoFpIQoc6aPBjHouh5pRmZj8Urq/XPjOHF7CM
         Wkkrha26jw+qJdXnw5mjFrvM8CJfM2ojmKYTUSqgxOvwmSOgLEa/EwBvKslSAw7fvW44
         0auI6WtaWktVUEu8Ezp3Ncd1HLHh1P+kzS0T4nJGmKXYA2qO5JiRCtclcyZyjKKWN+LB
         tNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Vib6fTpSPyiRjlf+YMprwfiuhHMhomZU0woXAjWHHs=;
        b=cHjqME7EHBle5piviMtfxyM37qZP12AJ63vosxYlBkE5d6KPtW4r0Jwr6u8IBaIQDV
         5PcX/0U8J/xa/EAvie6DaDc8yDXWRY6OfMJpUEVKwaWRuEgHhYCgC0g5VHLW9NIjWzgn
         rSZAaJ8YP/3oG7Mbidon1dGbhdzZ6nLNJgDUCPRrDn+q89NXgdksgiM314vR5/xMW1kF
         0s761knVtb0W7qtqwDmLOQvrvtQ3v8XCdgqxhdrf4HKGutt9DYM9WzJ53aiKyQbILoMQ
         //e3tgksYx9ed2+MuhB8p7ymiEJZqN2dzzw5fSarEUKS6FwtnimOS2qsTUzHg1J1aMOa
         volg==
X-Gm-Message-State: AOAM5333SDUpTz/LlKc3TGgBYnqxIx8rB6M8/sN99WYJBywrQ/fvOZ7J
        vNQy7ZyMFszeMF5LMKNwB3g=
X-Google-Smtp-Source: ABdhPJyskA3JkSDS1KEK4jJIoPZnXhMl6JgARtESvWSoQ2I0uC6BdRJFp1GjaO3VLGQ5v1SnuudvLw==
X-Received: by 2002:a63:7d1c:: with SMTP id y28mr28700829pgc.452.1638963466358;
        Wed, 08 Dec 2021 03:37:46 -0800 (PST)
Received: from LAPTOP-M5MOLEEC.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id h1sm3270813pfh.219.2021.12.08.03.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:37:46 -0800 (PST)
From:   Joseph CHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri,  3 Dec 2021 04:46:55 +0800
Message-Id: <20211202204656.4411-2-josright123@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211202204656.4411-1-josright123@gmail.com>
References: <20211202204656.4411-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For support davicom dm9051 device tree configuration

Signed-off-by: Joseph CHANG <josright123@gmail.com>
---
 .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..10db5aae20ba
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
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+additionalProperties: false
+
+examples:
+  - |
+    /* for Raspberry Pi with pin control stuff for GPIO irq */
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        dm9051@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            pinctrl-names = "default";
+            pinctrl-0 = <&eth_int_pins>;
+            interrupt-parent = <&gpio>;
+            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <31200000>;
+        };
+    };
+    gpio {
+        eth_int_pins {
+            brcm,pins = <26>;
+            brcm,function = <0>; /* in */
+            brcm,pull = <0>; /* none */
+        };
+    };
\ No newline at end of file
-- 
2.25.1

