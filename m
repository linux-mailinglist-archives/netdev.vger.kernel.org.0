Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A347EE35
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 11:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352415AbhLXKQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 05:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352402AbhLXKQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 05:16:37 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F84CC061757;
        Fri, 24 Dec 2021 02:16:37 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so11234307pja.1;
        Fri, 24 Dec 2021 02:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=mWZu42pr3NEfXHq/YX2Ah6ebo3vRkInD9F5kyYIkbaGbehc8R99U+Kq4hPpFPv14cF
         sAm2DxRFjQH/bJ2fAoYNb9g9lPOnN1uznWwP6tRnbbrrLm+CKuO+yMYAAfQ8yhqwdItp
         2iqkJ9N1IuP2JY88aqt8LFt5LiSslvVrR/8T44eLb893+JUZNZ97QOMZOg6wLennl9/o
         NcnQXX9i7hi2Dk2fNoTv1wOn+sxMoTmWZ02SSFniLfF9U4jOU+MwbSJk7JSaEpHW5s6I
         IpRDy/kDWZ6lrOauIIlQz7Slft0jRwO0e72joZvs5yTONKukOcO1YKWr3Nfc6FPBdthB
         Kr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=eNmx1A4yqr77OH0wOGAA4QbIys933lVp8Yfn835gdXbdU9660Fzc//NNLzdUdNYx5i
         76G/hsFXcD36FwSBqXWbNS4ThgJKSzTA8ppWzJaw0VMY95rNw6xP1ETgmUYAHCT9crQc
         uy+gOxd7jMseMkEmtXGIwcHPX+Q58g3jsaz72+X5NsDu7c/cUvrpWd+m4Hl83kxNHNP8
         N6lpDlJXPTH3IJdvhUqA6Z28oclvQop8NeeI5CE4JOpLeVL97hW7mkIxrR+izRU66DPk
         n6uzYUUgwX152vjxAm2GWt4olcUQ0LAkD1sMR6g2dOggQzbKgjlk/w3mqrf5jtEj0bKF
         yf3w==
X-Gm-Message-State: AOAM531K6+Cpgz9YtF/Q0mNKNzQFPxaxTHYeWYsjLYqpcqPlIENg+Nsf
        ZoyqZEIZkKtgItjakgFqHQAAVn7ubxI=
X-Google-Smtp-Source: ABdhPJxbJ+I3RJKs9KyT4sgfFNgPS08CdlL4WVX5yjp+VT/BLS0LB2AgpN53s/u4A7ZD007urJM+YQ==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr7088695pjl.199.1640340996546;
        Fri, 24 Dec 2021 02:16:36 -0800 (PST)
Received: from localhost.localdomain (61-231-112-151.dynamic-ip.hinet.net. [61.231.112.151])
        by smtp.gmail.com with ESMTPSA id ot6sm9239296pjb.32.2021.12.24.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 02:16:36 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v8, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri, 24 Dec 2021 18:16:05 +0800
Message-Id: <20211224101606.10125-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211224101606.10125-1-josright123@gmail.com>
References: <20211224101606.10125-1-josright123@gmail.com>
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

