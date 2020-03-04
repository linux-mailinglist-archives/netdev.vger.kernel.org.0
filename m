Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA710178F12
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgCDK7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:59:44 -0500
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:13074 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387792AbgCDK7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:59:44 -0500
Received: from vsmx004.vodafonemail.xion.oxcs.net (unknown [192.168.75.198])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTP id 6F129F350AC;
        Wed,  4 Mar 2020 10:54:17 +0000 (UTC)
Received: from app-31.app.xion.oxcs.net (app-31.app.xion.oxcs.net [10.10.1.31])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 104E019AF30;
        Wed,  4 Mar 2020 10:54:05 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:54:04 +0100 (CET)
From:   Markus Moll <moll.markus@arcor.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <1054463541.315325.1583319244987@mail.vodafone.de>
Subject: [PATCH 3/3] dt-bindings: net: Document dp83867 ti,led-modes
 property
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev66
X-Originating-Client: open-xchange-appsuite
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the documentation for the newly introduced optional
ti,led-modes property.

Signed-off-by: Markus Moll <moll.markus@arcor.de>
---
 Documentation/devicetree/bindings/net/ti,dp83867.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
index 44e2a4fab29..0c7bb8de272 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.txt
@@ -48,6 +48,10 @@ Optional property:
 	-rx-fifo-depth - As defined in the ethernet-controller.yaml.  Values for
 			 the depth can be found in dt-bindings/net/ti-dp83867.h
 
+	- ti,led-modes - Array of four LED mode values, corresponding to LED_0
+			 through LED_3. Valid LED mode values can be found in
+			 dt-bindings/net/ti-dp83867.h
+
 Note: ti,min-output-impedance and ti,max-output-impedance are mutually
       exclusive. When both properties are present ti,max-output-impedance
       takes precedence.
-- 
2.25.0
