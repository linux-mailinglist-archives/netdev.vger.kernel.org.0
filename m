Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB079225412
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGSUQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgGSUQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:16:45 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20B5C0619D2;
        Sun, 19 Jul 2020 13:16:44 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 90DEABC064;
        Sun, 19 Jul 2020 20:16:40 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] rxrpc: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 22:16:32 +0200
Message-Id: <20200719201632.61594-1-grandmaster@al2klimov.de>
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


 Documentation/networking/rxrpc.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
index 39c2249c7aa7..2a842d4ee50f 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -506,7 +506,7 @@ kaserver or the kerberos server and installed as "rxrpc" type keys.  This is
 normally done using the klog program.  An example simple klog program can be
 found at:
 
-	http://people.redhat.com/~dhowells/rxrpc/klog.c
+	https://people.redhat.com/~dhowells/rxrpc/klog.c
 
 The payload provided to add_key() on the client should be of the following
 form::
@@ -537,7 +537,7 @@ socket then looks the server secret keys up in this keyring when secure
 incoming connections are made.  This can be seen in an example program that can
 be found at:
 
-	http://people.redhat.com/~dhowells/rxrpc/listen.c
+	https://people.redhat.com/~dhowells/rxrpc/listen.c
 
 
 ====================
-- 
2.27.0

