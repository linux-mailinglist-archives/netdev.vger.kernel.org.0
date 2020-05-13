Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9839A1D16EA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388891AbgEMODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388783AbgEMODY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:03:24 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924A0C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:03:24 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jYryc-0004bz-8g; Wed, 13 May 2020 16:03:14 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH] dt-bindings: net: dsa: b53: Add missing size and address cells to example
Date:   Wed, 13 May 2020 16:02:49 +0200
Message-Id: <20200513140249.24900-1-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing size and address cells to the b53 example. Otherwise, it may not
compile or issue warnings if directly copied into a device tree.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Documentation/devicetree/bindings/net/dsa/b53.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
index 5201bc15fdd6..cfd1afdc6e94 100644
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
@@ -110,6 +110,9 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 			#size-cells = <0>;
 
 			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
 				port0@0 {
 					reg = <0>;
 					label = "lan1";
-- 
2.20.1

