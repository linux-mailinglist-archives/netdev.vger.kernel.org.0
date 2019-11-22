Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7310673D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKVHnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:43:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47977 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfKVHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:43:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY3bS-0002ig-7S; Fri, 22 Nov 2019 08:43:42 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id 195F52C877E9; Fri, 22 Nov 2019 08:43:41 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 5/5] docs: networking: nfc: change to rst format
Date:   Fri, 22 Nov 2019 08:43:06 +0100
Message-Id: <20191122074306.78179-6-r.schwebel@pengutronix.de>
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

Now that the sphinx syntax has been fixed, change the document from txt
to rst and add it to the index.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/index.rst            | 1 +
 Documentation/networking/{nfc.txt => nfc.rst} | 0
 2 files changed, 1 insertion(+)
 rename Documentation/networking/{nfc.txt => nfc.rst} (100%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index d4dca42910d0..5acab1290e03 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -33,6 +33,7 @@ Contents:
    scaling
    tls
    tls-offload
+   nfc
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.rst
similarity index 100%
rename from Documentation/networking/nfc.txt
rename to Documentation/networking/nfc.rst
-- 
2.24.0

