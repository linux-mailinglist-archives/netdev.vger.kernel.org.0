Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24D520B6FC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgFZR2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgFZR2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:28:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67CA21473;
        Fri, 26 Jun 2020 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593192480;
        bh=hACNMea3X+89Scprjr38jVVQNB+Ocq3AspyCHKFB/X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/fbmeBOhq9tmO2wUNmY8EynokNGjGu4/LpPK42BNnrvZOZPDcNMEWCsXhYzM6Ing
         f5x1YyNVvRnfqjUKTxIE8IV6ItvX4ub6aOXUBlh6yu6mROg05iF555fnEjv3CmJJKB
         H7sF687h8rsLpdQyVeSLDjG5uGFaUZyoI/+0nsCg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        macro@linux-mips.org
Subject: [PATCH net-next 8/8] docs: networking: move FDDI drivers to the hw driver section
Date:   Fri, 26 Jun 2020 10:27:31 -0700
Message-Id: <20200626172731.280133-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move docs for defza and skfp under device_drivers/fddi.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: macro@linux-mips.org
---
 .../{ => device_drivers/fddi}/defza.rst       |  0
 .../networking/device_drivers/fddi/index.rst  | 19 +++++++++++++++++++
 .../{ => device_drivers/fddi}/skfp.rst        |  0
 .../networking/device_drivers/index.rst       |  1 +
 Documentation/networking/index.rst            |  2 --
 drivers/net/fddi/Kconfig                      |  4 ++--
 6 files changed, 22 insertions(+), 4 deletions(-)
 rename Documentation/networking/{ => device_drivers/fddi}/defza.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/fddi/index.rst
 rename Documentation/networking/{ => device_drivers/fddi}/skfp.rst (100%)

diff --git a/Documentation/networking/defza.rst b/Documentation/networking/device_drivers/fddi/defza.rst
similarity index 100%
rename from Documentation/networking/defza.rst
rename to Documentation/networking/device_drivers/fddi/defza.rst
diff --git a/Documentation/networking/device_drivers/fddi/index.rst b/Documentation/networking/device_drivers/fddi/index.rst
new file mode 100644
index 000000000000..0b75294e6c8b
--- /dev/null
+++ b/Documentation/networking/device_drivers/fddi/index.rst
@@ -0,0 +1,19 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Fiber Distributed Data Interface (FDDI) Device Drivers
+======================================================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   defza
+   skfp
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/skfp.rst b/Documentation/networking/device_drivers/fddi/skfp.rst
similarity index 100%
rename from Documentation/networking/skfp.rst
rename to Documentation/networking/device_drivers/fddi/skfp.rst
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index d6a73e4592e0..a3113ffd7a16 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -13,6 +13,7 @@ Hardware Device Drivers
    cable/index
    cellular/index
    ethernet/index
+   fddi/index
    hamradio/index
    wan/index
    wifi/index
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index f48f1d19caff..c29496fff81c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -47,7 +47,6 @@ Linux Networking Documentation
    dccp
    dctcp
    decnet
-   defza
    dns_resolver
    driver
    eql
@@ -94,7 +93,6 @@ Linux Networking Documentation
    sctp
    secid
    seg6-sysctl
-   skfp
    strparser
    switchdev
    tc-actions-env-rules
diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
index 60cc7524520c..f722079dfb6a 100644
--- a/drivers/net/fddi/Kconfig
+++ b/drivers/net/fddi/Kconfig
@@ -77,8 +77,8 @@ config SKFP
 	  - Netelligent 100 FDDI SAS UTP
 	  - Netelligent 100 FDDI SAS Fibre MIC
 
-	  Read <file:Documentation/networking/skfp.rst> for information about
-	  the driver.
+	  Read <file:Documentation/networking/device_drivers/fddi/skfp.rst>
+	  for information about the driver.
 
 	  Questions concerning this driver can be addressed to:
 	  <linux@syskonnect.de>
-- 
2.26.2

