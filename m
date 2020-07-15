Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A962202AE
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgGODAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgGOC7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89157C061755;
        Tue, 14 Jul 2020 19:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=W/B61cOJYb0POMx4LztB+iLmTvf0xZh5bSsz8ys92To=; b=oxbQZPk68GaBZf1tvrSWwaSbC+
        fyOn/QhwsPSM+ItumIfe9kBzjnjH+Adx2Ug3y2mTqyHWXnor1FZzp+7nEo4Z9vJRFfOXPHa191PeP
        J4zCHzQzlnJ3ivxj1UuJOIF8WAzoS8s4kGMTTQC03shX6rfu4wdU5SuSPHKXeFE43MCWdvWuW6Tgd
        z0O0IAl2E5PVDRb+29EgAB4gDfEIFwt1bQsGWQHNTeMonwRCwPqSLVV6KJC1zYrCIow5xq8m/YeM7
        IpgpRFsfXzNkA7mtZwHv1RACjydX5dwZIh+AH51A62Kvl6OzDhpmU5A0rCb7Vc8eFUX5uo53UnpK6
        Yk8+FMrA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdp-0001FT-ML; Wed, 15 Jul 2020 02:59:30 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 06/13 net-next] net: 9p: drop duplicate word in comment
Date:   Tue, 14 Jul 2020 19:59:07 -0700
Message-Id: <20200715025914.28091-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "not" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/9p/transport.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/net/9p/transport.h
+++ linux-next-20200714/include/net/9p/transport.h
@@ -25,7 +25,7 @@
  * @request: member function to issue a request to the transport
  * @cancel: member function to cancel a request (if it hasn't been sent)
  * @cancelled: member function to notify that a cancelled request will not
- *             not receive a reply
+ *             receive a reply
  *
  * This is the basic API for a transport module which is registered by the
  * transport module with the 9P core network module and used by the client
