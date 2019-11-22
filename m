Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF56B106736
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKVHns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:43:48 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56587 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKVHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:43:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY3bS-0002iA-0S; Fri, 22 Nov 2019 08:43:42 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id 0E70A2C877E8; Fri, 22 Nov 2019 08:43:41 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 4/5] docs: networking: nfc: fix code block syntax
Date:   Fri, 22 Nov 2019 08:43:05 +0100
Message-Id: <20191122074306.78179-5-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122074306.78179-1-r.schwebel@pengutronix.de>
References: <20191122074306.78179-1-r.schwebel@pengutronix.de>
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

Silence this warning:

Documentation/networking/nfc.rst:113: WARNING: Definition list ends without
a blank line; unexpected unindent.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/nfc.txt | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
index af69b3a90eaa..9aab3a88c9b2 100644
--- a/Documentation/networking/nfc.txt
+++ b/Documentation/networking/nfc.txt
@@ -103,14 +103,14 @@ it's closed.
 LOW-LEVEL DATA EXCHANGE:
 
 The userspace must use PF_NFC sockets to perform any data communication with
-targets. All NFC sockets use AF_NFC:
-
-struct sockaddr_nfc {
-       sa_family_t sa_family;
-       __u32 dev_idx;
-       __u32 target_idx;
-       __u32 nfc_protocol;
-};
+targets. All NFC sockets use AF_NFC::
+
+        struct sockaddr_nfc {
+               sa_family_t sa_family;
+               __u32 dev_idx;
+               __u32 target_idx;
+               __u32 nfc_protocol;
+        };
 
 To establish a connection with one target, the user must create an
 NFC_SOCKPROTO_RAW socket and call the 'connect' syscall with the sockaddr_nfc
-- 
2.24.0

