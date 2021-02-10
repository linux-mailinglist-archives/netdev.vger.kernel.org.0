Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABC63162A7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhBJJs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBJJsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:48:01 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C1C06174A;
        Wed, 10 Feb 2021 01:47:21 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id x7so146938ljc.5;
        Wed, 10 Feb 2021 01:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X0q5IddP/axEMBWVjCa6ciUtMnAzBD6gUjo6LmKWOyA=;
        b=b4CofQciXhkczIedysH+ZLGmKXpzF+gUULaXqrTUFr55KzOwzPxPml7MymDUtPRfGf
         NRXHduCQc+C2/MZrp/XdH0YRTHkTN3cC9Fy5SX/sNWrkyOC85dI9T+6aNH6cy180iZ2m
         Sdgfylo9V+0Z0zxuat2Eh3K6Qf25Q+cydFiztJpvYWHNGP0/I26v+dCFbT6x8+SMeFXD
         +U9H80uu9Woh4CL8a0h+1lsclnWHw63ENSJL74TbLufxEk2NULzwIxAYimcKdj6XrIf4
         yPkSpifxEmq7r4cmorfh4+GziiO3KJo8dm6i+nyw27joV6QRyTKOuop3hIUbh7Q0YOFE
         R0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0q5IddP/axEMBWVjCa6ciUtMnAzBD6gUjo6LmKWOyA=;
        b=UooEAMMxwhFI9/e8vV89pTEZQF19f4RP2IfVHdCndPQERXCNzGImQCjyTT+uof7Yz7
         B7mEY3TKWYJTtNJ1vA3DY8+I6QGOmHQI3D56BgoQJtN5ZoatSSSfIDDuwrykbHlIQfX7
         z9fwcGecr8KZeeOQR1hyJiEc4Vc+TwfxChxNz+Yrm3sdjgKZ5VMgExtpZa0V9iYpYOmm
         vd5wr3tPWUUCkO716lHRTnIntvfSZos2XnmP8i3aOLTHpC2VMxq1nELHMm2AzgrZTW0F
         65whhUbZs+nNeCI3ACF0DiufttSIgz0h096ZwXyX0MhAj5v2EMaFQTBEGIVvc+uooS6H
         W/tQ==
X-Gm-Message-State: AOAM532ycBAsyVQ47Dv3sutA3PQ0N6szRuT7fbjiGHwpBGop4ZVhbIkv
        A1yUooztAb3Fjq1tj+b2AR8=
X-Google-Smtp-Source: ABdhPJxBUe1W4KtyWanWkYhS9ph1/WjuiFdQdHuDvLhu/oDL2rpCI+D8GvTt9XiqFehL7A4sVIOvmA==
X-Received: by 2002:a05:651c:38f:: with SMTP id e15mr1410799ljp.420.1612950439723;
        Wed, 10 Feb 2021 01:47:19 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id c23sm229188lfi.241.2021.02.10.01.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:47:19 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V4 net-next 1/2] dt-bindings: net: document BCM4908 Ethernet controller
Date:   Wed, 10 Feb 2021 10:47:01 +0100
Message-Id: <20210210094702.24348-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209230130.4690-2-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
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
V3: Use ethernet-controller.yaml#
    Rename "compatible" value (use "-")
    Drop "interrupt-names" until it's needed
---
 .../bindings/net/brcm,bcm4908-enet.yaml       | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
new file mode 100644
index 000000000000..5050974c8550
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm4908-enet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4908 Ethernet controller
+
+description: Broadcom's Ethernet controller integrated into BCM4908 family SoCs
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: brcm,bcm4908-enet
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    description: RX interrupt
+
+required:
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@80002000 {
+        compatible = "brcm,bcm4908-enet";
+        reg = <0x80002000 0x1000>;
+
+        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.26.2

