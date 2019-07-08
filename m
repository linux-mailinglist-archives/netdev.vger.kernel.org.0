Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D376298B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404188AbfGHT0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:26:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46559 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391165AbfGHTZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id i8so8152336pgm.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MaGzZisdYBBgFX/QuRcqVi/VI5GsRgwFYphjBCtTHs0=;
        b=LwQ+7zDaMDpO5piJbvIq8JbtbV72vHpBAwq3IFau8WlEoUnxJ+WP7+9VrBVGl+5uN4
         J+Ar+i53NQMiECyGyGjjJI35+J4wzNYAmWEhijO3gZurm/2WvoDHY0H8W1OIEOXs0/OI
         bI5bj6duTAH31k3iVODuW8sPlqBdnfdadfG5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MaGzZisdYBBgFX/QuRcqVi/VI5GsRgwFYphjBCtTHs0=;
        b=lTkOHM4xv1LMJwYf3Wbtv/Acxs9y7AqQCmhbvyDwJ3JE+08fFfhuMrCTCSvEVfWZpn
         kC1U5603MdvIJ8m1ZPFqLV9vKtIRqKRnWRJ6qc1gGpQqB8sBru7nDkl4SgglK9LBU8Av
         75/KhTcaCG7xcipCoRQb7f8bvQgqlepmSz9ORM+fbrdtKt5AJbk6oMmvK3QNcQolH542
         /lOer+Ja4Ynwvdg/N2Py004DchPMW/8+AfW4KxhreZI8Y61qPphbRVZg/W0ajmr1Otub
         Cj3/th5BVUF+x5bUIqCq8bPWCw/hGiL311akTUjyD5ot8dTmJL8DRe9msvPkACLN2uPe
         YL8Q==
X-Gm-Message-State: APjAAAWp4TbHLzQcU9s+0Bk1to8Ll/FMAeUGzPe0tWAtrYAoXbgjwL5S
        ZX7EX/Kg+gKlVRrIzMUUEEObNA==
X-Google-Smtp-Source: APXvYqxcCcLYcn/x8D50rn/vmkXY7YFkvL0a3L/ogSHSleiZNJEF9oD7to8kU4B1bDy6uEs49/LGuA==
X-Received: by 2002:a63:f4e:: with SMTP id 14mr26032375pgp.58.1562613911655;
        Mon, 08 Jul 2019 12:25:11 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v184sm19032424pfb.82.2019.07.08.12.25.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:11 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v3 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Date:   Mon,  8 Jul 2019 12:24:53 -0700
Message-Id: <20190708192459.187984-2-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the 'realtek,eee-led-mode-disable' property to disable EEE
LED mode on Realtek PHYs that support it.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
TODO: adapt PHY core to deal with optional compatible strings

Changes in v3:
- added entry for compatible string
- added compatible string to example
- mention that the new property is only available for RTL8211E

Changes in v2:
- document 'realtek,eee-led-mode-disable' instead of
  'realtek,enable-ssc' in the initial version
---
 .../devicetree/bindings/net/realtek.txt       | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek.txt

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
new file mode 100644
index 000000000000..db0333f23fec
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -0,0 +1,31 @@
+Realtek PHY properties.
+
+This document describes properties of Realtek PHYs.
+
+Optional properties:
+- compatible: should be one of the following:
+  "realtek,rtl8201cp", "realtek,rtl8201f", "realtek,rtl8211",
+  "realtek,rtl8211b", "realtek,rtl8211c", "realtek,rtl8211dn",
+  "realtek,rtl8211e", "realtek,rtl8211f", "rtl8366rb"
+
+  the property is required if any of the properties are specified that
+  are only supported for certain Realtek PHYs.
+
+- realtek,eee-led-mode-disable: Disable EEE LED mode on this port.
+
+  Only supported for "realtek,rtl8211e".
+
+
+Example:
+
+mdio0 {
+	compatible = "snps,dwmac-mdio";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ethphy: ethernet-phy@1 {
+		compatible = "realtek,rtl8211e";
+		reg = <1>;
+		realtek,eee-led-mode-disable;
+	};
+};
-- 
2.22.0.410.gd8fdbe21b5-goog

