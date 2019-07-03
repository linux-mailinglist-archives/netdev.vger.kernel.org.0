Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0A45ECD6
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGCThc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:37:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33692 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfGCThb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so1781709plo.0
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DQZ58FD/CMop10T7Gp1bzD+eWeahigYqOQwY2UyguU8=;
        b=SBPe3IE51/7ccubMHDlsTs11O7jUmvYCXQFNbE9FVfb49LtIoeT+lamCuOhFuBs2Oh
         Hpm6bDBdEmGVl3OXVsxoe/nrh9Lg/2IZATTZFWB2+lWtQrFbjycVF/q+j2XPnd8cdTyq
         Hj0UzTsvFWGfGVOi9VpYwZh2sTZ1//TQrbatw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DQZ58FD/CMop10T7Gp1bzD+eWeahigYqOQwY2UyguU8=;
        b=LjFBxBuI+v6FIQ67Rmxvk+TRv5m0dhpMfcDpdUQtzXtPSDRxo5ASngEI75h9QO5HIx
         Qr/n00BR8G3BMD6bmqXkQEIdQv4Oqu8N21n/pbHq4ik7UPg1xyM6asYZC7mXfnPS2WA4
         TyWLPZUktVqDKqY1pmEkb0w61FOuwMUEWl+Ylo/6o2ZOPWa1VDhywX5ruDJwATS1Woat
         2LiHtRDJcasBRJK8S3J8RhlJNO6tmNgqtFcsYDer0oVtTBaL5J98+DkzMBTyU4hAgqJc
         SnptzFhTvoNHo1nW48+KnEfr3Keb9iJUs1TSCuKO7MTthZfOfwebETpy2UAp8Zs/8eG5
         sx+g==
X-Gm-Message-State: APjAAAWD03CUsG1io1DaWFGgrIfaZblChcmt/FrluAYU7jHNiREnt3ie
        0dkAclRwwbXsQa70+A7Ma+FFVw==
X-Google-Smtp-Source: APXvYqwettcIVbccD5RzpnI6VqVTrml29NMabd0/WlB/vXOclHQ2+VMYlYdocXXEbA3GVQufuQckyw==
X-Received: by 2002:a17:902:e40f:: with SMTP id ci15mr44437556plb.103.1562182651183;
        Wed, 03 Jul 2019 12:37:31 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id q5sm3145126pgj.49.2019.07.03.12.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:30 -0700 (PDT)
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
Subject: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Date:   Wed,  3 Jul 2019 12:37:18 -0700
Message-Id: <20190703193724.246854-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
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
Changes in v2:
- document 'realtek,eee-led-mode-disable' instead of
  'realtek,enable-ssc' in the initial version
---
 .../devicetree/bindings/net/realtek.txt       | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek.txt

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
new file mode 100644
index 000000000000..63f7002fa704
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -0,0 +1,19 @@
+Realtek PHY properties.
+
+This document describes properties of Realtek PHYs.
+
+Optional properties:
+- realtek,eee-led-mode-disable: Disable EEE LED mode on this port.
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
+		realtek,eee-led-mode-disable;
+	};
+};
-- 
2.22.0.410.gd8fdbe21b5-goog

