Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FDF5ECD7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfGCThh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:37:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46220 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfGCThe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so197095plz.13
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LhyRUTRIu1qpsqXn5o9IxSwcYlELpmg3DK5gV7vvo4k=;
        b=AXXxF24y4ZnmX35FkssBaHobBhB2G/2sniSMqPwRUcbbronGlChj6KUb34z6/0EDwg
         ry7q8B8r1kmpgoaejPsEEX3aeGji3B9DPbED4WmbyKbretJxCm4I4XskKNuWq2iXNb29
         A76Ep9fNh4Jp+0mlNKSmS/s2GpGqQ+2xjjzT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhyRUTRIu1qpsqXn5o9IxSwcYlELpmg3DK5gV7vvo4k=;
        b=Z0/NQW6WwNHGEzT9PhJPmUr3dgbFCSG2C5rxXZkNyOQmZnDiivej1OGM/T6ql1FT8C
         g6qOY3Bxyy8GGo1RicqkOmyiY7i6PrZXtnpLf8Z/tUaUHejTIwscjxQAgWnjROxw0I79
         O4S+8Z52oWiv0C6TWehedT5bBuJQPpwQiGOhAeerxNYsaU7uZ2w8wb0qH9xICP+W1GBm
         cM1vVJWwcnykO1VQA3Rt5TzO4+7YiHQlbcwZcR3Ka23yqp4IWICYQ8Br+GIepdrNyan5
         nOTiNq7s1y1HnPG/XX1jj7JotDKTx7FPGNt5e5ZTKsHqoCGOyZRk4Hau1BQnDQsJcBbU
         ROow==
X-Gm-Message-State: APjAAAV0/Di/RGfYDfNAksywL44hU7oMmKnH3oO22VZ3IqANsJ2H/Llf
        QheKQPwu6kBP8vwVANoUh8BkEA==
X-Google-Smtp-Source: APXvYqx2zcPaDUE+NEA7dMtqcm7Nr0Gll2dkZwmIPLTBF4nCY4JvXULR0j76QP0tqbRl/LAYHJpkzQ==
X-Received: by 2002:a17:902:f01:: with SMTP id 1mr43967938ply.170.1562182653824;
        Wed, 03 Jul 2019 12:37:33 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v4sm3227006pff.45.2019.07.03.12.37.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:33 -0700 (PDT)
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
Subject: [PATCH v2 3/7] dt-bindings: net: realtek: Add property to enable SSC
Date:   Wed,  3 Jul 2019 12:37:20 -0700
Message-Id: <20190703193724.246854-3-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
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
Changes in v2:
- patch added to the series (kind of, it already existed, but now
  the binding is created by another patch)
---
 Documentation/devicetree/bindings/net/realtek.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
index 63f7002fa704..71d386c78269 100644
--- a/Documentation/devicetree/bindings/net/realtek.txt
+++ b/Documentation/devicetree/bindings/net/realtek.txt
@@ -5,6 +5,10 @@ This document describes properties of Realtek PHYs.
 Optional properties:
 - realtek,eee-led-mode-disable: Disable EEE LED mode on this port.
 
+- realtek,enable-ssc : Enable Spread Spectrum Clocking (SSC) on this port.
+
+	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
+
 Example:
 
 mdio0 {
@@ -15,5 +19,6 @@ mdio0 {
 	ethphy: ethernet-phy@1 {
 		reg = <1>;
 		realtek,eee-led-mode-disable;
+		realtek,enable-ssc;
 	};
 };
-- 
2.22.0.410.gd8fdbe21b5-goog

