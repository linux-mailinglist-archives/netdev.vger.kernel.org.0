Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313212CBBDF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgLBLsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgLBLsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:48:35 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25766C0613D4;
        Wed,  2 Dec 2020 03:48:10 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id p6so981920plr.7;
        Wed, 02 Dec 2020 03:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YgkXdxVYJGCqGi2vM/3GSDk0U6gyJJvLBMGDPOGgYCY=;
        b=AALNwzOvnIe1ZF2NsDfwryuf9Sp52NKnm25C1gMCRZSUXqxZoYtHbxQR9kdRywBUOU
         Sr1VfYVQ6CBJnglK/9f6yPCFKf3cvh28gVQlUTxeAFeQL6ZuPkBk41yiOrlm+Rw9WT4a
         M8isyrmKOQDMZF+btGHh08AVywjkgfTWpq8e91c3x/VT42Xe4hbKdZODDKdCGWIoKuC6
         og+AWw8y0j7yBdeGRHH5Cw8uIfzi0cxOSxRXbRu+MUDC/OXe0a+Kfbk8eVjoTYLtb6l6
         zj/KQEK6YS68aZEQj/2cdmO280fwF5f+h+TmyxTovmm2fiYg+U06c9Tvufls+3J/QsjV
         tTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YgkXdxVYJGCqGi2vM/3GSDk0U6gyJJvLBMGDPOGgYCY=;
        b=jS2zWJDoqvb49btKhLPz9CGoNHhx6ywuCy2/sK2HYAidajU9/ivxSy07YrMNlw/ZAe
         SHgmd6OvObJEwzWoYoajgQigo8vGIG1iCAdzJ3rRFbNXDG52mQYvj80VWVhw8y9BDk2E
         bqXogil8L8KSGjZFGc6lkZ0RvlW5aGjLnQfUNljGg5dP313S0+056qXZoQnH7cK54lH2
         Yt/QbV61myjqvHMHAHp8ddLo3G+aS7lVHgZeJnMzCo7XPx5/jMvj3/XMmZSjRjxVV3M1
         ahhq5cgOeHZbydPCnqXlVSSTRS9mhWIPfYgjsk05L6BVEq6Xfa91aQ2TTsEBErODbazJ
         15/g==
X-Gm-Message-State: AOAM532xIzPfTdEB/eRDTyImY77aTkATYYYjIg048YCSrZnhFsHjPF8S
        WzVqJg/yH2IhRM+1oQkEwg7v1S1hPCU=
X-Google-Smtp-Source: ABdhPJw5QtTAHCtBGn/aDXDjDAtHSw+WDVNqOZy47uX3ijKPOkhFoo7ATeLwKyfJVzsSTe0U55A4xA==
X-Received: by 2002:a17:90a:6fc7:: with SMTP id e65mr2091450pjk.116.1606909689747;
        Wed, 02 Dec 2020 03:48:09 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q18sm2108806pfs.150.2020.12.02.03.48.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 03:48:09 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v5 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a UART interface
Date:   Wed,  2 Dec 2020 20:47:38 +0900
Message-Id: <1606909661-3814-2-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Since S3FWRN82 NFC Chip, The UART interface can be used.
S3FWRN82 supports I2C and UART interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 31 +++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index cb0b8a5..ca3904b 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -12,7 +12,9 @@ maintainers:
 
 properties:
   compatible:
-    const: samsung,s3fwrn5-i2c
+    enum:
+      - samsung,s3fwrn5-i2c
+      - samsung,s3fwrn82
 
   en-gpios:
     maxItems: 1
@@ -47,10 +49,19 @@ additionalProperties: false
 required:
   - compatible
   - en-gpios
-  - interrupts
-  - reg
   - wake-gpios
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: samsung,s3fwrn5-i2c
+    then:
+      required:
+        - interrupts
+        - reg
+
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
@@ -71,3 +82,17 @@ examples:
             wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
         };
     };
+  # UART example on Raspberry Pi
+  - |
+    uart0 {
+        status = "okay";
+
+        nfc {
+            compatible = "samsung,s3fwrn82";
+
+            en-gpios = <&gpio 20 GPIO_ACTIVE_HIGH>;
+            wake-gpios = <&gpio 16 GPIO_ACTIVE_HIGH>;
+
+            status = "okay";
+        };
+    };
-- 
1.9.1

