Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8142914C552
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 05:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA2Ep5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 23:45:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgA2Ep5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 23:45:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RB7MFvDynCTDcWQk8mAdBFKKrkJBxKbDXqcgxHTixUM=; b=UKkHZ/zZvyUOLq14+wpZWR38w
        yhW2iXMLFlqd6x/u0CdSxlIMcDC0FLYGw5zSJpX+liUP6PBPkAqTOaOc6taBy96hIwZwmeoVzDtyw
        7ITrwOTmns/bFGmXftJRtbWdJius7cLzOZjrhlG/Br94kcQEys/cDm1jB+fST68n+VT1fQpsfSm/b
        o0uJjhbncUKqbWmRvlYEAPs08tPFWWRlKkih+l/E1CIOAMqhr+v8IpiESO/67E13nqQ2fn0QwiXw4
        T1bddIyCsrdky3nAGyEuq145Z9uKU6w4svXjcBTCzvfu0Jvi9L0iV4LEXiYxVwiYX7IRx2YD49CkF
        l52+zUTbA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwfEh-0003UC-Kt; Wed, 29 Jan 2020 04:45:56 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org, LKML <linux-kernel@vger.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] MAINTAINERS: mptcp@ mailing list is moderated
Message-ID: <0d3e4e6f-5437-ae85-f1f5-89971ea3423f@infradead.org>
Date:   Tue, 28 Jan 2020 20:45:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Note that mptcp@lists.01.org is moderated, like we note for
other mailing lists.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org
Cc: mptcp@lists.01.org
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2020-0128-2005.orig/MAINTAINERS
+++ mmotm-2020-0128-2005/MAINTAINERS
@@ -11718,7 +11718,7 @@ NETWORKING [MPTCP]
 M:	Mat Martineau <mathew.j.martineau@linux.intel.com>
 M:	Matthieu Baerts <matthieu.baerts@tessares.net>
 L:	netdev@vger.kernel.org
-L:	mptcp@lists.01.org
+L:	mptcp@lists.01.org (moderated for non-subscribers)
 W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 S:	Maintained

