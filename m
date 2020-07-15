Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B782212DE
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGOQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgGOQm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:42:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA57C061755;
        Wed, 15 Jul 2020 09:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fSiJgr1JV9rmj2I7yS5Ly08mX0jDScC6AHf8RcMZVBk=; b=Jqcs7C/yo81+mhb+Mpy/cUymG/
        sP5AACKoJt8SyJYyGxCImEKVszxUWv2YELOW5UjptmLNcbp5lKWTLi5LcgUViWplW6kwsX9N3RSaV
        ej6tiNMO186zjzbqUF7WDVH6XzGMKTz12Q8EFW/TUyKNGHf7Fg/1BIeuFKBYvyvh+M+CyOwfhK8oN
        P4h1j35nSUCn7Y+9FF382QteUNcRmcLDCwYstO4lLyAkHC/WluPJlpvlRezoltD6TKbgi5zarp3/1
        8bPasBVHVjVSwdjjefZ8VR0cyxdFKcz83vwo7f9EFEtGXBSBYomM1Lr2sgFHd84hOLWlzYqbni1aV
        sBZHbT7A==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUi-0000Bh-Cc; Wed, 15 Jul 2020 16:42:56 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 4/9 v2 net-next] net: 9p: drop duplicate word in comment
Date:   Wed, 15 Jul 2020 09:42:41 -0700
Message-Id: <20200715164246.9054-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
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
v2: move wireless patches to a separate patch series.

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
