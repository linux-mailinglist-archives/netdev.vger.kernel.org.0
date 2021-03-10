Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736AB333C0E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhCJMDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhCJMCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:02:48 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19E52C061760;
        Wed, 10 Mar 2021 04:02:48 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 6B22092009D; Wed, 10 Mar 2021 13:02:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 6548392009B;
        Wed, 10 Mar 2021 13:02:42 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:02:42 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] FDDI: if_fddi.h: Update my e-mail address
In-Reply-To: <alpine.DEB.2.21.2103091700320.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103091707380.33195@angie.orcam.me.uk>
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
 include/uapi/linux/if_fddi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-defxx/include/uapi/linux/if_fddi.h
===================================================================
--- linux-defxx.orig/include/uapi/linux/if_fddi.h
+++ linux-defxx/include/uapi/linux/if_fddi.h
@@ -9,7 +9,7 @@
  * Version:	@(#)if_fddi.h	1.0.3	Oct  6 2018
  *
  * Author:	Lawrence V. Stefani, <stefani@yahoo.com>
- * Maintainer:	Maciej W. Rozycki, <macro@linux-mips.org>
+ * Maintainer:	Maciej W. Rozycki, <macro@orcam.me.uk>
  *
  *		if_fddi.h is based on previous if_ether.h and if_tr.h work by
  *			Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
