Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5422345F55A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbhKZTqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:46:55 -0500
Received: from inet10.abb.com ([138.225.1.74]:33804 "EHLO inet10.abb.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhKZToz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 14:44:55 -0500
X-Greylist: delayed 14290 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 14:44:54 EST
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1AQFh7Dp005536;
        Fri, 26 Nov 2021 16:43:07 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 6674865A4213;
        Fri, 26 Nov 2021 16:43:07 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to marvell.txt
Date:   Fri, 26 Nov 2021 16:42:48 +0100
Message-Id: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be configured from the device tree. Add this property to the
documentation accordingly.
The eight different values added in the dt-bindings file correspond to
the values we can configure on 88E6352, 88E6240 and 88E6176 switches
according to the datasheet.

CC: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
 .../devicetree/bindings/net/dsa/marvell.txt    |  3 +++
 include/dt-bindings/net/mv-88e6xxx.h           | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)
 create mode 100644 include/dt-bindings/net/mv-88e6xxx.h

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Docu=
mentation/devicetree/bindings/net/dsa/marvell.txt
index 2363b412410c..bff397a2dc49 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -46,6 +46,9 @@ Optional properties:
 - mdio?		: Container of PHYs and devices on the external MDIO
 			  bus. The node must contains a compatible string of
 			  "marvell,mv88e6xxx-mdio-external"
+- serdes-output-amplitude: Configure the output amplitude of the serdes
+			   interface.
+    serdes-output-amplitude =3D <MV88E6352_SERDES_OUT_AMP_210MV>;
=20
 Example:
=20
diff --git a/include/dt-bindings/net/mv-88e6xxx.h b/include/dt-bindings/n=
et/mv-88e6xxx.h
new file mode 100644
index 000000000000..9bc6decaee83
--- /dev/null
+++ b/include/dt-bindings/net/mv-88e6xxx.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Marvell 88E6XXX switch devices
+ */
+
+#ifndef _DT_BINDINGS_MV_88E6XXX_H
+#define _DT_BINDINGS_MV_88E6XXX_H
+
+#define MV88E6352_SERDES_OUT_AMP_14MV		0x0
+#define MV88E6352_SERDES_OUT_AMP_112MV		0x1
+#define MV88E6352_SERDES_OUT_AMP_210MV		0x2
+#define MV88E6352_SERDES_OUT_AMP_308MV		0x3
+#define MV88E6352_SERDES_OUT_AMP_406MV		0x4
+#define MV88E6352_SERDES_OUT_AMP_504MV		0x5
+#define MV88E6352_SERDES_OUT_AMP_602MV		0x6
+#define MV88E6352_SERDES_OUT_AMP_700MV		0x7
+
+#endif
--=20
2.34.0

