Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8658526F0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbfFYIlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:41:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37563 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfFYIly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:41:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so2015113wme.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wP2rw4kyNxDZjxGdrCho3L1eyWBbf8hCIeEzpMvXyTM=;
        b=Y1eWyt2tOpBNsP6voFncIvF/b72/LZm+Fmmf+eWLPvhpeA65Nlfm9rATHRJhw5mIU9
         bxOFzAwpRnAWWgXlE1kdrUo6cgNpG5DdL2YerjUyRlqqPGuaUeHWupQIKF64G1/pACd8
         5sI0YsMaqMkzor+dx8kNWbxfP2ou88a05pIUNa6bYPKovVSr/KSXJhh3vj92Ao1opZwk
         PoT/zlGWrCVLuXUiDWLgAArKwK1HPBVYYtA0VQI1zvmADt+bUxLX8kLlz/Hb7K2qqFOM
         uNJUNqlzkOsLdUtfFTK4OByga01XWKdm94sRKwDP6CAveTSLaVy7alaae6TJ697wlonP
         /2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wP2rw4kyNxDZjxGdrCho3L1eyWBbf8hCIeEzpMvXyTM=;
        b=TaAt7t11o1T6hJZd/3GnJm3F8Fh/KegIDXz0YCd4RsTD2/r24hIKTewUoQUXfUzjs5
         FVxTGza0yApcyEYpuoRBhYR0MjldxtbumlDo+LKa2/CQgxOd4V3nKUMv45h2TnNpHmmC
         HGW2+uNT8smJkrMic32Vq5qn1O5tnHcOS3THuHpFcKpGGOP/y+NWCxj/w/Aw50XCmo7O
         kJH5SVfGMckDcsCzADpnqgLnZGoF34c8zCn7RV7HyjMIhXu2PWAkubA9H4bgjhcFM1UQ
         /xFN1WpynKoPPL74KF1NRgy23k1soM0TKdh7OL5AkDrRipwi4ViN19K+aP2rqMhW+D5t
         6SOw==
X-Gm-Message-State: APjAAAXSr4DMc02+AuTL/FMkZnh1UZCpxzlpmduIkQRbAnz8ifTC1gZ/
        XXxX3jY1B1B6lTc+I2R9PcNEvGue
X-Google-Smtp-Source: APXvYqyZ+T8YTqLOvrTWird+BxdppUT3IBTAKSzcNIGdX+7tRr75c27UpHjeTgn7ZOzCuim9RrJXUg==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr18802784wmf.19.1561452112334;
        Tue, 25 Jun 2019 01:41:52 -0700 (PDT)
Received: from debian64.daheim (pD9E29981.dip0.t-ipconnect.de. [217.226.153.129])
        by smtp.gmail.com with ESMTPSA id 72sm17384374wrk.22.2019.06.25.01.41.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:41:51 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hfh1T-0002ST-8X; Tue, 25 Jun 2019 10:41:51 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v1 1/2] dt-bindings: net: dsa: qca8k: document reset-gpios property
Date:   Tue, 25 Jun 2019 10:41:50 +0200
Message-Id: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch documents the qca8k's reset-gpios property that
can be used if the QCA8337N ends up in a bad state during
reset.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 93a7469e70d4..ccbc6d89325d 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -9,6 +9,10 @@ Required properties:
 - #size-cells: must be 0
 - #address-cells: must be 1
 
+Optional properties:
+
+- reset-gpios: GPIO to be used to reset the whole device
+
 Subnodes:
 
 The integrated switch subnode should be specified according to the binding
@@ -66,6 +70,7 @@ for the external mdio-bus configuration:
 			#address-cells = <1>;
 			#size-cells = <0>;
 
+			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
 			reg = <0x10>;
 
 			ports {
@@ -123,6 +128,7 @@ for the internal master mdio-bus configuration:
 			#address-cells = <1>;
 			#size-cells = <0>;
 
+			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
 			reg = <0x10>;
 
 			ports {
-- 
2.20.1

