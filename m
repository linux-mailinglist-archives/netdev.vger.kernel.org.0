Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFA2E22B7
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgLWXbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLWXbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:31:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04207C06179C;
        Wed, 23 Dec 2020 15:30:40 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a12so683350wrv.8;
        Wed, 23 Dec 2020 15:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hQPHIvsAjymwrj88eayvDfWVEI3FeVG9migi2sLEfas=;
        b=rd7j9CDFeZd22ADwPLkZVVMl3AS7J/1IrJGa6JJ1zOW2YUp/XJZEQo1iCxPfE5L+sn
         +uakY57HlN/ymRkT/2xWJvEmW7e3T2Aah+R3TEcVastQzJM9f4yUbOlrNDWF6u/t4z0Z
         60ke+dD6pN22DJ+mfaYKd8wZy+h1VAJTW2xoTQ2hftyMHWj/dga3nxt48KDBBx+aZ5TX
         m+qX4cLSjshjPR4ZTuqFbmxWgFYzNXGVTXfUtFXNiu8SrZj/RVZO9GqAFSUa2nwMgBCh
         PpMCEO4pp28IURbB0ZvygGm+3S/DpGWAg2ct6SSjgQWjiQGc8EpfgAA3bhpzBpOSKJEB
         0q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hQPHIvsAjymwrj88eayvDfWVEI3FeVG9migi2sLEfas=;
        b=S+h5viEE8Jc8fjTmYaD+OBbqaWj5fwCLdAZI6QVrSOqAH5KT7zKxt8s7EKxQ0HCnbb
         jnlU80Ejtgtf6M1YWFgs4+KG/sM8NppzUWeSqxPWcaIo0UlCGY+vG95NVVswUVOKqqdy
         9qTN1luNHVuU0M8Au4CICjgK+NEN2bA1/28B3ORO5LTVQfMr9L2lxLHr3YBB7xQOu+/M
         nn8TE4H2+ZfiAU2YYOPlFTCzS5546TqEJ9ssDkjXWMadmBay5zEYGXIMgvdC0mSWo2sB
         /dob942L1sWwaPFU2bLxuShffx4/Wnu2uMKgjRpwSQrm3Iz0WnQ+S6TdfOCCugzI+58h
         ZoVQ==
X-Gm-Message-State: AOAM530P45ja2ednXroylIErwYWM60v2ZyKj/H3rVcHyzjrGszT2l6yM
        ArdbWKdJzlvBiHvGpGbxWIo=
X-Google-Smtp-Source: ABdhPJzAZbpyPuBWW2KBcu9dJa/qHhI0eE1CLPKrGsAQYhn1R/e7UieMPCs4eQ6SiOV0e6Noluus/Q==
X-Received: by 2002:adf:eec6:: with SMTP id a6mr31354990wrp.239.1608766238726;
        Wed, 23 Dec 2020 15:30:38 -0800 (PST)
Received: from localhost.localdomain (p200300f1371a0900428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371a:900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l16sm37926657wrx.5.2020.12.23.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 15:30:38 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/5] dt-bindings: net: dwmac-meson: use picoseconds for the RGMII RX delay
Date:   Thu, 24 Dec 2020 00:29:01 +0100
Message-Id: <20201223232905.2958651-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Deprecate the old
"amlogic,rx-delay-ns" in favour of the generic "rx-internal-delay-ps"
property.

For older SoCs the only known supported values were 0ns and 2ns. The new
SoCs have support for RGMII RX delays between 0ps and 3000ps in 200ps
steps.

Don't carry over the description for the "rx-internal-delay-ps" property
and inherit that from ethernet-controller.yaml instead.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml     | 55 +++++++++++++++++--
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 6b057b117aa0..a406e38e1848 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -74,17 +74,60 @@ allOf:
             Any configuration is ignored when the phy-mode is set to "rmii".
 
         amlogic,rx-delay-ns:
+          deprecated: true
           enum:
             - 0
             - 2
           default: 0
           description:
-            The internal RGMII RX clock delay (provided by this IP block) in
-            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
-            should be explicitly configured. When the phy-mode is set to
-            either "rgmii-id" or "rgmii-rxid" the RX clock delay is already
-            provided by the PHY. Any configuration is ignored when the
-            phy-mode is set to "rmii".
+            The internal RGMII RX clock delay in nanoseconds. Deprecated, use
+            rx-internal-delay-ps instead.
+
+        rx-internal-delay-ps:
+          default: 0
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - amlogic,meson8b-dwmac
+              - amlogic,meson8m2-dwmac
+              - amlogic,meson-gxbb-dwmac
+              - amlogic,meson-axg-dwmac
+    then:
+      properties:
+        rx-internal-delay-ps:
+          enum:
+            - 0
+            - 2000
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - amlogic,meson-g12a-dwmac
+    then:
+      properties:
+        rx-internal-delay-ps:
+          enum:
+            - 0
+            - 200
+            - 400
+            - 600
+            - 800
+            - 1000
+            - 1200
+            - 1400
+            - 1600
+            - 1800
+            - 2000
+            - 2200
+            - 2400
+            - 2600
+            - 2800
+            - 3000
 
 properties:
   compatible:
-- 
2.29.2

