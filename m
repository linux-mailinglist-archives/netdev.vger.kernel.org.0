Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12103113D7
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 22:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBEVqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 16:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhBEVq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 16:46:26 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF1C061756;
        Fri,  5 Feb 2021 13:45:45 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id v5so9763690lft.13;
        Fri, 05 Feb 2021 13:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Di6p90oAYaCEY0Dm7sI6vpfXpEsHy9/oRKceNj8Eu0c=;
        b=bnwIcV7ljZpqyM7r4u5xSmL+DGO823uc+2ePYgM95Lb/WkSYknFEbZjyL3OOSsJRXY
         Z9tzg15UKeZGuNa1nNhmkqD7K5Cmr5dElD/HCVGJd8ZV5HLNtlEwKXf/mzcC2Pv4sN35
         UTPuxGfy/54mnAS6SM+PQENTZgGDQLBo7kKrK8MWmnC3MXV2MtYP8fR7Iy7s21TZ/q1/
         rPPqVUx0M9F3XtJ+wuaCAYMg8M82tAN4Xjm4kJgrHUS18pjC8nPuA7zOQFz+LjKBtb9o
         TtjocNAnj9YfFnZ+8xZBH/wu3Io3nConzEiKf/LIiYtG+Pw2YMGpZu4qCUoDl9rxURay
         9rPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Di6p90oAYaCEY0Dm7sI6vpfXpEsHy9/oRKceNj8Eu0c=;
        b=fHi/v8rSTIxn8fCQafz5XT69ovwBLysSpQ+eGKTAbc5oJ506lRc1v1DZMKDa0/be8D
         lTqqE9BJVU4PGMMoLNxWDDBCid6UwIezv2iIDrHhEdEdsUDl8hc0/cvbfrSWGN1csM+m
         ++hLp7K056cxzWs3bnlvNivRfAIB3DEvB6YbGqtDTqIV7JNgBHqTYiHOKVC6DlSm84BQ
         2bqGDLLO40KfoGT9xfFECuXVDA473ggHe7Hop47anaTQWOedBg19RDRnzWxOWE4/XubM
         hsEl9cfRKcVn2CMmqVaVZ88q3etAXAybjlhJAIC+cGbgUlSCIKj7AowZE1rAet3uVajv
         PaTA==
X-Gm-Message-State: AOAM530JWoLVOMnWenj1BTS5fH91O7US9lk+Wvqie7ALwhXgE3rNJ0GM
        Fn7gxK7KxBv6CyWwzSjUlGg=
X-Google-Smtp-Source: ABdhPJzB1CpoqZCAZ617PA8JqjZW5zkzDuz7qJVAy7Eu2HFJTPyexmkdBA3IKzaCuU/oK8utxE5xAQ==
X-Received: by 2002:a2e:a0c9:: with SMTP id f9mr3721924ljm.260.1612561544153;
        Fri, 05 Feb 2021 13:45:44 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id g4sm1102925lfu.283.2021.02.05.13.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 13:45:43 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 1/2] dt-bindings: net: document BCM4908 Ethernet controller
Date:   Fri,  5 Feb 2021 22:44:16 +0100
Message-Id: <20210205214417.11178-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
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

