Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F0465F1D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355994AbhLBIJ0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Dec 2021 03:09:26 -0500
Received: from inet10.abb.com ([138.225.1.74]:55610 "EHLO inet10.abb.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhLBIJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 03:09:26 -0500
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1B285geK018464;
        Thu, 2 Dec 2021 09:05:42 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 9CD7C65A4DCE;
        Thu,  2 Dec 2021 09:05:42 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to marvell.txt
Date:   Thu,  2 Dec 2021 09:05:26 +0100
Message-Id: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be configured from the device tree. Add this property to the
documentation accordingly. This is a property of the port node, which
needs to be specified in millivolts

CC: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Marek Behún <kabel@kernel.org>
Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 2363b412410c..9292b6f960df 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -46,6 +46,11 @@ Optional properties:
 - mdio?		: Container of PHYs and devices on the external MDIO
 			  bus. The node must contains a compatible string of
 			  "marvell,mv88e6xxx-mdio-external"
+- serdes-output-amplitude-mv: Configure the output amplitude of the serdes
+			      interface in millivolts. This option can be
+                              set in the ports node as it is a property of
+                              the port.
+    serdes-output-amplitude-mv = <210>;
 
 Example:
 
-- 
2.34.0

