Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997F42BD1C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 04:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfE1CGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 22:06:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37540 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbfE1CGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 22:06:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id a23so10466109pff.4;
        Mon, 27 May 2019 19:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qxW1II/TWa1kHc6PXECSj8J6z+9c391dAdBReksgqeU=;
        b=JH/nrTU/wyfYzKCgVuNaFHqM3IGPWwG7PQJHf/Sw13nsJmsJe5pOZDmfStYntS+RXq
         Hdhx1SOWgNUxK552+6tlgx+FXzHTYLNDrYVtA/h1DiDhAYkaDoldmafOf6B1rdq39AxD
         KXbh+s+Pd7K4uem1LxurZg/KSP9pPTVMAJWjXSss4etWsm2ubatXrmDcXIWndaxZqGFu
         fBB9PO5SF2hsPLZIQJSzqcDTd5FX21jaxO9B8ZXDFj10yAW7/TZWFqfqGe7cqNW27sa3
         pv/BLW2VoeU96EpwxpVJdZE3fe6gRmz1hUfjn2O3pb7Mc+jX/HJbtjx11cSFtDZy0yth
         o4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qxW1II/TWa1kHc6PXECSj8J6z+9c391dAdBReksgqeU=;
        b=Y5bVNtUc1JZaAHgdlo2ZPAelzFHNCoVjDdJVywBduSvq7Lkc4RpVBsVtPSTZPe8aGQ
         hmRJkjBn3cihynNl3GHsAEDFk/MNNNfZa9/4cUK76kivPLZYUq3bHA91Mm81xNl4vjYp
         HsKgX1jbDfe1eBGJ2FgIsQGKgdEgYbqCnbcLExI0qOlXw5snDXO0XgSYR6dqcqmzGnhI
         jQ9dGBhDPJ7HeJIJJc0HDtYS9d7J7zkWmd1aIpa9WcNQFOkHU5Gf7XaYaq2h/V27AfI5
         TQqeXZqTIr74L19KxluMsxfwCxtJFzf0HUv8DIPGyMydGW/Hf2ThqK0n+PIe5MIDaNO7
         IF/A==
X-Gm-Message-State: APjAAAWJvRuQyXcw0rlblP+gfhVy1KeGM+4FOG96cyzOzKZ7DSn8ODqi
        BykG58ZmlCKmE93RVB6xuINBU4My
X-Google-Smtp-Source: APXvYqxAYs7s/9irQiNKqkW/hl4q1JbHGJ/MTYwkmLSgNGAZ4Fu6OweBiY6zzqXQrSwoaI2LpyZalA==
X-Received: by 2002:a62:e310:: with SMTP id g16mr45003473pfh.36.1559009208001;
        Mon, 27 May 2019 19:06:48 -0700 (PDT)
Received: from localhost.localdomain (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id t2sm12725808pfh.166.2019.05.27.19.06.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 19:06:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ioana.ciornei@nxp.com, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] Documentation: net-sysfs: Remove duplicate PHY device documentation
Date:   Mon, 27 May 2019 19:06:38 -0700
Message-Id: <20190528020643.646-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both sysfs-bus-mdio and sysfs-class-net-phydev contain the same
duplication information. There is not currently any MDIO bus specific
attribute, but there are PHY device (struct phy_device) specific
attributes. Use the more precise description from sysfs-bus-mdio and
carry that over to sysfs-class-net-phydev.

Fixes: 86f22d04dfb5 ("net: sysfs: Document PHY device sysfs attributes")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-mdio      | 29 -------------------
 .../ABI/testing/sysfs-class-net-phydev        | 19 ++++++++----
 2 files changed, 13 insertions(+), 35 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-bus-mdio

diff --git a/Documentation/ABI/testing/sysfs-bus-mdio b/Documentation/ABI/testing/sysfs-bus-mdio
deleted file mode 100644
index 491baaf4285f..000000000000
--- a/Documentation/ABI/testing/sysfs-bus-mdio
+++ /dev/null
@@ -1,29 +0,0 @@
-What:		/sys/bus/mdio_bus/devices/.../phy_id
-Date:		November 2012
-KernelVersion:	3.8
-Contact:	netdev@vger.kernel.org
-Description:
-		This attribute contains the 32-bit PHY Identifier as reported
-		by the device during bus enumeration, encoded in hexadecimal.
-		This ID is used to match the device with the appropriate
-		driver.
-
-What:		/sys/bus/mdio_bus/devices/.../phy_interface
-Date:		February 2014
-KernelVersion:	3.15
-Contact:	netdev@vger.kernel.org
-Description:
-		This attribute contains the PHY interface as configured by the
-		Ethernet driver during bus enumeration, encoded in string.
-		This interface mode is used to configure the Ethernet MAC with the
-		appropriate mode for its data lines to the PHY hardware.
-
-What:		/sys/bus/mdio_bus/devices/.../phy_has_fixups
-Date:		February 2014
-KernelVersion:	3.15
-Contact:	netdev@vger.kernel.org
-Description:
-		This attribute contains the boolean value whether a given PHY
-		device has had any "fixup" workaround running on it, encoded as
-		a boolean. This information is provided to help troubleshooting
-		PHY configurations.
diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index 6ebabfb27912..2a5723343aba 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -11,24 +11,31 @@ Date:		February 2014
 KernelVersion:	3.15
 Contact:	netdev@vger.kernel.org
 Description:
-		Boolean value indicating whether the PHY device has
-		any fixups registered against it (phy_register_fixup)
+		This attribute contains the boolean value whether a given PHY
+		device has had any "fixup" workaround running on it, encoded as
+		a boolean. This information is provided to help troubleshooting
+		PHY configurations.
 
 What:		/sys/class/mdio_bus/<bus>/<device>/phy_id
 Date:		November 2012
 KernelVersion:	3.8
 Contact:	netdev@vger.kernel.org
 Description:
-		32-bit hexadecimal value corresponding to the PHY device's OUI,
-		model and revision number.
+		This attribute contains the 32-bit PHY Identifier as reported
+		by the device during bus enumeration, encoded in hexadecimal.
+		This ID is used to match the device with the appropriate
+		driver.
 
 What:		/sys/class/mdio_bus/<bus>/<device>/phy_interface
 Date:		February 2014
 KernelVersion:	3.15
 Contact:	netdev@vger.kernel.org
 Description:
-		String value indicating the PHY interface, possible
-		values are:.
+		This attribute contains the PHY interface as configured by the
+		Ethernet driver during bus enumeration, encoded in string.
+		This interface mode is used to configure the Ethernet MAC with the
+		appropriate mode for its data lines to the PHY hardware.
+		Possible values are:
 		<empty> (not available), mii, gmii, sgmii, tbi, rev-mii,
 		rmii, rgmii, rgmii-id, rgmii-rxid, rgmii-txid, rtbi, smii
 		xgmii, moca, qsgmii, trgmii, 1000base-x, 2500base-x, rxaui,
-- 
2.17.1

