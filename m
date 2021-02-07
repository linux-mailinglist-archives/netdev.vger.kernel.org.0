Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB463127DD
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 23:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBGW1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 17:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBGW1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 17:27:44 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF642C061756;
        Sun,  7 Feb 2021 14:27:03 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id r23so12743482ljh.1;
        Sun, 07 Feb 2021 14:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Di6p90oAYaCEY0Dm7sI6vpfXpEsHy9/oRKceNj8Eu0c=;
        b=f75BMbPQ8WQQFH2FanltOAgV1MwkfM9ONOzTtMHaj6U3XwCbsxxh+BPIFZMojSFhoc
         oXNrpU3lWwo6tdBZzpqH2fWb9V/Jfo+TtTm385WZyt0C6mYkqSTv0dDmUC06Yqo1jlmG
         etV+92GNlzx0M24vb1LaJ1Pt/6SN1i9lrVyc2+P5nHaTJPTNz9WjiFq0oFhhxDvya/Ow
         lZsrRtJB9bxWNb19A9LIX3bFYCwWEy1zXSson4BOTBuKPTBdpSSkHCqQ8eBFLzqQp0rZ
         aB3k0eDtlZUGnMAZIis5Ds26ryRTYy834D32NqycvXbH41GzOvTY7tiWDCIzOp+NGBrm
         tvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Di6p90oAYaCEY0Dm7sI6vpfXpEsHy9/oRKceNj8Eu0c=;
        b=XuTWN0+U5413Fj/s4LJQ5cWq5bPKRP8yFPlGXbbBKbBOaNOjsXtL/EguvIhV6Ixr9y
         tNa8xWh19uabL0edw+zOJTp/H8ZrjKjpVR3FqJ+dhQXHBGfmh/Qg9yHEh53ZJs5T8qht
         9vfuVkYEodxRHPz1UIXy9twyYeYyzSAv9kodxEoi7CAOpQzVPYYARvMfTTW1xnD0SF6c
         hoTeny4iG+vBc+IbTzLqx2pUMj1QTHWHOjjWCp51brbAROM7p11oh0mVCmGSVcOd6PmY
         9N4YTsaTq/odLj0TKu28MaPGylpbVAKXu3KRmAG1UTDaIeqmKtAxMJm4wswI1w8wrzJ8
         gYPw==
X-Gm-Message-State: AOAM530zmf6v4I0EkXUFmTFIBlwugbQ4rOhCcJiNn4jRKbLom3iQtu61
        1xqqzRXkXZrV1M61rurZ64k=
X-Google-Smtp-Source: ABdhPJzUfoE+9NCLD/4Z/HcxCQp2kdiPk7Dr+HCTKIbGu9eFjXP/Cg0XAN/XuIshnMBNNIGsF+86Pw==
X-Received: by 2002:a2e:9d04:: with SMTP id t4mr9062916lji.56.1612736822472;
        Sun, 07 Feb 2021 14:27:02 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id n16sm502415lfe.13.2021.02.07.14.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 14:27:01 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 1/2] dt-bindings: net: document BCM4908 Ethernet controller
Date:   Sun,  7 Feb 2021 23:26:31 +0100
Message-Id: <20210207222632.10981-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210205214417.11178-1-zajec5@gmail.com>
References: <20210205214417.11178-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 is a family of SoCs with integrated Ethernet controller.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../bindings/net/brcm,bcm4908enet.yaml        | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
new file mode 100644
index 000000000000..5f12f51c5b19
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm4908enet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4908 Ethernet controller
+
+description: Broadcom's Ethernet controller integrated into BCM4908 family SoCs
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+properties:
+  compatible:
+    const: brcm,bcm4908enet
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    description: RX interrupt
+
+  interrupt-names:
+    const: rx
+
+required:
+  - reg
+  - interrupts
+  - interrupt-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@80002000 {
+        compatible = "brcm,bcm4908enet";
+        reg = <0x80002000 0x1000>;
+
+        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "rx";
+    };
-- 
2.26.2

