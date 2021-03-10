Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690CE333C12
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhCJMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhCJMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:02:55 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 682D6C061760;
        Wed, 10 Mar 2021 04:02:55 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C4E609200B4; Wed, 10 Mar 2021 13:02:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C24669200B3;
        Wed, 10 Mar 2021 13:02:54 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:02:54 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] FDDI: defza: Update my e-mail address
In-Reply-To: <alpine.DEB.2.21.2103091700320.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103091711311.33195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2103091700320.33195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the recent update to MAINTAINERS update my e-mail address.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 Documentation/networking/device_drivers/fddi/defza.rst |    2 +-
 drivers/net/fddi/defza.c                               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-defxx/Documentation/networking/device_drivers/fddi/defza.rst
===================================================================
--- linux-defxx.orig/Documentation/networking/device_drivers/fddi/defza.rst
+++ linux-defxx/Documentation/networking/device_drivers/fddi/defza.rst
@@ -60,4 +60,4 @@ None.
 
 Both success and failure reports are welcome.
 
-Maciej W. Rozycki  <macro@linux-mips.org>
+Maciej W. Rozycki  <macro@orcam.me.uk>
Index: linux-defxx/drivers/net/fddi/defza.c
===================================================================
--- linux-defxx.orig/drivers/net/fddi/defza.c
+++ linux-defxx/drivers/net/fddi/defza.c
@@ -60,7 +60,7 @@
 static const char version[] =
 	DRV_NAME ": " DRV_VERSION "  " DRV_RELDATE "  Maciej W. Rozycki\n";
 
-MODULE_AUTHOR("Maciej W. Rozycki <macro@linux-mips.org>");
+MODULE_AUTHOR("Maciej W. Rozycki <macro@orcam.me.uk>");
 MODULE_DESCRIPTION("DEC FDDIcontroller 700 (DEFZA-xx) driver");
 MODULE_LICENSE("GPL");
 
