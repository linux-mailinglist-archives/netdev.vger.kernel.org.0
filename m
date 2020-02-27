Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721E717226B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgB0PlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:41:18 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54415 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbgB0PlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:41:17 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8617860008;
        Thu, 27 Feb 2020 15:41:15 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] dt-bindings: net: phy: mscc: document LOS active low property
Date:   Thu, 27 Feb 2020 16:40:32 +0100
Message-Id: <20200227154033.1688498-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
References: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "vsc8584,los-active-low" property to denote when the
LOS signal connected directly to the PHY is active low.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index c682b6e74b14..24faee3cfebf 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -39,6 +39,7 @@ Optional properties:
 			  Allowed values are defined in
 			  "include/dt-bindings/net/mscc-phy-vsc8531.h".
 			  Default value is VSC8584_RGMII_SKEW_0_2.
+- vsc8584,los-active-low : If set, indicates the LOS pin is active low.
 
 
 Table: 1 - Edge rate change
-- 
2.24.1

