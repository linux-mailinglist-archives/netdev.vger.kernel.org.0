Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56F105613
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKUPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:55:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59587 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKUPzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:55:11 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iXonT-0002x1-0c; Thu, 21 Nov 2019 16:55:07 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id ABCD72C877E4; Thu, 21 Nov 2019 16:55:05 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/5] docs: networking: nfc: change headlines to sphinx syntax
Date:   Thu, 21 Nov 2019 16:54:59 +0100
Message-Id: <20191121155503.52019-1-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
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

The headlines in this file do are not in the standard kernel docu-
mentation headline format. Change it, so this file can be switched to
rst in the future.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/nfc.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
index b24c29bdae27..c053610bfadc 100644
--- a/Documentation/networking/nfc.txt
+++ b/Documentation/networking/nfc.txt
@@ -1,3 +1,4 @@
+===================
 Linux NFC subsystem
 ===================
 
@@ -8,7 +9,7 @@ This document covers the architecture overview, the device driver interface
 description and the userspace interface description.
 
 Architecture overview
----------------------
+=====================
 
 The NFC subsystem is responsible for:
       - NFC adapters management;
@@ -51,7 +52,7 @@ PF_NFC. The NFC_SOCKPROTO_RAW performs raw communication with NFC targets.
                                     +-----------+
 
 Device Driver Interface
------------------------
+=======================
 
 When registering on the NFC subsystem, the device driver must inform the core
 of the set of supported NFC protocols and the set of ops callbacks. The ops
@@ -64,7 +65,7 @@ callbacks that must be implemented are the following:
 * data_exchange - send data and receive the response (transceive operation)
 
 Userspace interface
---------------------
+===================
 
 The userspace interface is divided in control operations and low-level data
 exchange operation.
-- 
2.24.0

