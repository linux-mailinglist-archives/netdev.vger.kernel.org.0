Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0254C26F52A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIREfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIREfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DA3C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=iDJ4MQI7XJgNe78mdSrUPKHjQc6SSBuOEbP/yOGTOrI=; b=GTZVjvT7SDAWXYGSaOCd4grNIj
        bL4wHJ6nnq7e4QrPtXW1mMcd+DQWH95rH1BfbW5Tx6OSbF76qNgHvzUS9ndlpfIHLprVJ8eibmhlz
        IjGpTqiZT3d+1c6yKHHh71yDzR3GTONlBVnshJWjEO5m9NlV7kRDJ0zw1XBD4Akqt+RknJV+6AQxc
        75Ek1spU7V/fNX78KYPlD7d7J2BxMjvta59ebdiLHfqiiscR0jLQ1uMXdQd5KND9r3AMqPlR8kqTz
        cY5d5+Kri865n9l3LhmMFgX3EY4qJYRagmsgUjcT/a+WWzqNCCpAH8EVDqffOcbS+byWdlZCP6ZHo
        XOuzH+Gg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87L-0003Ci-UF; Fri, 18 Sep 2020 04:35:28 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/7 net-next] net: core: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:15 -0700
Message-Id: <20200918043521.17346-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/core/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/core/dev.c
+++ linux-next-20200917/net/core/dev.c
@@ -1131,7 +1131,7 @@ EXPORT_SYMBOL(__dev_get_by_flags);
  *	@name: name string
  *
  *	Network device names need to be valid file names to
- *	to allow sysfs to work.  We also disallow any kind of
+ *	allow sysfs to work.  We also disallow any kind of
  *	whitespace.
  */
 bool dev_valid_name(const char *name)
@@ -9517,7 +9517,7 @@ int __netdev_update_features(struct net_
 	/* driver might be less strict about feature dependencies */
 	features = netdev_fix_features(dev, features);
 
-	/* some features can't be enabled if they're off an an upper device */
+	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
