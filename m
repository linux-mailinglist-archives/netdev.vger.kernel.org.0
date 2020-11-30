Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA792C83AB
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgK3MBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgK3MBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:01:15 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076EDC0613CF;
        Mon, 30 Nov 2020 04:00:50 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 131so10237352pfb.9;
        Mon, 30 Nov 2020 04:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lj9ZT1pXkce5/+KagnCXuquk6qct2qT6C8O4RgX4/Xg=;
        b=IZ+kgCy7F2PIHzD82xdfzWESDTLBKVDit3oepMt6or94hwmauw9zsHoPuL0ec3B4AE
         BiAfnxcDTQAzGXrHoFwTkx8xGQu1c25Lq48PslFQj1v6BzpjV6NdMjtsYggpLKEn2f7Q
         HC78lhJ+6KD9CZ+39ufaMy8VTUP5Z9awImFifRP4Pcf+Hz3G9YFkGpG1iK1aIY1YP16L
         9+dPpBP0wPwazWDrZ7+ZBHVwYxJzUi6UdGU22Eb3mfGbu3xtD1WwLp7tPfBd5NvLMIZG
         s045nSacOV5F3DJ3oo1cBlD8UUjHAPlfjpH0wv9plcdeEXcpk76/jhcyoNA8jICUlo/w
         eyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lj9ZT1pXkce5/+KagnCXuquk6qct2qT6C8O4RgX4/Xg=;
        b=RBzvJDiVMgNxhrjq6e1zeTRpxwMMP5EHRHwCYcffDMMgLt8ft3SzeTcmjizkBhISVQ
         QxNB0y+6Lbl94aq9jCqiCuIs/9WmyFwD4u23svBnr7CscFxu3yE8lg16SGDV3iRo9YQX
         9oYx7zpYigbLdWuukDCzqu3hRT8jBV6Dx/YstbuVgPwk6Qh7NM9t6EVnVM+X49H+r/xX
         VW2JWqCwWfnWGjR3a5X/h4ojSW2+Uem10jroMqCXLNWx/cH0tGqsYZygwGRoIu9VJqMZ
         qpPr0dCNd8pnYxjKYLTpE2ZqxyVTOW0Ipjw7hAftQ8r9oL5PZxmAdIXiUJ0Y1u0xqwc9
         quSw==
X-Gm-Message-State: AOAM533CuoUpjiTmxxcoOu6zTdfj8k/GkkTewTIDUavUAH6i7WbagDpU
        /8S8XvZAcO/bPw3O2q6Fw99PZwJR1tY=
X-Google-Smtp-Source: ABdhPJx3saLPTWk9JX5niWrD8QDAOqBEjZC/gsHloavwuqIlpVFqtG26bcVWa0MjLpyJXoXddoalpQ==
X-Received: by 2002:a05:6a00:13a3:b029:18b:d5d2:196 with SMTP id t35-20020a056a0013a3b029018bd5d20196mr18635748pfg.62.1606737649541;
        Mon, 30 Nov 2020 04:00:49 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id s17sm1802737pge.37.2020.11.30.04.00.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 04:00:48 -0800 (PST)
From:   Bongsu jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a UART interface
Date:   Mon, 30 Nov 2020 21:00:27 +0900
Message-Id: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Since S3FWRN82 NFC Chip, The UART interface can be used.
S3FWRN82 supports I2C and UART interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---

Changes in v2:
 -change the compatible name.
 -change the const to enum for compatible.
 -change the node name to nfc.

 .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 32 ++++++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index cb0b8a5..481bbcc 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -12,7 +12,10 @@ maintainers:
 
 properties:
   compatible:
-    const: samsung,s3fwrn5-i2c
+    oneOf:
+      - enum:
+        - samsung,s3fwrn5-i2c
+        - samsung,s3fwrn82
 
   en-gpios:
     maxItems: 1
@@ -47,10 +50,19 @@ additionalProperties: false
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
@@ -71,3 +83,17 @@ examples:
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
+            en-gpios = <&gpio 20 0>;
+            wake-gpios = <&gpio 16 0>;
+
+            status = "okay";
+        };
+    };
-- 
1.9.1

