Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A432B47A8CB
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhLTLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbhLTLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:34:17 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F00C06173E;
        Mon, 20 Dec 2021 03:34:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t123so7108764pfc.13;
        Mon, 20 Dec 2021 03:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=iyTkPVrAB8eKKTsgij9M/fzgowYGg9zhGFv7XVdZEopuZb8yxsDn0+JRDB5rg53Olz
         7qQzW9vNkAJuHmQCD4CM3xMqkMq6byLeReUMD9+gl6FpUpGuWbjy/csXYfo+4J3nrFBX
         c1sZ6ybgkKFe4rZBFk8kt1MVv+ma7tR20RsBxugNU+D7vGlxsatIKdGzb2EbzIbSKvcS
         5mvP2yjDP7FRHmq6df4R/sIateEsY3XGRxOxoHpdyPIBUnCKLpS/JpbynD9iXJv1+Mvt
         TNh5/QjGoZqlYcO3mc//k7pL1ZA3yidE4PS6iEVbZjZhtWT1DI5IRvAsbYj6LI8JHxUK
         vhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=y6/jnnbfQ87/QSaAwfeO5uJGoth+bXynH6JYGCiwetc3nzFWiYGcdXOLb/0fm1i3Ok
         5fGTIneBfnaZ19MYXVsQ+EZSCpb15vBuUwTufHOrnuIXNcd+AhkIyRPTHeCSwaOL3g2J
         qA2eXqtS4q9XTeYq9sKO/hBxzQ6dXMN5k8Qf4MKs8Fp0NsPS9reiniU+7mwjJ/U1TPfk
         1o8VTZS06yQGbEtEhiei3PvLaToH8Ld6g9oubIJmd+EZ7c2yP0zeGdteBsB7FCW719Jq
         Pphuw9RayPf3iSOQgw0ReJA45WEHZ5In+6eiJZ00NYA8uj3IudZJ54VrhwtVK6HtSDU1
         rSnQ==
X-Gm-Message-State: AOAM532O5Rc+Ur7hrTECYxhaLu/bjPkyXRQ6TmtcZzqFJw7t/h37kIEa
        lNcAZMhW9QFBpeLUeARIByY=
X-Google-Smtp-Source: ABdhPJwLbYZXNlxq4F3idUEVK+FYS8wBl/4YwpoDvJpkX37cPluRLWA5zSTSPcJa6QKSP6y78vlIPA==
X-Received: by 2002:a05:6a00:26ca:b0:4a8:3129:84e with SMTP id p10-20020a056a0026ca00b004a83129084emr15865654pfw.74.1640000055991;
        Mon, 20 Dec 2021 03:34:15 -0800 (PST)
Received: from localhost.localdomain (61-231-108-100.dynamic-ip.hinet.net. [61.231.108.100])
        by smtp.gmail.com with ESMTPSA id 78sm16088152pgg.85.2021.12.20.03.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:34:15 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v7, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Mon, 20 Dec 2021 19:33:41 +0800
Message-Id: <20211220113342.11437-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211220113342.11437-1-josright123@gmail.com>
References: <20211220113342.11437-1-josright123@gmail.com>
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

