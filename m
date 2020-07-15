Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3673E2212BB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgGOQn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgGOQnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1417C061755;
        Wed, 15 Jul 2020 09:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=w7JZTeu1VBjKmQFYJ4UVm6XlML5JSLLBrBKAwYZP1sI=; b=X02g21msjtU7jGCjpEDQiNzSrT
        FJRhv38+J9cMCp7ng59RZkr+tH0CxVIgEacZqXmN99+zowP5jeFQv6RjRuhPwKtFQ6ZeLYvIATMfM
        PZWQBjtGTL738U+QyR7zOubsL5bbfL7ffnvF9A8mq7hL9f7Z15U8bnmluTTq0O/ZGKu/qpxiP9AB/
        pSe4fMUnz1YNijQAROdVn6EjnyNw1B/p3hkb5fAnqSDBPfm7etmvY6NFy1NbqgVbIlLh5GjvsynyT
        dWKOjmtuUbXS/l/oY9O94JhCp8yoMgCYuxwiVeRTFTg8sNq/OMmqaVFmKICNi9w9wrpZiHxCHP+St
        3piHEE0w==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUo-0000Bh-22; Wed, 15 Jul 2020 16:43:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 7/9 v2 net-next] net: ip6_fib.h: drop duplicate word in comment
Date:   Wed, 15 Jul 2020 09:42:44 -0700
Message-Id: <20200715164246.9054-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
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
v2: move wireless patches to a separate patch series.

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
