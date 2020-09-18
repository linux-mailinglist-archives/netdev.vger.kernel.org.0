Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA0B26F52E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIREff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIREfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADEEC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gB/FzQUn7NkoikMzWvcq9WuphZuN+bESrr61/GaQVAs=; b=YY2EhuI1NLnMwOONag2YE+Wp3A
        uMMeYqIa0OPU17GaVAS9LaS33V5zOKtT0zl7BUMxViFLRd75ee3fEoBOsPQ9PBvyYcsQ+1mI9t7Iy
        3/lmYr5gymUkSfHd2rhG70jyj//i72oNZ6HaoutryqutpNJN2+vzgSY3cBFRReJl9bUSVDfWYjknG
        aLJzrGuJiGJ+0U/azcYBqKiQQ4MXln58ILEN0sgOGVXjll7F57lxNCcN1XyPJgopw5YvmN3kjCDy6
        Yx9X177Ac9Pj+OwZ0XalkSnwoQr8OlucEAsjnTcllWfzdS2o1CIwy31rWxOEJGaYEzIp9WEQzZyBF
        9q4++9Ig==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87P-0003Ci-RF; Fri, 18 Sep 2020 04:35:32 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/7 net-next] net: ipv6: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:17 -0700
Message-Id: <20200918043521.17346-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/ipv6/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ip6_output.c |    2 +-
 net/ipv6/tcp_ipv6.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/ipv6/ip6_output.c
+++ linux-next-20200917/net/ipv6/ip6_output.c
@@ -1492,7 +1492,7 @@ emsgsize:
 	 * Otherwise, we need to reserve fragment header and
 	 * fragment alignment (= 8-15 octects, in total).
 	 *
-	 * Note that we may need to "move" the data from the tail of
+	 * Note that we may need to "move" the data from the tail
 	 * of the buffer to the new fragment when we split
 	 * the message.
 	 *
--- linux-next-20200917.orig/net/ipv6/tcp_ipv6.c
+++ linux-next-20200917/net/ipv6/tcp_ipv6.c
@@ -458,7 +458,7 @@ static int tcp_v6_err(struct sk_buff *sk
 	case TCP_SYN_SENT:
 	case TCP_SYN_RECV:
 		/* Only in fast or simultaneous open. If a fast open socket is
-		 * is already accepted it is treated as a connected one below.
+		 * already accepted it is treated as a connected one below.
 		 */
 		if (fastopen && !fastopen->sk)
 			break;
