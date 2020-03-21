Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2976418E435
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCUUZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 16:25:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42028 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgCUUZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 16:25:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id t21so7179296lfe.9
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 13:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=RrRlxSA5JH5KL9KpSVlg+eWTNkhtjgbo6CYW0I8MPLM=;
        b=VPEIPYKyIrc18kA0NUiuROjW7ab5PDRYQNVUvTthWv6+m6kvLOtsIypOj3nnNDu3EU
         5KuDWm5eif/OJED7qv+SjGDUqCKcHZXorQ2XpUMySgMPnYPbeY4nWXmD/k+bhuBEQ66O
         RnkHGXjd1Sgi3PQ5eo9UpO9NHuG+p5myez6wlDwDfvYb++uudYtFQUeDaU24g9v9NM6m
         yWK4hxJqGMndVKoFN62Yayv6gutOgXjq2vLyinWIoAcNQYD9jIlm7sH495Tz8fB8yA18
         GvXoUewzenCqNRfzpB/4SOqU6o8f7Rr/aqHPjqseSuR2/8abRgxzEMy1+9sm8OVk7eN8
         4iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=RrRlxSA5JH5KL9KpSVlg+eWTNkhtjgbo6CYW0I8MPLM=;
        b=NBbCaqQKCvAxuYIjJELDQDgGa3lX3EkneQPiXLu8Zz+yUWCHE5WU1EwwKemJlrizMU
         P+VueLpzUsPsBBndnX2x+o/Ci9RZ0KpEUtN3w4JpNWpGB24tM+7VMJB0QckaZ0P70Xq8
         07sgcFTUbZGqRg8qjCBbxs7Yrd11dpdDUD/2THLa++XbSu6kjs6eg0CdAy9P9/5t9Skc
         AVYMUoBHMkyoA3j0oX9QpNDGUuLOocyK6p+j0Ek35h31Md21dzrM5oQXTzupRqnz9eJT
         fj+xAnZsdVdIH/GhVX6/KzZsx428yZtWE6jZjXvDqsiszLeEiG36UGWuMP1S4qpDvSQU
         mJtg==
X-Gm-Message-State: ANhLgQ1wbclO+pcTiGzwiBD4vhFbJJCR0ilrXSA1rzNVmOMNeocnYwcr
        DhFTsXziLVF11Sos9Qv2OW09DQ==
X-Google-Smtp-Source: ADFU+vuSw1c/gt1iuSiXjvfqYV9ZyyFKHJfdbmQCzdE4OkD/qC7mUs6o3Fcxhe46zVbN+wJoPFZiQA==
X-Received: by 2002:ac2:5de1:: with SMTP id z1mr8631238lfq.95.1584822304413;
        Sat, 21 Mar 2020 13:25:04 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p25sm5847334ljg.85.2020.03.21.13.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 13:25:03 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-usb@vger.kernel.org
Subject: [PATCH v3 1/2] dt-bindings: net: add marvell usb to mdio bindings
Date:   Sat, 21 Mar 2020 21:24:42 +0100
Message-Id: <20200321202443.15352-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe how the USB to MDIO controller can optionally use device tree
bindings to reference attached devices such as switches.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 .../bindings/net/marvell,mvusb.yaml           | 65 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,mvusb.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
new file mode 100644
index 000000000000..9458f6659be1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,mvusb.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell USB to MDIO Controller
+
+maintainers:
+  - Tobias Waldekranz <tobias@waldekranz.com>
+
+description: |+
+  This controller is mounted on development boards for Marvell's Link Street
+  family of Ethernet switches. It allows you to configure the switch's registers
+  using the standard MDIO interface.
+
+  Since the device is connected over USB, there is no strict requirement of
+  having a device tree representation of the device. But in order to use it with
+  the mv88e6xxx driver, you need a device tree node in which to place the switch
+  definition.
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: usb1286,1fa4
+  reg:
+    maxItems: 1
+    description: The USB port number on the host controller
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    /* USB host controller */
+    &usb1 {
+            mvusb: mdio@1 {
+                    compatible = "usb1286,1fa4";
+                    reg = <1>;
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+            };
+    };
+
+    /* MV88E6390X devboard */
+    &mvusb {
+            switch@0 {
+                    compatible = "marvell,mv88e6190";
+                    status = "ok";
+                    reg = <0x0>;
+
+                    ports {
+                            /* Port definitions */
+                    };
+
+                    mdio {
+                            /* PHY definitions */
+                    };
+            };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 97dce264bc7c..ff35669f8712 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10101,6 +10101,12 @@ M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
 F:	drivers/mmc/host/mvsdio.*
 
+MARVELL USB MDIO CONTROLLER DRIVER
+M:	Tobias Waldekranz <tobias@waldekranz.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/marvell,mvusb.yaml
+
 MARVELL XENON MMC/SD/SDIO HOST CONTROLLER DRIVER
 M:	Hu Ziji <huziji@marvell.com>
 L:	linux-mmc@vger.kernel.org
-- 
2.17.1

