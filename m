Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D400F42791F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244661AbhJIKvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 06:51:00 -0400
Received: from ixit.cz ([94.230.151.217]:41692 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244412AbhJIKut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 06:50:49 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 6679020064;
        Sat,  9 Oct 2021 12:48:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1633776531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EoizMIfnXpLkqcgJXPhKkISzgcvhmyOaWVCO/uKrTro=;
        b=XWaLZILJw9RKOqVfrSXmFR8DvQpGIWVZZlyY4msV2tLdkVTc+lFvD08jqqcUcj7ndHSexu
        f0xMlWxBmT8XMDy5I4BxTTyLv7mCuR2DH6nxko8XR5h6tEH446DG1LBsmPvzI5Ns/rjpYk
        dx+J0nN2d1/eey9lfTEhHFKKzyzKsg4=
From:   David Heidelberg <david@ixit.cz>
To:     Rob Herring <robh+dt@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht,
        David Heidelberg <david@ixit.cz>
Subject: [PATCH] dt-bindings: net: marvell-bluetooth: Convert txt bindings to yaml
Date:   Sat,  9 Oct 2021 12:47:16 +0200
Message-Id: <20211009104716.46162-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert documentation for The Marvell Avastar 88W8897 into YAML syntax.

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 .../bindings/net/marvell-bluetooth.txt        | 25 ---------------
 .../bindings/net/marvell-bluetooth.yaml       | 31 +++++++++++++++++++
 2 files changed, 31 insertions(+), 25 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.txt b/Documentation/devicetree/bindings/net/marvell-bluetooth.txt
deleted file mode 100644
index 0e2842296032..000000000000
--- a/Documentation/devicetree/bindings/net/marvell-bluetooth.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-Marvell Bluetooth Chips
------------------------
-
-This documents the binding structure and common properties for serial
-attached Marvell Bluetooth devices. The following chips are included in
-this binding:
-
-* Marvell 88W8897 Bluetooth devices
-
-Required properties:
- - compatible: should be:
-    "mrvl,88w8897"
-
-Optional properties:
-None so far
-
-Example:
-
-&serial0 {
-	compatible = "ns16550a";
-	...
-	bluetooth {
-		compatible = "mrvl,88w8897";
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
new file mode 100644
index 000000000000..08813e3ecff6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/marvell-bluetooth.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Marvell Bluetooth chips
+
+description: |
+  This documents the binding structure and common properties for serial
+  attached Marvell Bluetooth devices.
+
+maintainers:
+  - Rob Herring <robh+dt@kernel.org>
+
+properties:
+  compatible:
+    const: mrvl,88w8897
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    serial {
+      bluetooth {
+        compatible = "mrvl,88w8897";
+      };
+    };
-- 
2.33.0

