Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3594218F283
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgCWKOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:14:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37727 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgCWKOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:14:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id r24so13907034ljd.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=IAvJijwLW8Q8zsqVUdB+kE0W6IMg7X+fpSu2ixoUG7E=;
        b=Hn5nTimc/Sg+3odUs1dEYPMdwYxvaBs4k/Bo5xq1Cx2s479j/KeBGsnBSQri4mQKTC
         RMlMEW984JnLdPNSu+03R9OGvlpVZFBR/bG8/MGfvuoiDyy03VHlpCT7ky511XBT+YFz
         +FKAhQ4KmCB/muhuOpXGdhzNIqfmLKsCk6LeK2JND/Ebha0mdRcmjuM2x6ERaCNE1hZG
         K1rz3RdAgRi4RLbBX6el7lr69iUK6Y4W4cEA3We7jzVATZJF9ByJcRebKmOeb2WHiedW
         OnPGjJbh0nfU4uxh+KYsjJA4btbimmQqA8HtfuZiD7+4cCsQpRNOsF25I3vi6ZlW5cGk
         a7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=IAvJijwLW8Q8zsqVUdB+kE0W6IMg7X+fpSu2ixoUG7E=;
        b=NtQvLnfwRy6/1n0ixqCOgYBbukV4zaJU6vWtAyV8JtEP9rstL+qKFBEhIOdHuPostw
         P0ZE9VyKTri3mkxjOYTSC6LeyCN+HNCqM3meuO7m2eIe6IzR3s1qR6g7bcX1JW9lO6n8
         D+CinMXLy3p0opSs548EZqbws91OHzjQsAUS7linQYkjO+BZchmzj/PXuzxXs5UAoHoP
         MCWzTQXh1qaJp8Ige6LeIZXI07xqmY4wFPiZ3Rc3F/grLY5NEFQRHRFE8FLYXloXm5a7
         c+lc9VmQNnyLxhh+B3XbB+44rr9eCVRtNHrc9DctBMB3VbQGZieE/UhYd/hBZ3IXQ+EZ
         MpDw==
X-Gm-Message-State: ANhLgQ3ZzjRpFyBB5ys5EqucoeX4X7bhqblkByMhOeyKhOoPsT2O83Ln
        RMwNyYpjR2Qv8mK3AWXa0l0AUTLqMScjhw==
X-Google-Smtp-Source: ADFU+vumi0Q6B9ROyV2rWGNsIgRLK0sMCuu4oAgV1mU/xdbLbfbYN090eQnb5aKEQ7kYY8oDWxUMGg==
X-Received: by 2002:a2e:9d98:: with SMTP id c24mr2988221ljj.137.1584958470986;
        Mon, 23 Mar 2020 03:14:30 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 28sm367434lfp.8.2020.03.23.03.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:14:30 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: [PATCH net-next v4 1/2] dt-bindings: net: add marvell usb to mdio bindings
Date:   Mon, 23 Mar 2020 11:14:13 +0100
Message-Id: <20200323101414.11505-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323101414.11505-1-tobias@waldekranz.com>
References: <20200323101414.11505-1-tobias@waldekranz.com>
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe how the USB to MDIO controller can optionally use device tree
bindings to reference attached devices such as switches.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

