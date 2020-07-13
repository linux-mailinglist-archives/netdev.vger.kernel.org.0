Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C580621D2DC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgGMJdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:33:36 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:55354 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgGMJdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 05:33:36 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id DDA56BC09E;
        Mon, 13 Jul 2020 09:33:32 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] WAN: Replace HTTP links with HTTPS ones
Date:   Mon, 13 Jul 2020 11:33:23 +0200
Message-Id: <20200713093323.32841-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not just HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 drivers/net/wan/c101.c      | 2 +-
 drivers/net/wan/n2.c        | 2 +-
 drivers/net/wan/pc300too.c  | 2 +-
 drivers/net/wan/pci200syn.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index cb57f9124ab1..c354a5143e99 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2000-2003 Krzysztof Halasa <khc@pm.waw.pl>
  *
- * For information see <http://www.kernel.org/pub/linux/utils/net/hdlc/>
+ * For information see <https://www.kernel.org/pub/linux/utils/net/hdlc/>
  *
  * Sources of information:
  *    Hitachi HD64570 SCA User's Manual
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index f9e7fc7e9978..5bf4463873b1 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 1998-2003 Krzysztof Halasa <khc@pm.waw.pl>
  *
- * For information see <http://www.kernel.org/pub/linux/utils/net/hdlc/>
+ * For information see <https://www.kernel.org/pub/linux/utils/net/hdlc/>
  *
  * Note: integrated CSU/DSU/DDS are not supported by this driver
  *
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 190735604b2e..001fd378d417 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2000-2008 Krzysztof Halasa <khc@pm.waw.pl>
  *
- * For information see <http://www.kernel.org/pub/linux/utils/net/hdlc/>.
+ * For information see <https://www.kernel.org/pub/linux/utils/net/hdlc/>.
  *
  * Sources of information:
  *    Hitachi HD64572 SCA-II User's Manual
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index b5f8aaca5f06..d0062224b216 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2002-2008 Krzysztof Halasa <khc@pm.waw.pl>
  *
- * For information see <http://www.kernel.org/pub/linux/utils/net/hdlc/>
+ * For information see <https://www.kernel.org/pub/linux/utils/net/hdlc/>
  *
  * Sources of information:
  *    Hitachi HD64572 SCA-II User's Manual
-- 
2.27.0

