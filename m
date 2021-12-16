Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44570476D7B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhLPJdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbhLPJdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:33:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2696FC061574;
        Thu, 16 Dec 2021 01:33:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so20014314pjb.4;
        Thu, 16 Dec 2021 01:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=oMnopA3UlmB/SwCR16s0VF6bn8Xpr5FtcaAXFvxX6SdCo65DaGKbVHAV/mddwwkzb+
         W0rZ+ggtqdzZA+CSBFaBN7AOglyXv41vQxeORa0byTtRiSSMJrKIWxQIJXNv2lmi0cYE
         NWBexC3aHwFpd4tXa7dao+AxTsw8NsM9WcbYNNE85GKQK1bc09xok9jaSj/IickjhoBX
         RplRexpQ4gLRIcgN+rqYWnmRU6v2m9uhTg6oAQUcGRGdHItDQVVXyLx7GbwXqFN1ZTUH
         Y8rXT/deUE7WUF+VLV2AXd0reOfQ/HluDd2+qCbQnwRCjJLAymp9XVU8Ww+yjsjwUVSU
         Yq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=HU0de5fh8HtXGh4ICDd5NHxzeICOK4nxiUrxmjHpsVA8v6PacEZgCeyTXOw4dLUKD+
         L9JJJ1lrdfocrHi8nSKcXpArlgkEakymBUep0GoWwj1vHprJEkUnhujvDK0C2+lEsYjc
         s3l2TsXg4jZJlteQfnMc6SVD87JoTxKru7lAZ28UqFghC6Z7uBbz1NFtKGd8X6p8C6Qu
         hKJ9SvfP5EEnRFjGjzhgDNg/W3NWjjWWPN9rHJEEy4VvGuYkFg+VFL4kEdHBE5hdGdmW
         eZ95IOOW70WNrfmac2dUQzUe785PE+WyTPzUBORIwox2cv4ICLQQwmutR+E2Vw6N7hwR
         E3kA==
X-Gm-Message-State: AOAM53363vzPQ60jdpraG/A9yRTGrjDeGEHsu8IeY1geFHuvpVqz5S5B
        eLRpz1954E3YJ0ZorSoSe8M=
X-Google-Smtp-Source: ABdhPJyNt0eiDqi5Hx889e06yv1veLDrrZyONbuvldIXrL8y31uvJnaPleUh4nCTixJjJpLvAHADPg==
X-Received: by 2002:a17:902:a504:b0:148:a2e7:fb4e with SMTP id s4-20020a170902a50400b00148a2e7fb4emr8626928plq.143.1639647193538;
        Thu, 16 Dec 2021 01:33:13 -0800 (PST)
Received: from localhost.localdomain (61-231-67-10.dynamic-ip.hinet.net. [61.231.67.10])
        by smtp.gmail.com with ESMTPSA id d9sm7033181pjs.2.2021.12.16.01.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:33:13 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v6, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu, 16 Dec 2021 17:32:45 +0800
Message-Id: <20211216093246.23738-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211216093246.23738-1-josright123@gmail.com>
References: <20211216093246.23738-1-josright123@gmail.com>
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

