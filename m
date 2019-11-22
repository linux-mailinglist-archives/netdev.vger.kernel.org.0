Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3102A106737
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKVHnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:43:45 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46117 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:43:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY3bS-0002i9-0R; Fri, 22 Nov 2019 08:43:42 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id 03AC52C877E7; Fri, 22 Nov 2019 08:43:41 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 3/5] docs: networking: nfc: fix bullet list syntax
Date:   Fri, 22 Nov 2019 08:43:04 +0100
Message-Id: <20191122074306.78179-4-r.schwebel@pengutronix.de>
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

Fix this warning:

Documentation/networking/nfc.rst:87: WARNING: Bullet list ends without
a blank line; unexpected unindent.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/nfc.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
index b6056e597e20..af69b3a90eaa 100644
--- a/Documentation/networking/nfc.txt
+++ b/Documentation/networking/nfc.txt
@@ -84,7 +84,7 @@ The operations are composed by commands and events, all listed below:
 * NFC_EVENT_DEVICE_ADDED - reports an NFC device addition
 * NFC_EVENT_DEVICE_REMOVED - reports an NFC device removal
 * NFC_EVENT_TARGETS_FOUND - reports START_POLL results when 1 or more targets
-are found
+  are found
 
 The user must call START_POLL to poll for NFC targets, passing the desired NFC
 protocols through NFC_ATTR_PROTOCOLS attribute. The device remains in polling
-- 
2.24.0

