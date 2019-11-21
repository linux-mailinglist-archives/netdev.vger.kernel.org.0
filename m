Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A585010560F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKUPzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:55:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46645 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfKUPzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:55:10 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iXonT-0002x2-0c; Thu, 21 Nov 2019 16:55:07 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id AE6BB2C877E3; Thu, 21 Nov 2019 16:55:05 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/5] docs: networking: nfc: change block diagram to sphinx syntax
Date:   Thu, 21 Nov 2019 16:55:00 +0100
Message-Id: <20191121155503.52019-2-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121155503.52019-1-r.schwebel@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the block diagram to match the sphinx syntax. This will make it
possible to switch this file to rst in the future.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/nfc.txt | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
index c053610bfadc..b6056e597e20 100644
--- a/Documentation/networking/nfc.txt
+++ b/Documentation/networking/nfc.txt
@@ -26,30 +26,31 @@ The control operations are available to userspace via generic netlink.
 The low-level data exchange interface is provided by the new socket family
 PF_NFC. The NFC_SOCKPROTO_RAW performs raw communication with NFC targets.
 
-
-             +--------------------------------------+
-             |              USER SPACE              |
-             +--------------------------------------+
-                 ^                       ^
-                 | low-level             | control
-                 | data exchange         | operations
-                 |                       |
-                 |                       v
-                 |                  +-----------+
-                 | AF_NFC           |  netlink  |
-                 | socket           +-----------+
-                 | raw                   ^
-                 |                       |
-                 v                       v
-             +---------+            +-----------+
-             | rawsock | <--------> |   core    |
-             +---------+            +-----------+
-                                         ^
-                                         |
-                                         v
-                                    +-----------+
-                                    |  driver   |
-                                    +-----------+
+.. code-block:: none
+
+        +--------------------------------------+
+        |              USER SPACE              |
+        +--------------------------------------+
+            ^                       ^
+            | low-level             | control
+            | data exchange         | operations
+            |                       |
+            |                       v
+            |                  +-----------+
+            | AF_NFC           |  netlink  |
+            | socket           +-----------+
+            | raw                   ^
+            |                       |
+            v                       v
+        +---------+            +-----------+
+        | rawsock | <--------> |   core    |
+        +---------+            +-----------+
+                                    ^
+                                    |
+                                    v
+                               +-----------+
+                               |  driver   |
+                               +-----------+
 
 Device Driver Interface
 =======================
-- 
2.24.0

