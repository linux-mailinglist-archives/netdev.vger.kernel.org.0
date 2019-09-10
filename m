Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB3AEEBE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393976AbfIJPoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:44:22 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43794 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:44:22 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id F327228DA1D
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH 3/7] dt-bindings: mv88e6xxx: add ability to set default queue priorities per port
Date:   Tue, 10 Sep 2019 16:41:49 +0100
Message-Id: <20190910154238.9155-4-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document a new setting for Marvell switch chips to set the default queue
priorities per port.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 6f9538974bb9..e097c3c52eac 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -47,6 +47,10 @@ Optional properties:
 			  bus. The node must contains a compatible string of
 			  "marvell,mv88e6xxx-mdio-external"
 
+Optional properties for ports:
+- defqpri=<n>		: Enforced default queue priority for the given port.
+			  Valid range is 0..3
+
 Example:
 
 	mdio {
-- 
2.18.0

