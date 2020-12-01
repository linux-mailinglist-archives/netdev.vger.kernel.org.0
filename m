Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C582CA459
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391303AbgLANvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbgLANvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:51:33 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F236BC0613CF;
        Tue,  1 Dec 2020 05:51:07 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id bj5so1181086plb.4;
        Tue, 01 Dec 2020 05:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6615kzoe5jKV8EYHaChLE8OAf7+pns9kTW6Yur3HXZU=;
        b=NGcJTYvmtwIBCDio8bmQzhsWhY5QzOoVkDoSA00zZIgB8xoEEs5EyuTOm7wmgXokek
         b/fs+Jx9TLbnuiyfLTVQSjpt9jJPFE48CRkcPIk0dPBOWnX9HLA7KCx15cECdhhRPEa1
         LQzUVdyVIWuxlbhxooLw4FJGXgoMPechVoBkIlEOsKjdfJCX80if/b639M6iPHux+G3R
         dXTvgW4rBbc/KKtbYRJBYYlYCdQDC9ZYZNDm1p5Ney8Aru1ItsTk4cL0tN4iB3jUM+5l
         EygBIiKaT3lcqsqPQf9SgjC/K7wXsql2S4QxmI1jNGxm95UYPK35lVmteQgN9zEJXCTS
         p14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6615kzoe5jKV8EYHaChLE8OAf7+pns9kTW6Yur3HXZU=;
        b=EwzracRM3uGu/iRx66qOJWKAKntLiYIdPES8sHiNIkvgZF6Nf5dCR9dfeCspwvd+Vh
         xIyhgRAC9FRPUFIkPyMqosaWB2kVKsMqdzjRuh1GnpfLkTOPKQaraAmPF17Z4RsoHF59
         ZAeeAH7nGqopV9MQ536hu8Pu642EqtumWH0P10HiuUNFpnBSieYVQhiwig0e2m1AEbP+
         ZVLqwy2eEY3UWNLMw/HlsAa6M2ELbnwI8ee0PUIfYF/cUKb07MycJzDtH4xCLKuGb/Od
         ICdeWDl76tiw2E4yOAJd6rtcM7zUkfIOhphwBNT5a93IciCSxCAhCMgupLXdZ9YkdL/Z
         m1cg==
X-Gm-Message-State: AOAM530G9Ku5p61fc9BMbZxW/URlqObR2KfKjcBH5L1gWcycmlsTMdpd
        ZWFvwTePNA3nWn/gspUOYeDH7seYIF0=
X-Google-Smtp-Source: ABdhPJyQDOKWVtpcQPZmk6TfMepferWPF3DHSFtPBlVVbBVI9HMmTVXBkjk2rpsaC70Q6x1fNsR2OQ==
X-Received: by 2002:a17:90a:488f:: with SMTP id b15mr2710634pjh.99.1606830667604;
        Tue, 01 Dec 2020 05:51:07 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id z22sm3134111pfn.153.2020.12.01.05.51.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 05:51:06 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v4 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a UART interface
Date:   Tue,  1 Dec 2020 22:50:25 +0900
Message-Id: <1606830628-10236-2-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Since S3FWRN82 NFC Chip, The UART interface can be used.
S3FWRN82 supports I2C and UART interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 32 ++++++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index cb0b8a5..cc5f9a1 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -12,7 +12,10 @@ maintainers:
 
 properties:
   compatible:
-    const: samsung,s3fwrn5-i2c
+    items:
+      - enum:
+          - samsung,s3fwrn5-i2c
+          - samsung,s3fwrn82
 
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

