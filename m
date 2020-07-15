Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D982202A8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgGODAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgGOC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306EC061755;
        Tue, 14 Jul 2020 19:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vHOoO7S3a+cewWk/B2hG1cQj/5aDgz+mBDJLY6B+Ie0=; b=cA2mBIrgxSgpXVW4NXDDlZcGNp
        FsUf3VJMlVCExV6qDeczUdekLvA6+ryoLITS31SwkVyIUUdIZlYo+hnHVY9MysL4m5Lq4KC7PhBF1
        G9+ARe4yOvLNuQcdMGHuEKxRGe3/9ri+AqilcFcMlx2GGYEulflSrLaz0lcYdO33B8i2T7G19HxI3
        ni5Dx0Yae5La+BJExNW+mLxhFGgUV0Q3eL/NglDNsRp+/9lzEVl1q7Suceh081OEyxc20L2hq7WSH
        5SY9YIOK4/l22CucpMYkEBeVp7mJUr4WDKWWNAKUFpfJJeypLoHnAxKOjMz5SUSSMLPAkzsVMrpQz
        yLZkptoA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdy-0001FT-Jv; Wed, 15 Jul 2020 02:59:39 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 10/13 net-next] net: ip6_fib.h: drop duplicate word in comment
Date:   Tue, 14 Jul 2020 19:59:11 -0700
Message-Id: <20200715025914.28091-10-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "the" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/ip6_fib.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/net/ip6_fib.h
+++ linux-next-20200714/include/net/ip6_fib.h
@@ -166,7 +166,7 @@ struct fib6_info {
 	struct fib6_node __rcu		*fib6_node;
 
 	/* Multipath routes:
-	 * siblings is a list of fib6_info that have the the same metric/weight,
+	 * siblings is a list of fib6_info that have the same metric/weight,
 	 * destination, but not the same gateway. nsiblings is just a cache
 	 * to speed up lookup.
 	 */
