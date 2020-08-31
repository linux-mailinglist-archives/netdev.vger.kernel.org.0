Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12E257ACA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgHaNsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgHaNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:48:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF411C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 06:48:53 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAw-0000Lg-Id; Mon, 31 Aug 2020 15:48:46 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAr-0005HD-3l; Mon, 31 Aug 2020 15:48:41 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 3/5] dt-bindings: net: phy: smsc: document reference clock
Date:   Mon, 31 Aug 2020 15:48:34 +0200
Message-Id: <20200831134836.20189-4-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831134836.20189-1-m.felsch@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
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
---
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

