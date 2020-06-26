Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6E20B6FF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgFZR2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgFZR2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:28:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5444D2145D;
        Fri, 26 Jun 2020 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593192480;
        bh=v1NTG5KtN+mjsdBpO4KKe7dKii48DhnBQ9oVyllkbRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auGPhjybu70TTYo2kKBbUWr6CkS3cbJMvTwD73h3gYlHeTPFR25uiQcshXV9dPGhF
         kF/48rnaDayIXO1RxR2s36EhcE9M9K8GegJEBEdsSSt7VCyxl5Tp4ZnJ8Ayt5qU8nL
         HR7fR/vNiHPFKQ30sOjyvu2MbYI4bmqLFAC+zMn4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        accessrunner-general@lists.sourceforge.net, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH net-next 7/8] docs: networking: move ATM drivers to the hw driver section
Date:   Fri, 26 Jun 2020 10:27:30 -0700
Message-Id: <20200626172731.280133-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move docs for cxacru, fore200e and iphase under device_drivers/atm.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: accessrunner-general@lists.sourceforge.net
CC: 3chas3@gmail.com
CC: linux-atm-general@lists.sourceforge.net
---
 .../{ => device_drivers/atm}/cxacru-cf.py     |  0
 .../{ => device_drivers/atm}/cxacru.rst       |  0
 .../{ => device_drivers/atm}/fore200e.rst     |  0
 .../networking/device_drivers/atm/index.rst   | 20 +++++++++++++++++++
 .../{ => device_drivers/atm}/iphase.rst       |  0
 .../networking/device_drivers/index.rst       |  1 +
 Documentation/networking/index.rst            |  3 ---
 drivers/atm/Kconfig                           |  8 +++++---
 8 files changed, 26 insertions(+), 6 deletions(-)
 rename Documentation/networking/{ => device_drivers/atm}/cxacru-cf.py (100%)
 rename Documentation/networking/{ => device_drivers/atm}/cxacru.rst (100%)
 rename Documentation/networking/{ => device_drivers/atm}/fore200e.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/atm/index.rst
 rename Documentation/networking/{ => device_drivers/atm}/iphase.rst (100%)

diff --git a/Documentation/networking/cxacru-cf.py b/Documentation/networking/device_drivers/atm/cxacru-cf.py
similarity index 100%
rename from Documentation/networking/cxacru-cf.py
rename to Documentation/networking/device_drivers/atm/cxacru-cf.py
diff --git a/Documentation/networking/cxacru.rst b/Documentation/networking/device_drivers/atm/cxacru.rst
similarity index 100%
rename from Documentation/networking/cxacru.rst
rename to Documentation/networking/device_drivers/atm/cxacru.rst
diff --git a/Documentation/networking/fore200e.rst b/Documentation/networking/device_drivers/atm/fore200e.rst
similarity index 100%
rename from Documentation/networking/fore200e.rst
rename to Documentation/networking/device_drivers/atm/fore200e.rst
diff --git a/Documentation/networking/device_drivers/atm/index.rst b/Documentation/networking/device_drivers/atm/index.rst
new file mode 100644
index 000000000000..7b593f031a60
--- /dev/null
+++ b/Documentation/networking/device_drivers/atm/index.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Asynchronous Transfer Mode (ATM) Device Drivers
+===============================================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   cxacru
+   fore200e
+   iphase
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/iphase.rst b/Documentation/networking/device_drivers/atm/iphase.rst
similarity index 100%
rename from Documentation/networking/iphase.rst
rename to Documentation/networking/device_drivers/atm/iphase.rst
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 3995e2179aa0..d6a73e4592e0 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -9,6 +9,7 @@ Hardware Device Drivers
    :maxdepth: 2
 
    appletalk/index
+   atm/index
    cable/index
    cellular/index
    ethernet/index
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index eb616ac48094..f48f1d19caff 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -44,7 +44,6 @@ Linux Networking Documentation
    ax25
    bonding
    cdc_mbim
-   cxacru
    dccp
    dctcp
    decnet
@@ -54,7 +53,6 @@ Linux Networking Documentation
    eql
    fib_trie
    filter
-   fore200e
    framerelay
    generic-hdlc
    generic_netlink
@@ -63,7 +61,6 @@ Linux Networking Documentation
    ila
    ipddp
    ip_dynaddr
-   iphase
    ipsec
    ip-sysctl
    ipv6
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index 8007e051876c..b9370bbca828 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -306,8 +306,9 @@ config ATM_IA
 	  for more info about the cards. Say Y (or M to compile as a module
 	  named iphase) here if you have one of these cards.
 
-	  See the file <file:Documentation/networking/iphase.rst> for further
-	  details.
+	  See the file
+	  <file:Documentation/networking/device_drivers/atm/iphase.rst>
+	  for further details.
 
 config ATM_IA_DEBUG
 	bool "Enable debugging messages"
@@ -336,7 +337,8 @@ config ATM_FORE200E
 	  on PCI and SBUS hosts. Say Y (or M to compile as a module
 	  named fore_200e) here if you have one of these ATM adapters.
 
-	  See the file <file:Documentation/networking/fore200e.rst> for
+	  See the file
+	  <file:Documentation/networking/device_drivers/atm/fore200e.rst> for
 	  further details.
 
 config ATM_FORE200E_USE_TASKLET
-- 
2.26.2

