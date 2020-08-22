Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FE124EA4C
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgHVXQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgHVXQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0ECC061573;
        Sat, 22 Aug 2020 16:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=5vreDZpe3vF5j4MRs+/BjxZJW2uGIU7+S7gFV4WuKQg=; b=tBJsruhYaB6qg1GO0tMx/useVk
        01MAAbVN3bNrmvfJovfEnOkkLbA88Aw4PFEsaZUGtf2I9SN8F6JQoGegNeChsRnJDbaXzncnUKwKF
        LUDOUeZUOC8mAFQS2YkZne00/6JHk9j5EL7AbleCnEe5B5BhPmxdLjkEMhOa7eZthKmDGgPJMQlKD
        vxy3deC0oSf9g5skcZaGwsbcKcGfAyQER7uNaEdLriwPWomgL2a7cjpuwFU3GHFtdVSjmbFAK/dDT
        zbfdjWnG+nKrOrTItqQxciWwOyZt70F4WFusdcIe5GwfNOhDfcihzPw6D8kfbWlxOUoCahVnjtP9r
        cvHhtblw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ck8-0006VD-3w; Sat, 22 Aug 2020 23:16:12 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/7] net: sctp: auth.c: delete duplicated words
Date:   Sat, 22 Aug 2020 16:15:56 -0700
Message-Id: <20200822231601.32125-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "the" and "now".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/auth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/sctp/auth.c
+++ linux-next-20200731/net/sctp/auth.c
@@ -445,7 +445,7 @@ struct sctp_shared_key *sctp_auth_get_sh
 }
 
 /*
- * Initialize all the possible digest transforms that we can use.  Right now
+ * Initialize all the possible digest transforms that we can use.  Right
  * now, the supported digests are SHA1 and SHA256.  We do this here once
  * because of the restrictiong that transforms may only be allocated in
  * user context.  This forces us to pre-allocated all possible transforms
@@ -810,7 +810,7 @@ int sctp_auth_ep_set_hmacs(struct sctp_e
 }
 
 /* Set a new shared key on either endpoint or association.  If the
- * the key with a same ID already exists, replace the key (remove the
+ * key with a same ID already exists, replace the key (remove the
  * old key and add a new one).
  */
 int sctp_auth_set_key(struct sctp_endpoint *ep,
