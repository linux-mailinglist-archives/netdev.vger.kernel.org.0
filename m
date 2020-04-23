Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6899A1B5F8C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgDWPjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726109AbgDWPjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:39:05 -0400
X-Greylist: delayed 9392 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Apr 2020 08:39:05 PDT
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56387C09B040
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:39:05 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id A253930A;
        Thu, 23 Apr 2020 15:39:04 +0000 (UTC)
Date:   Thu, 23 Apr 2020 09:39:03 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Alessandro Rubini <rubini@gnu.org>,
        jan.kiszka@siemens.com, ralf@linux-mips.org,
        kstewart@linuxfoundation.org, oliver.fendt@siemens.com
Subject: [PATCH] net: meth: remove spurious copyright text
Message-ID: <20200423093903.171b3999@lwn.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Evidently, at some point in the pre-githistorious past,
drivers/net/ethernet/sgi/meth.h somehow contained some code from the
"snull" driver from the Linux Device Drivers book.  A comment crediting
that source, asserting copyright ownership by the LDD authors, and imposing
the LDD2 license terms was duly added to the file.

Any code that may have been derived from snull is long gone, and the
distribution terms are not GPL-compatible.  Since the copyright claim is
not based in fact (if it ever was), simply remove it and the distribution
terms as well.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Alessandro Rubini <rubini@gnudd.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Kate Stewart <kstewart@linuxfoundation.org>
CC: "Fendt, Oliver" <oliver.fendt@siemens.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/net/ethernet/sgi/meth.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/sgi/meth.h b/drivers/net/ethernet/sgi/meth.h
index 5b145c6bad60..2ba15c263e8b 100644
--- a/drivers/net/ethernet/sgi/meth.h
+++ b/drivers/net/ethernet/sgi/meth.h
@@ -1,19 +1,3 @@
-
-/*
- * snull.h -- definitions for the network module
- *
- * Copyright (C) 2001 Alessandro Rubini and Jonathan Corbet
- * Copyright (C) 2001 O'Reilly & Associates
- *
- * The source code in this file can be freely used, adapted,
- * and redistributed in source or binary form, so long as an
- * acknowledgment appears in derived source files.  The citation
- * should list that the code comes from the book "Linux Device
- * Drivers" by Alessandro Rubini and Jonathan Corbet, published
- * by O'Reilly & Associates.   No warranty is attached;
- * we cannot take responsibility for errors or fitness for use.
- */
-
 /* version dependencies have been confined to a separate file */
 
 /* Tunable parameters */
-- 
2.25.3

