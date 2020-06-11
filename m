Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A31F6CD8
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgFKRbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgFKRbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 13:31:23 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B92702084D;
        Thu, 11 Jun 2020 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591896683;
        bh=WaFkE1E/SBXMYjjsxn3HgJWL4j7uakAbW7l9hN8yq0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4gxEuhIKSUgl+oJZVOeRHHea2zope6Kc+4nguOuDASlxZ0/7DUZ0vbgy8kCB/n/W
         9hV+CBtHH29to5NCSKj+mwevY7T60VDUq/lId46NMlcYzK4J62U293hAF2kwOMBJXl
         zPZ+aPED5luZOF1fSLGW/vpuKJRtQvD/7aKOAGZE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, jreuter@yaina.de,
        linux-hams@vger.kernel.org
Subject: [RFC 2/8] docs: networking: move z8530 to the hw driver section
Date:   Thu, 11 Jun 2020 10:30:04 -0700
Message-Id: <20200611173010.474475-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611173010.474475-1-kuba@kernel.org>
References: <20200611173010.474475-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move z8530 docs to hamradio and wan subdirectories.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: jreuter@yaina.de
CC: linux-hams@vger.kernel.org
---
 .../device_drivers/hamradio/index.rst          | 18 ++++++++++++++++++
 .../{ => device_drivers/hamradio}/z8530drv.rst |  0
 .../networking/device_drivers/index.rst        |  2 ++
 .../networking/device_drivers/wan/index.rst    | 18 ++++++++++++++++++
 .../{ => device_drivers/wan}/z8530book.rst     |  0
 Documentation/networking/index.rst             |  2 --
 MAINTAINERS                                    |  2 +-
 drivers/net/hamradio/Kconfig                   |  8 +++++---
 drivers/net/hamradio/scc.c                     |  2 +-
 9 files changed, 45 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/hamradio/index.rst
 rename Documentation/networking/{ => device_drivers/hamradio}/z8530drv.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/wan/index.rst
 rename Documentation/networking/{ => device_drivers/wan}/z8530book.rst (100%)

diff --git a/Documentation/networking/device_drivers/hamradio/index.rst b/Documentation/networking/device_drivers/hamradio/index.rst
new file mode 100644
index 000000000000..df03a5acbfa7
--- /dev/null
+++ b/Documentation/networking/device_drivers/hamradio/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Amateur Radio Device Drivers
+============================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   z8530drv
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/z8530drv.rst b/Documentation/networking/device_drivers/hamradio/z8530drv.rst
similarity index 100%
rename from Documentation/networking/z8530drv.rst
rename to Documentation/networking/device_drivers/hamradio/z8530drv.rst
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 2d4817fc6a29..5497e3ae1ca9 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -11,6 +11,8 @@ Hardware Device Drivers
    cable/index
    cellular/index
    ethernet/index
+   hamradio/index
+   wan/index
    wifi/index
 
 .. only::  subproject and html
diff --git a/Documentation/networking/device_drivers/wan/index.rst b/Documentation/networking/device_drivers/wan/index.rst
new file mode 100644
index 000000000000..9d9ae94f00b4
--- /dev/null
+++ b/Documentation/networking/device_drivers/wan/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Classic WAN Device Drivers
+==========================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   z8530book
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/z8530book.rst b/Documentation/networking/device_drivers/wan/z8530book.rst
similarity index 100%
rename from Documentation/networking/z8530book.rst
rename to Documentation/networking/device_drivers/wan/z8530book.rst
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 0186e276690a..718e04e3f7ed 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -20,7 +20,6 @@ Linux Networking Documentation
    ieee802154
    j1939
    kapi
-   z8530book
    msg_zerocopy
    failover
    net_dim
@@ -122,7 +121,6 @@ Linux Networking Documentation
    xfrm_proc
    xfrm_sync
    xfrm_sysctl
-   z8530drv
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 154a6d34257e..4d31e9401b84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18842,7 +18842,7 @@ L:	linux-hams@vger.kernel.org
 S:	Maintained
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
-F:	Documentation/networking/z8530drv.rst
+F:	Documentation/networking/device_drivers/hamradio/z8530drv.rst
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index f4500f04147d..6aaca62940d0 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -84,8 +84,9 @@ config SCC
 	---help---
 	  These cards are used to connect your Linux box to an amateur radio
 	  in order to communicate with other computers. If you want to use
-	  this, read <file:Documentation/networking/z8530drv.rst> and the
-	  AX25-HOWTO, available from
+	  this, read
+	  <file:Documentation/networking/device_drivers/hamradio/z8530drv.rst>
+	  and the AX25-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>. Also make sure to say Y
 	  to "Amateur Radio AX.25 Level 2" support.
 
@@ -98,7 +99,8 @@ config SCC_DELAY
 	help
 	  Say Y here if you experience problems with the SCC driver not
 	  working properly; please read
-	  <file:Documentation/networking/z8530drv.rst> for details.
+	  <file:Documentation/networking/device_drivers/hamradio/z8530drv.rst>
+	  for details.
 
 	  If unsure, say N.
 
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 33fdd55c6122..1e915871baa7 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -7,7 +7,7 @@
  *            ------------------
  *
  * You can find a subset of the documentation in 
- * Documentation/networking/z8530drv.rst.
+ * Documentation/networking/device_drivers/wan/z8530drv.rst.
  */
 
 /*
-- 
2.26.2

