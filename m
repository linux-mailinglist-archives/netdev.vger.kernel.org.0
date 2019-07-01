Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC265C3DE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGATwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:52:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39188 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGATwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:52:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so6508506pgc.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4Hod/x1MVNHO5bSEWzPdLsP26qI40u5ky94UaZs3Ok=;
        b=RG1N9qyoJc8Gm1mGDNB+WCBLXDNI+CswCxWxzW1nPlRqvvtqh6yqfRwMyDL1wIbxUW
         shUYjVAbOiNaLQqgic7RgUERn5Xd5mKsMxX+lsCCYm1/BDq5b1nJYhaZP37eyh0NxrCM
         SHkjoSPJM/HW4DBdT9aEbAFBc5TbMpKPJzkoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4Hod/x1MVNHO5bSEWzPdLsP26qI40u5ky94UaZs3Ok=;
        b=cJH36XyhAh9htsEu9Q/E2ReRmMiWI5wpmFR+0RnWjLTHdoJIUBwIfbO9Y5tjksFz7F
         py4HIUuND402GMtVhPjpBrD5h/GecUR0+fEVne3PxPE1im7T+ImL0YZznwCmF/lG0vN/
         4vO3P4jM7kQGVSfmd9lnBBVXxvHiAGT31kony1tkwPUSvZ499KIPdiMz1twxY2wq8SGV
         qGFG9UUHwJ53xo5Imb0APmKZFbkmsg/GWxfZDaBzQaAQNO5ahTi2uDcN5baj/nYZ8fmY
         qrHkpG5o8ZjXI0JU/SQpoSVFvY8P469AOPbguRqzb6QhPzamwAXq6DyzOT1RMEP/Aerg
         8dPQ==
X-Gm-Message-State: APjAAAX68RB1N/Bf5OVZ1lD92KUUumt2SgSC4RglkgdnEcZQkJ+TMA6p
        w85GsJglWtq9QKFOawbJf+q38w==
X-Google-Smtp-Source: APXvYqwQMv6Ji9rV5QoYqMLRG2WCQNLYyCsww96zbtRJtLi1AdVa1f2X6XL5FCL9ah8axoRlfhKodA==
X-Received: by 2002:a63:d0:: with SMTP id 199mr26577010pga.85.1562010750726;
        Mon, 01 Jul 2019 12:52:30 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v23sm11428812pff.185.2019.07.01.12.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:52:30 -0700 (PDT)
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
Subject: [PATCH 1/3] dt-bindings: net: Add bindings for Realtek PHYs
Date:   Mon,  1 Jul 2019 12:52:23 -0700
Message-Id: <20190701195225.120808-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the 'realtek,enable-ssc' property to enable Spread Spectrum
Clocking (SSC) on Realtek PHYs that support it.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 .../devicetree/bindings/net/realtek.txt       | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek.txt

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
new file mode 100644
index 000000000000..9fad97e7404f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -0,0 +1,21 @@
+Realtek PHY properties.
+
+This document describes properties of Realtek PHYs.
+
+Optional properties:
+- realtek,enable-ssc	Enable Spread Spectrum Clocking (SSC) on this port.
+			SSC is only available on some Realtek PHYs (e.g.
+			RTL8211E).
+
+Example:
+
+mdio0 {
+	compatible = "snps,dwmac-mdio";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ethphy: ethernet-phy@1 {
+		reg = <1>;
+		realtek,enable-ssc;
+	};
+};
-- 
2.22.0.410.gd8fdbe21b5-goog

