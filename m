Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B154D5ECDE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfGCThm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:37:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42560 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfGCThj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so1755802pff.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uXvptO9miNVQX6P/GNSlZbxo0zu4mNrAE7cY3AYPeMM=;
        b=ctbLRFOSui1ATCTtWhlWFgR+/btEJy5hHBmol2KcteKybq8QttVKOBp4YGRScU6kYH
         4tjsDBBO4rCljL/Fkicauoj9lvRMqhhsj6F6408m/2g9Dh/cUgmjcvde4Oq4OcmvwGYI
         KPguyIjin7hycnJnmQp61Cf5hh+wu5YOXqd5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uXvptO9miNVQX6P/GNSlZbxo0zu4mNrAE7cY3AYPeMM=;
        b=QSNmeri2zghS7mact8V6jg/e52MThoDBImXB1jIvCmEdBoBPz2BR/Q4N5lCDCfDvZe
         PGK6Im+QAznDKpL77E4wPGMTcXyrb5rI0RpSOtFHu13EtzcS74vAy6yv3Kh8tcCfETWF
         wXkO06BFw5kwJx+xzLY6GvbiH+/OggE5InVShdS5oqq6Xp0ft58armkgV181aKHD9k+t
         LaeVWstLE/WAJLr8a+KRNJcBrQd6nDetUajYLU4+X2qrYfE9SYc5W6Daq6TsXIVQ05A6
         dfwRZywwsdmlpD4ubL3oVGqWWa2EA2fipUdvK/f/ItHAF0nu9eqHiRwCVLCIU3t3/zo5
         wBQA==
X-Gm-Message-State: APjAAAXl4OlmTIkQRLajdklJx09UtDxmx2Ag/EBe/H68iCRIpUPC3Kd3
        //RRu/4Gz/CxiJ40RrVay6f1seqcJCk=
X-Google-Smtp-Source: APXvYqxAfTzUlNZ5dBxRhN6Mi+9N2fpYHC7cRd7UQ+83UEFHLvWH79iKLt1EuGdZqUSWCCB9OoV76A==
X-Received: by 2002:a63:8c0f:: with SMTP id m15mr38629125pgd.441.1562182658360;
        Wed, 03 Jul 2019 12:37:38 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id r1sm3539210pfq.100.2019.07.03.12.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:38 -0700 (PDT)
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
Subject: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to configure LED mode
Date:   Wed,  3 Jul 2019 12:37:23 -0700
Message-Id: <20190703193724.246854-6-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LED behavior of some Realtek PHYs is configurable. Add the
property 'realtek,led-modes' to specify the configuration of the
LEDs.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- patch added to the series
---
 .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
 include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 include/dt-bindings/net/realtek.h

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
index 71d386c78269..40b0d6f9ee21 100644
--- a/Documentation/devicetree/bindings/net/realtek.txt
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -9,6 +9,12 @@ Optional properties:
 
 	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
 
+- realtek,led-modes: LED mode configuration.
+
+	A 0..3 element vector, with each element configuring the operating
+	mode of an LED. Omitted LEDs are turned off. Allowed values are
+	defined in "include/dt-bindings/net/realtek.h".
+
 Example:
 
 mdio0 {
@@ -20,5 +26,8 @@ mdio0 {
 		reg = <1>;
 		realtek,eee-led-mode-disable;
 		realtek,enable-ssc;
+		realtek,led-modes = <RTL8211E_LINK_ACTIVITY
+				     RTL8211E_LINK_100
+				     RTL8211E_LINK_1000>;
 	};
 };
diff --git a/include/dt-bindings/net/realtek.h b/include/dt-bindings/net/realtek.h
new file mode 100644
index 000000000000..8d64f58d58f8
--- /dev/null
+++ b/include/dt-bindings/net/realtek.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _DT_BINDINGS_REALTEK_H
+#define _DT_BINDINGS_REALTEK_H
+
+/* LED modes for RTL8211E PHY */
+
+#define RTL8211E_LINK_10		1
+#define RTL8211E_LINK_100		2
+#define RTL8211E_LINK_1000		4
+#define RTL8211E_LINK_10_100		3
+#define RTL8211E_LINK_10_1000		5
+#define RTL8211E_LINK_100_1000		6
+#define RTL8211E_LINK_10_100_1000	7
+
+#define RTL8211E_LINK_ACTIVITY		(1 << 16)
+
+#endif
-- 
2.22.0.410.gd8fdbe21b5-goog

