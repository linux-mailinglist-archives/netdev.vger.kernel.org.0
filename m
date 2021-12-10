Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEFD46FCDD
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhLJIoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbhLJIoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:44:17 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3C0C0617A1;
        Fri, 10 Dec 2021 00:40:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id k64so7826739pfd.11;
        Fri, 10 Dec 2021 00:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oLKYeVBHpaRfx8GF9lL8ChNYj8VusR4HnoqVsV3eWsg=;
        b=neh4WoCNabNrb7gR148aFTKmaq7Xf18O0mn/4KAQtuFo3J35LEYH01fnKIuXOYqwM8
         BL2WthiIyrHPXdrQDsLq1uzVYNEUbtrfOsb6gLEjQFMO0nnGGho9iURNOMBDluKoCbkW
         NF8+XahFkDInatk+y/qz9Ox2ZHMrvH40kRjPRcxevBHBoINalGMz4pKHDkDGAwgqTd9r
         +NJd/RUx2mbjQjXamc205iEmbXyZ3vZ8M+3so9vA6bbk9/zc7oQHUgeFnu/z0SdB1zAS
         8MezDfZwTuFjyLjWdsztC1yFOYn66/0yEakfIUloQ9Peh2AScPGa2ZUlCfP3Ay9td3DH
         581w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLKYeVBHpaRfx8GF9lL8ChNYj8VusR4HnoqVsV3eWsg=;
        b=eKRkNb7MvHuoi4+OHasZNMCH0gmqc8GbpucCrOF6mpDueiGLuzxCS5+0mi6XnGBa2s
         YCpS8/UgPKNlhg4milnfKl7R3ULTXGSkaaaCVp8wi6lTqdUr4Ve2VAkpRbubRZGLaD53
         qfxNvnPwh6/LgHVe2vVdzecV8D47LSVBYqKQV9/sOtR63yALauZwqPTvxhQJQeUQowpb
         /VIWt1AzGzKdrjo2+3O/34cZL3hI1dHDI8fYsZJ6lXeXv+St+mh1Sf+U80Qst2CE0o7r
         baKWdGD/VXfw0HuCuXMWW2LNmYNVbas1leAWZ4f937HoHVi1C6ajyBvAig8JA1ENNEwK
         PHwA==
X-Gm-Message-State: AOAM531t6Qd+HZcMoZpa18B+6HDQK6H8h1F5qT9fEsztdWHRKpcfvtc/
        h1AoxQwFTj5eMlco8XiIvnY=
X-Google-Smtp-Source: ABdhPJymgmEOJ+xNaFpZkOjQGb+HDPQjmVwuxruG0AMyTYuN3fZoAIQ7zTgMik2UWiN1JcC3VxH1aw==
X-Received: by 2002:a63:903:: with SMTP id 3mr38495386pgj.356.1639125642722;
        Fri, 10 Dec 2021 00:40:42 -0800 (PST)
Received: from localhost.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id w142sm2230004pfc.115.2021.12.10.00.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 00:40:42 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri, 10 Dec 2021 16:40:20 +0800
Message-Id: <20211210084021.13993-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211210084021.13993-1-josright123@gmail.com>
References: <20211210084021.13993-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For support davicom dm9051 device tree configure

Signed-off-by: JosephCHANG <josright123@gmail.com>
---
 .../bindings/net/davicom,dm9051.yaml          | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..4c2dd0362f7a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
@@ -0,0 +1,71 @@
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
+        dm9051@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            local-mac-address = [00 00 00 00 00 00];
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
-- 
2.20.1

