Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2C62963
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbfGHTZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45577 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403817AbfGHTZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so8045903pfq.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XWbP/dCS1tGcjo88wg6gDGGHLplE0DvcXvP3Oeiy9UU=;
        b=Swc5kxgl5rIe9OaAt1N63AxfODEw3kumM3N8MfT45AsUykZcx27fjKTzNBUG/UiLq9
         C7cZNxvR8HdtbUbPAIxPiFZsVOlFA4KpZF1Rc2hua3Pg4jqsafBYtCO/b13DdOEhzjMn
         zbFl+OUTwbyNtzVkXFsZO6t0w1KS0rr3xvFSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XWbP/dCS1tGcjo88wg6gDGGHLplE0DvcXvP3Oeiy9UU=;
        b=IxFCMRVfpfhzheTFUInzWNk0Qh8oc/ouvmIaCgsWyheNfj+ojVX0JL8Na2vjsDdXs0
         EOneb4EPTz/7mAbq/D+R/W4vCAtGvfCepHcbB4MqXzbNWr5gLyoX0OOFBtJYPA+7UMfQ
         WUpAxjyYYZdQu/jz9Edq6gHV3mo/qeNrw1iyrqpfeh7F3iTnBSUb4UTiK1HLA3amtRse
         chhOAyu9BBgysyzXi1F0aySOFSbvWQK2NiES9rNT5uiRIH0xvRJNTm8mJHh9S5/aCviU
         sYtF8B8Nih2AaIadFyXIaGF9+wCcz/sVG6DWgiy7tGtN7l2fpK9ha+UTq8C7Yyc3iZzR
         xB9Q==
X-Gm-Message-State: APjAAAXI/DDTBlR/7QG1lBBL7oo4U/oalKqMutpe1OQ/3VMDs+9rmey7
        ByeMlaGCvpuIvz4jxtLuTDM93A==
X-Google-Smtp-Source: APXvYqxj8gwX0MrPf9c4HdvT72aVScvAKz1wrH5AksRYEurt1SzUJRc1/Q7Jf6KoqCILHaraNuL+Fw==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr28281541pja.104.1562613918931;
        Mon, 08 Jul 2019 12:25:18 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e13sm14330483pff.45.2019.07.08.12.25.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:18 -0700 (PDT)
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
Subject: [PATCH v3 6/7] dt-bindings: net: realtek: Add property to configure LED mode
Date:   Mon,  8 Jul 2019 12:24:58 -0700
Message-Id: <20190708192459.187984-7-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
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
Changes in v3:
- added RTL8211E_LED_OFF to LED modes
- changed wording for supported PHY models

Changes in v2:
- patch added to the series
---
 .../devicetree/bindings/net/realtek.txt        | 11 +++++++++++
 include/dt-bindings/net/realtek.h              | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 include/dt-bindings/net/realtek.h

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
index af2824664f08..ab218f2b7653 100644
--- a/Documentation/devicetree/bindings/net/realtek.txt
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -19,6 +19,14 @@ Optional properties:
 
   Only supported for "realtek,rtl8211e".
 
+- realtek,led-modes: LED mode configuration.
+
+  A 0..3 element vector, with each element configuring the operating
+  mode of an LED. Omitted LEDs are turned off. Allowed values are
+  defined in "include/dt-bindings/net/realtek.h".
+
+  Only supported for "realtek,rtl8211e".
+
 
 Example:
 
@@ -32,5 +40,8 @@ mdio0 {
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
index 000000000000..023cb776a7a3
--- /dev/null
+++ b/include/dt-bindings/net/realtek.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _DT_BINDINGS_REALTEK_H
+#define _DT_BINDINGS_REALTEK_H
+
+/* LED modes for RTL8211E PHY */
+
+#define RTL8211E_LED_OFF		0
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

