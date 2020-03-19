Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72D318B87A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCSOBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:01:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40814 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgCSOBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:01:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id f3so3126463wrw.7
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=epr8PK2VzXVYapRJnDnkNy1xjUuDqi3UfJCVQq6LU7g=;
        b=2MnHN7Fz/GWwuwgoGGPog07yYwmBxnFF6fmLd10nxHvtaRjUyAuF6a78nuqXvcaAwJ
         uWTYtDB0H/GFWh0efT+fd3exw/xSkGIGqZSTkwA9G6dHJ7KGg9xFwwCPaURkd5IO+Oa5
         J5uhEkVXhMzicNHls3fmazrbIwiPJMrZdG1afDjYs0RJf5UA30io5qoS59gnnBAOO9Xx
         YlQINJfm/wDp3ZRPwdhJqA5HKduzjISY65QAMgUgZlAr+CZDnkU8ZDtkeLufUF7mjb01
         GD88kTn6/EVBfNCp1Sq6DC6RW59vXRFMqInIz4+blVvVGv+kNqlCyxyyGgPAFkAyDExU
         dG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=epr8PK2VzXVYapRJnDnkNy1xjUuDqi3UfJCVQq6LU7g=;
        b=cPXumlvg86jWp/R10n7n1m00D6ENCyLySlzhrlcxThl8uufR/d7uruV4OaFFvQgq3I
         XSfBBpcuuAbUQ43w58jv9c0S6pd8ryPC86xc7axncErsuYndudOFxnqg2cgeePgPKoqF
         MhPrS624vJpnqHBhn5ASwQXrsWvwHpaTJRy7rgRCWhXB9vxUGffRqlS8vXFZSTRQ95FL
         7YE+NrSIPAx3gciFQD4N020qHOi+kmb7mcoXxJUr5u4GG4rw+wWF1Gxpx1ytK0hzPVAd
         dwFGwvwkxxpzTg+q3na5GexO9x4Ly1rUe2CSbgmr9cBaSISz8KkTNmq4dECUOlTAnPoI
         XVGg==
X-Gm-Message-State: ANhLgQ2XzpMr/HyMCfBLqGUgaCJanVIuKJj8/Lth52+Et4IphYpwYn4I
        jjh5fBV+OmoYJlVTOPCqlKpNlVNd4p5zBg==
X-Google-Smtp-Source: ADFU+vty5nyKYLm7iLu/li/9mjplUtMiHi0kcNOXDvvOMWqkWm2MU6WLXSxRvwLkLvRcVpZHYVS3Fg==
X-Received: by 2002:a5d:6245:: with SMTP id m5mr4526129wrv.154.1584626469813;
        Thu, 19 Mar 2020 07:01:09 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p10sm3747251wrx.81.2020.03.19.07.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:01:09 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: [PATCH v2 1/2] dt-bindings: net: add marvell smi2usb bindings
Date:   Thu, 19 Mar 2020 14:59:51 +0100
Message-Id: <20200319135952.16258-1-tobias@waldekranz.com>
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

