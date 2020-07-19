Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C396225153
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 12:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgGSKkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 06:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSKkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 06:40:53 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6946C0619D2;
        Sun, 19 Jul 2020 03:40:52 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 13924BC07E;
        Sun, 19 Jul 2020 10:40:48 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] ath5k: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 12:40:41 +0200
Message-Id: <20200719104041.57916-1-grandmaster@al2klimov.de>
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


 drivers/net/wireless/ath/ath5k/ath5k.h    | 2 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 979800c6f57f..234ea939d316 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -410,7 +410,7 @@ enum ath5k_radio {
  * This article claims Super G sticks to bonding of channels 5 and 6 for
  * USA:
  *
- * http://www.pcworld.com/article/id,113428-page,1/article.html
+ * https://www.pcworld.com/article/id,113428-page,1/article.html
  *
  * The channel bonding seems to be driver specific though.
  *
diff --git a/drivers/net/wireless/ath/ath5k/rfbuffer.h b/drivers/net/wireless/ath/ath5k/rfbuffer.h
index aed34d9954c0..151935c4827f 100644
--- a/drivers/net/wireless/ath/ath5k/rfbuffer.h
+++ b/drivers/net/wireless/ath/ath5k/rfbuffer.h
@@ -42,7 +42,7 @@
  * Also check out reg.h and U.S. Patent 6677779 B1 (about buffer
  * registers and control registers):
  *
- * http://www.google.com/patents?id=qNURAAAAEBAJ
+ * https://www.google.com/patents?id=qNURAAAAEBAJ
  */
 
 
-- 
2.27.0

