Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F530AE06B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbfIIVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 17:54:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfIIVyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 17:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hXIY7px3ZKe6sRB6WWdkAcDOx60D4yEzbgEBBpLOhjQ=; b=TWNtgAiFyO20FlUIlofYi2Ofi
        eEiGu1Kt34gUNCT1FJhOVTrchXEZnJU+OGgyRtD2VkFno8A4oeEy/uqHP5guQEBFx8xcEwAt5mj2j
        4XRf+FfpS/be4G0SUXzOW2L/pMUDwFYGE83cT9LQPMQXdUzxkWplYTqEX5u03WWkVxklNSCQqzhwX
        gb1QYneJT2hYDKE1V52Y+A1NuFj7gN+kxc5YZnV4QcWy2EWRIxe1HX4nH9kGyoxS8tKnQnKRFF5sZ
        ZBWey8PSB3EJB0hyT/MMpJzGS2TIfgFWli83vRba5Vmu2sF6wTrDHHKNGpukEpuzkjRd1sIBnlBkC
        bfbkDtT4w==;
Received: from c-73-157-219-8.hsd1.or.comcast.net ([73.157.219.8] helo=[10.0.0.252])
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i7Rc6-0003DB-9N; Mon, 09 Sep 2019 21:54:22 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] lib/Kconfig: fix OBJAGG in lib/ menu structure
Message-ID: <34674398-54dc-a4d1-6052-67ad1a3b2fe9@infradead.org>
Date:   Mon, 9 Sep 2019 14:54:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Keep the "Library routines" menu intact by moving OBJAGG into it.
Otherwise OBJAGG is displayed/presented as an orphan in the
various config menus.

Fixes: 0a020d416d0a ("lib: introduce initial implementation of object aggregation manager")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: David S. Miller <davem@davemloft.net>
---
 lib/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20190904.orig/lib/Kconfig
+++ linux-next-20190904/lib/Kconfig
@@ -631,6 +631,9 @@ config SBITMAP
 config PARMAN
 	tristate "parman" if COMPILE_TEST
 
+config OBJAGG
+	tristate "objagg" if COMPILE_TEST
+
 config STRING_SELFTEST
 	tristate "Test string functions"
 
@@ -653,6 +656,3 @@ config GENERIC_LIB_CMPDI2
 
 config GENERIC_LIB_UCMPDI2
 	bool
-
-config OBJAGG
-	tristate "objagg" if COMPILE_TEST

