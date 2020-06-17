Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95F61FD754
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgFQVdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:33:39 -0400
Received: from gloria.sntech.de ([185.11.138.130]:48414 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:33:39 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.sntech)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jlfgX-00063V-FC; Wed, 17 Jun 2020 23:33:29 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH v4 2/3] dt-bindings: net: ethernet-phy: add enet-phy-clock-out-frequency
Date:   Wed, 17 Jun 2020 23:33:25 +0200
Message-Id: <20200617213326.1532365-3-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617213326.1532365-1-heiko@sntech.de>
References: <20200617213326.1532365-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

Some ethernet phys have a configurable clock output, so add a generic
property to describe its target rate.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 9b1f1147ca36..4dcf93f1c555 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -84,6 +84,11 @@ properties:
       the turn around line low at end of the control phase of the
       MDIO transaction.
 
+  enet-phy-clock-out-frequency:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Frequency in Hz to set an available clock output to.
+
   enet-phy-lane-swap:
     $ref: /schemas/types.yaml#definitions/flag
     description:
-- 
2.26.2

