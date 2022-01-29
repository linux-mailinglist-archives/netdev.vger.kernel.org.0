Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D591F4A30C7
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 17:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352817AbiA2Qo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 11:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352804AbiA2QoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 11:44:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BC1C061714;
        Sat, 29 Jan 2022 08:44:22 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e16so8088010pgn.4;
        Sat, 29 Jan 2022 08:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=ofNXC6QFjz/JTDom4mngHhKeKNbZ+VSuywgqcc+3EW8ftmkaVdEQcCMlQDkNazm32Q
         KXf+emEbUPB6r/Wv2+ocBjhkscv03eZauD8A0zaXH2AADteLo7+8fswzLDTOP9/ov93E
         g//ghHWhyfHGTmO25cDsJp9HCNvhzhRwSWNoj9jhHMOgHWIeB5O766jum7Nsx5VocJi2
         ii8wApoIlIYormOYRnRNOyJCL2vXwT5SQ2QkF+2stNeomTiDngBOqgDXJkcyp2uZuOan
         CAgl2jY17ttRxya5SZYNAt+Be18KEZCZe2KSB+uhZG2G/N3OC4FK9++wHUk9gbVgN4Ls
         9fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=z17u3Ji4Pp/nqS13GywztcqNX3JfVs6t+q1SzQtZn9l8tdOCjCQNTzxf1i0Wz3H0Jn
         Z4vPjSR1HQ0/kH9t4sUSxZJCbjhYlhS6+2vObScfUKsmjZ0s91mlv7l6FxCjpnnd6xn6
         xH0JxA0lfyGuKnYy1js8K7OXxqY1F7wqfAyb4TirfUN8TH4gQvJtwffsuR4jBsGfHNo9
         vmHOpFqPGCxon+XY8A0ia4dDAhPAVrpOHovhG9QhbxFVRjXOkP7yd6qoJ4HrybOYdvWv
         w9nXzXYOzwblPRdh1oH9QEPXsrN/y25dhV5KnkU1SBZe+gTOlWwxavvgT1R/FboLpl8V
         zZAQ==
X-Gm-Message-State: AOAM530DtSs69AxNZJfddX2JVdI3T2Bpf6GEWIgP2u2Xyz9DIjnAG1xG
        BGR3cCdwMH3YOc8/0vwVBI+LDEW6a203gQ==
X-Google-Smtp-Source: ABdhPJx52OJeDDNpUf1yW1NNs05N8I1gHA3rop3NP1vtyV7AstMjFnKkGytn5Va9dL3UM0qCl4OnUw==
X-Received: by 2002:a63:4147:: with SMTP id o68mr10846206pga.476.1643474661484;
        Sat, 29 Jan 2022 08:44:21 -0800 (PST)
Received: from localhost.localdomain (111-243-37-162.dynamic-ip.hinet.net. [111.243.37.162])
        by smtp.gmail.com with ESMTPSA id y193sm13770337pfb.7.2022.01.29.08.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 08:44:21 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v16, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Sun, 30 Jan 2022 00:43:45 +0800
Message-Id: <20220129164346.5535-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220129164346.5535-1-josright123@gmail.com>
References: <20220129164346.5535-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JosephCHANG <josright123@gmail.com>

This is a new yaml base data file for configure davicom dm9051 with
device tree

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: JosephCHANG <josright123@gmail.com>
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

