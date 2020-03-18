Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31A18A0E7
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 17:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCRQxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 12:53:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35627 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgCRQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 12:53:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id m3so4201783wmi.0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:organization;
        bh=epr8PK2VzXVYapRJnDnkNy1xjUuDqi3UfJCVQq6LU7g=;
        b=B+iRO9wwqrmAk2bNTuqb0cvQEDggLQQ5k0iiNTUjH1luiIBHhQHD7IUbcn7DLYOjNt
         mjbnEHXwl9tzUNsd7P00Z2ly4Bb3iB4lgwVbU2128xXjITy/HLXhTL0CSlML7KOW6+01
         z2UvZTEue0e81UBEcBozb3LGCx99iMUflDOKDumq4ZOu1U/W6yfZkee6H+43jdlZPHEC
         LoH1k+VqQ3HNv+V8BOcMgMHvinuH0jk015ZLgluyrzUjD300KXHLCyh4FeALirh0ePvo
         xrv+qtf/o3uhyRUe+C7tYek0zSjGG5zBQPCwYkrX8Y8PpqIjpuUuwlS6i/1H4kMi1WmD
         Z1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:organization;
        bh=epr8PK2VzXVYapRJnDnkNy1xjUuDqi3UfJCVQq6LU7g=;
        b=EZdymfT+LuT4vHx5fkyY7+oX0ZtEcw/b76kWayg1Nk40WyMmE3jP6jsOE/FG+oy2dF
         rfAgXGlmSZus3mG8njh2cJ5ef7/D4y+7/ozJPf9ZLC2rjNkF2X8ON6bSl+ukkr7XMjoh
         WtC6zG0zRQhH3ZMsIb6exB20n3I8Gi9r/+LmLopTvAMXRBx+c1iNxIjmFYftO7B7yE6B
         s4mjsAYtIpbT74eRBDBEokaBnzhsR/mc+xv1jD0QmVyh7+vW2c169+A0iOuJ42OI2g6a
         ooS/4/bWn1WnBANSSZcbpm/3qav6xG7XtiFSdpKYUi4VU2ob6i6pa38rz/Jcc4Xj9ip9
         GdKA==
X-Gm-Message-State: ANhLgQ1l2puZ0Q3yvLVweWCva19oX7uJRdPVQV8z0mnzUyQdsWC9vvs3
        P3OAc2wcR3H3AIjOLu1mdWi+w7TJAxM=
X-Google-Smtp-Source: ADFU+vuOHihb8KlU2owfHc11KSziNFB8/MJyfDkpFdL6lEHjJJ1G3nq4SOghFHg7xvRLhmxAOwiRXg==
X-Received: by 2002:a1c:6608:: with SMTP id a8mr5901633wmc.113.1584550382745;
        Wed, 18 Mar 2020 09:53:02 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x15sm6613731wrs.5.2020.03.18.09.53.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:53:02 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: add marvell smi2usb bindings
Date:   Wed, 18 Mar 2020 17:52:31 +0100
Message-Id: <20200318165232.29680-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe how the smi2usb controller can optionally use device tree
bindings to reference attached devices such as switches.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 .../bindings/net/marvell,smi2usb.yaml         | 65 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,smi2usb.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,smi2usb.yaml b/Documentation/devicetree/bindings/net/marvell,smi2usb.yaml
new file mode 100644
index 000000000000..498a19bf7326
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,smi2usb.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,smi2usb.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell SMI2USB MDIO Controller
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
+            smi2usb: mdio@1 {
+                    compatible = "usb1286,1fa4";
+                    reg = <1>;
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+            };
+    };
+
+    /* MV88E6390X devboard */
+    &smi2usb {
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
index 5dbee41045bc..83bb7ce3e23e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10096,6 +10096,12 @@ S:	Maintained
 F:	drivers/mtd/nand/raw/marvell_nand.c
 F:	Documentation/devicetree/bindings/mtd/marvell-nand.txt
 
+MARVELL SMI2USB MDIO CONTROLLER DRIVER
+M:	Tobias Waldekranz <tobias@waldekranz.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/marvell,smi2usb.yaml
+
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-- 
2.17.1

