Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E83FA6F9
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhH1RTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbhH1RTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:19:00 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D018C061796
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id o10so21399907lfr.11
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zdoJvRdg/wiFMUqCvkYyo5RNQaUscCsPcncLCMhtPj8=;
        b=JSEd6UfO+vckTGqHUqtIEvPBomvRc6nCbTo4zk2ouC7F/YKKp/qPS7VOn8O8sebeeO
         GGN17QJXDeDnJvs3IjsJuXo26NXZT1Nk97gsRaVoRrZBRif9RdZ9LhDLQvm+cABCLJfE
         oIUltUDBXLln3VICQCnc+hnAssGQWX/CLkgb1OZNThkeE+KqvhNNdbEei4f6bDxFUrRh
         kldxERcHEqvAyNtx/koMXyuw8vVbcSlOQz72Dy9HQY4AR8iiTFRhJtH+Y0TaTKf2Xt0e
         zgWk8qA1qnruNe3G3Jr1Jk3SUOe4CT9dkc0CmHN7ofK4YYNKnZ5/x1aEviRHpwE/tktM
         ycKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdoJvRdg/wiFMUqCvkYyo5RNQaUscCsPcncLCMhtPj8=;
        b=mMBHX0s/b81nJH0egZFBtkNs+mUIQ3GQg7KZDeaQKlwDXhn8wgR7mNDQtCgAt469E6
         b1AoQN/rZPvp5+wHiuZqL1SkS4KyTeA8KXUgS3JuGh6NBHzoU9NUEEKIMn+KVYKOVvye
         XjboZkyNgrsEcjN4oPJBdJtpPxNN2Iah/gFuiWOKaO8YgMHzqYXjuSzUGSb7wiHNoLFw
         7WFyp/2GQBZVSgxyeeswDvYIOfknvsUEul7d358q8/nlEpBasSR1nfZqzsVKsPDh61kq
         2ArUnwXacdiLGGvkmMppWy9B19JPEbQ5kQnM0OpG2fTrN7ojLMHlZVvUvMSdKOPbSppc
         shLw==
X-Gm-Message-State: AOAM532ppj+9DUyj22W/+iJu/SFzws2j5t7w4d9Uft1qy/j2HkyRxG+3
        3mSAd0cRl/aIxiITDjAJVf4YHC7hf7JsgQ==
X-Google-Smtp-Source: ABdhPJxU7ZeJD04vrPBWlbTprBhBkerweqY61V+AAWnPoF1k35K3D/1j/tBi2rZ/H5GJ0WMXccN3bg==
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr3209151lfu.377.1630171087650;
        Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p1sm202195lfo.255.2021.08.28.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 4/5 v3] ixp4xx_eth: Add devicetree bindings
Date:   Sat, 28 Aug 2021 19:15:47 +0200
Message-Id: <20210828171548.143057-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828171548.143057-1-linus.walleij@linaro.org>
References: <20210828171548.143057-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP46x PTP Timer, a companion
to the IXP4xx ethernet in newer platforms.

Cc: devicetree@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../bindings/net/intel,ixp46x-ptp-timer.yaml  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml b/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
new file mode 100644
index 000000000000..8b9b3f915d92
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel,ixp46x-ptp-timer.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP46x PTP Timer (TSYNC)
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP46x PTP timer is known in the manual as IEEE1588 Hardware
+  Assist and Time Synchronization Hardware Assist TSYNC provides a PTP
+  timer. It exists in the Intel IXP45x and IXP46x XScale SoCs.
+
+properties:
+  compatible:
+    const: intel,ixp46x-ptp-timer
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: Interrupt to trigger master mode snapshot from the
+          PRP timer, usually a GPIO interrupt.
+      - description: Interrupt to trigger slave mode snapshot from the
+          PRP timer, usually a GPIO interrupt.
+
+  interrupt-names:
+    items:
+      - const: master
+      - const: slave
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    ptp-timer@c8010000 {
+        compatible = "intel,ixp46x-ptp-timer";
+        reg = <0xc8010000 0x1000>;
+        interrupt-parent = <&gpio0>;
+        interrupts = <8 IRQ_TYPE_EDGE_FALLING>, <7 IRQ_TYPE_EDGE_FALLING>;
+        interrupt-names = "master", "slave";
+    };
-- 
2.31.1

