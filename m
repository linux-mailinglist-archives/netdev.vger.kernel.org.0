Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4ADB9AD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438387AbfJQWWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:22:37 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:55009 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406722AbfJQWWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:22:37 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 194B61BF203;
        Thu, 17 Oct 2019 22:22:34 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next v3 1/2] dt-bindings: net: lpc-eth: document optional properties
Date:   Fri, 18 Oct 2019 00:22:30 +0200
Message-Id: <20191017222231.29122-2-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
References: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet controller is also an mdio controller, to be able to parse
children (phys for example), and mdio node must be present.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/net/lpc-eth.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/lpc-eth.txt b/Documentation/devicetree/bindings/net/lpc-eth.txt
index b92e927808b6..cfe0e5991d46 100644
--- a/Documentation/devicetree/bindings/net/lpc-eth.txt
+++ b/Documentation/devicetree/bindings/net/lpc-eth.txt
@@ -10,6 +10,11 @@ Optional properties:
   absent, "rmii" is assumed.
 - use-iram: Use LPC32xx internal SRAM (IRAM) for DMA buffering
 
+Optional subnodes:
+- mdio : specifies the mdio bus, used as a container for phy nodes according to
+  phy.txt in the same directory
+
+
 Example:
 
 	mac: ethernet@31060000 {
-- 
2.21.0

