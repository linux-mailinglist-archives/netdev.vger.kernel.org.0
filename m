Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2226323A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbgIIQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:37:18 -0400
Received: from mail.nic.cz ([217.31.204.67]:34678 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731057AbgIIQ0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:26:00 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 503A6140A73;
        Wed,  9 Sep 2020 18:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=MvXQD34WvMImgeFSgU4h5cxDM9wpALrPc1U2c97TNVY=;
        h=From:To:Date;
        b=esEDFi4f3TDJKUxF7mN6MzWKDJGWacG1D+Spd1xIHmg6lLdcjm+uuP3eEEmy+ElKF
         GjuPZAc1ZUJBazQibj2HS2xM7O0h2Hc2UKz3xfHunBg1krjXxGRpiNIx3Eww8D1xmI
         i/4QBWcehwJMgM4deFm8xFympqFdLIWqITJajpas=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next + leds v2 4/7] dt-bindings: net: ethernet-phy: add description for PHY LEDs
Date:   Wed,  9 Sep 2020 18:25:49 +0200
Message-Id: <20200909162552.11032-5-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document binding for LEDs connected to an ethernet PHY chip.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index a9e547ac79051..f593e8709dd0d 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -174,6 +174,14 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    type: object
+    description: |
+      This is used to described LEDs that are connected to the PHY chip and
+      their blinking can be controlled by the PHY.
+    allOf:
+      - $ref: /schemas/leds/linux,hw-controlled-leds.yaml#
+
 required:
   - reg
 
-- 
2.26.2

