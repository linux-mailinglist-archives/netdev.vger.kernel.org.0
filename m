Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F398C49F3D0
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346586AbiA1Gp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiA1Gp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:45:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CC8C061714;
        Thu, 27 Jan 2022 22:45:56 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so2682601pjq.3;
        Thu, 27 Jan 2022 22:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=IAu7OMZjWEqWTbsIqPbK2yYR5NmsvIfNWedLhXMcc3GtLeRBe7rb/CGmylbgkI+EDW
         ECpodbIiaS0qtgz30XlKodHhcL0Ho1L9SA2r+FQICqcuBGCoP8I3nB+ZosXicQcwzn3q
         UUg4v5st2SNaemo1A1w0YAVuBwfjNsp0qHciaXT9Ml6yUuZcmDPixY8HAi5ZpxUAvqxQ
         nhRy7URNXW1qOYMPmM7/er0OoVjcX9ifH8ywBfhGp/IueMqAfLtQVsFJiXSXHarAmUbm
         CmbgLiShDptE96HBwByeOa3tNXbTrb0q4P3FWRa78yUt5+0mLvuTuTdMwxHoz9fcitkZ
         wb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=Kw3auC6/2/Y7wi0gnjddU+4X93VoLRD3ni6aCd9DYQjBzAZIVNnKxeOU/RnK7VG9X0
         WirOz7ifAC0W7u44925u4pLa5pRI2Hl+TseOysw8se47ygHG49KM4vEQh2WRao3IMSV2
         YBYZriY6SdJy3DOiNQ1+cPbm/6ZCWRYTtBtBorKg590AQeaozoNmFS58SCDBc2ofhlaf
         h0GSBhz+dS35L3Bu9YxJ2RKgUsHKU+p1gy9HZ8sxxDu526vuFf3rTAOdYGKl6dl5fjeG
         w4kzU9ymohrZkz5bmp+2AfsYG6Ou6Mhd5k8u16hKnwwikTdaNRWKqgZwlBOpk1GANLb9
         sTMQ==
X-Gm-Message-State: AOAM532APtrfl8DOVmqAfCng4T2G6AdLPZOU3OIBD2wS0Tbfp9qy/rL3
        SaWhMbfTqEH5Qckw8VbzWgg=
X-Google-Smtp-Source: ABdhPJyFd5ea3tLSios4tqApn3TtMITDOlYbaq1yTp0LY79bc4+LAvTHSdaxGueWH4q4MWJeCAMBdQ==
X-Received: by 2002:a17:903:2307:: with SMTP id d7mr7683451plh.52.1643352356096;
        Thu, 27 Jan 2022 22:45:56 -0800 (PST)
Received: from localhost.localdomain (61-231-106-36.dynamic-ip.hinet.net. [61.231.106.36])
        by smtp.gmail.com with ESMTPSA id f8sm5460009pfv.24.2022.01.27.22.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:45:55 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v15, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri, 28 Jan 2022 14:45:31 +0800
Message-Id: <20220128064532.2654-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220128064532.2654-1-josright123@gmail.com>
References: <20220128064532.2654-1-josright123@gmail.com>
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

