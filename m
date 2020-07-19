Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA92252D5
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 18:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgGSQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 12:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 12:39:59 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3692C0619D2;
        Sun, 19 Jul 2020 09:39:58 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id E2448BC086;
        Sun, 19 Jul 2020 16:39:54 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     jreuter@yaina.de, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] ax25: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 18:39:48 +0200
Message-Id: <20200719163948.60227-1-grandmaster@al2klimov.de>
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

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
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


 Documentation/networking/z8530drv.rst | 4 ++--
 drivers/net/hamradio/scc.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/z8530drv.rst b/Documentation/networking/z8530drv.rst
index d2942760f167..79c7f72f32c8 100644
--- a/Documentation/networking/z8530drv.rst
+++ b/Documentation/networking/z8530drv.rst
@@ -18,7 +18,7 @@ Internet:
 Please note that the information in this document may be hopelessly outdated.
 A new version of the documentation, along with links to other important
 Linux Kernel AX.25 documentation and programs, is available on
-http://yaina.de/jreuter
+https://yaina.de/jreuter
 
 Copyright |copy| 1993,2000 by Joerg Reuter DL1BKE <jreuter@yaina.de>
 
@@ -683,4 +683,4 @@ in the Linux standard distribution and their support.
 	Joerg Reuter	ampr-net: dl1bke@db0pra.ampr.org
 			AX-25   : DL1BKE @ DB0ABH.#BAY.DEU.EU
 			Internet: jreuter@yaina.de
-			WWW     : http://yaina.de/jreuter
+			WWW     : https://yaina.de/jreuter
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 33fdd55c6122..875d9262ef78 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -131,7 +131,7 @@
    Joerg Reuter	ampr-net: dl1bke@db0pra.ampr.org
 		AX-25   : DL1BKE @ DB0ABH.#BAY.DEU.EU
 		Internet: jreuter@yaina.de
-		www     : http://yaina.de/jreuter
+		www     : https://yaina.de/jreuter
 */
 
 /* ----------------------------------------------------------------------- */
-- 
2.27.0

