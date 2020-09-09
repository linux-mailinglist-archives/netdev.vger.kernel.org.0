Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B5A263288
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgIIQpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730948AbgIIQMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D78C061384
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:45:19 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PO-0007Fa-Fs; Wed, 09 Sep 2020 15:45:10 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PI-0000fQ-Ub; Wed, 09 Sep 2020 15:45:04 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v3 3/5] dt-bindings: net: phy: smsc: document reference clock
Date:   Wed,  9 Sep 2020 15:44:59 +0200
Message-Id: <20200909134501.32529-4-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909134501.32529-1-m.felsch@pengutronix.de>
References: <20200909134501.32529-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to specify the reference clock for the phy.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3:
- Add Florian's tag

v2:
- no change

 Documentation/devicetree/bindings/net/smsc-lan87xx.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/smsc-lan87xx.txt b/Documentation/devicetree/bindings/net/smsc-lan87xx.txt
index 8b7c719b0bb9..a8d0dc9a8c0e 100644
--- a/Documentation/devicetree/bindings/net/smsc-lan87xx.txt
+++ b/Documentation/devicetree/bindings/net/smsc-lan87xx.txt
@@ -5,6 +5,10 @@ through an Ethernet OF device node.
 
 Optional properties:
 
+- clocks:
+  The clock used as phy reference clock and is connected to phy
+  pin XTAL1/CLKIN.
+
 - smsc,disable-energy-detect:
   If set, do not enable energy detect mode for the SMSC phy.
   default: enable energy detect mode
-- 
2.20.1

