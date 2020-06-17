Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016D01FCEA1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgFQNgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:36:55 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:52795 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgFQNgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:36:37 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 31987200005;
        Wed, 17 Jun 2020 13:36:30 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v2 7/8] dt-bindings: net: phy: vsc8531: document the load/save GPIO
Date:   Wed, 17 Jun 2020 15:31:26 +0200
Message-Id: <20200617133127.628454-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617133127.628454-1-antoine.tenart@bootlin.com>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new optional property can be used to reference the load/save GPIO,
used for PTP hardware clock (PHC) operations. This patch documents it in
the binding documentation.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 5ff37c68c941..87a27d775d48 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -31,6 +31,8 @@ Optional properties:
 			  VSC8531_LINK_100_ACTIVITY (2),
 			  VSC8531_LINK_ACTIVITY (0) and
 			  VSC8531_DUPLEX_COLLISION (8).
+- load-save-gpios	: GPIO used for the load/save operation of the PTP
+			  hardware clock (PHC).
 
 
 Table: 1 - Edge rate change
@@ -67,4 +69,5 @@ Example:
                 vsc8531,edge-slowdown	= <7>;
                 vsc8531,led-0-mode	= <LINK_1000_ACTIVITY>;
                 vsc8531,led-1-mode	= <LINK_100_ACTIVITY>;
+		load-save-gpios		= <&gpio 10 GPIO_ACTIVE_HIGH>;
         };
-- 
2.26.2

