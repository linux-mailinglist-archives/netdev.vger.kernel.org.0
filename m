Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7E121D266
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgGMJDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgGMJDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 05:03:01 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A875C061755;
        Mon, 13 Jul 2020 02:03:01 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id EB8CFBC0D1;
        Mon, 13 Jul 2020 09:02:57 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] [NET] AX.25 Kconfig: Replace HTTP links with HTTPS ones
Date:   Mon, 13 Jul 2020 11:02:51 +0200
Message-Id: <20200713090251.32640-1-grandmaster@al2klimov.de>
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


 net/ax25/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
index 97d686d115c0..d3a9843a043d 100644
--- a/net/ax25/Kconfig
+++ b/net/ax25/Kconfig
@@ -8,7 +8,7 @@ menuconfig HAMRADIO
 	bool "Amateur Radio support"
 	help
 	  If you want to connect your Linux box to an amateur radio, answer Y
-	  here. You want to read <http://www.tapr.org/>
+	  here. You want to read <https://www.tapr.org/>
 	  and more specifically about AX.25 on Linux
 	  <http://www.linux-ax25.org/>.
 
@@ -39,11 +39,11 @@ config AX25
 	  Information about where to get supporting software for Linux amateur
 	  radio as well as information about how to configure an AX.25 port is
 	  contained in the AX25-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. You might also want to
+	  <https://www.tldp.org/docs.html#howto>. You might also want to
 	  check out the file <file:Documentation/networking/ax25.rst> in the
 	  kernel source. More information about digital amateur radio in
 	  general is on the WWW at
-	  <http://www.tapr.org/>.
+	  <https://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ax25.
@@ -90,7 +90,7 @@ config NETROM
 	  <http://www.linux-ax25.org>. You also might want to check out the
 	  file <file:Documentation/networking/ax25.rst>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/>.
+	  <https://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called netrom.
@@ -109,7 +109,7 @@ config ROSE
 	  <http://www.linux-ax25.org>.  You also might want to check out the
 	  file <file:Documentation/networking/ax25.rst>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/>.
+	  <https://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rose.
-- 
2.27.0

