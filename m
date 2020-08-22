Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05324EA3F
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgHVXNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgHVXNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:13:50 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC47C061575
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6iPn1VUo19LSSYj6bSZnvl+VseqjiVxzX1FEi/rV9hI=; b=SMwGI9VWkqMet8j6aOzjUg2G6z
        Cv4vJ9nO2zf2CRsXmbCa6xGFeCyJ/RYpLbhkNPR8p0ShDd2uZ6zRWQTQ2jQyDhGyhjo7o8W77zoyi
        A+KQz0OCaoySjvSx+aUv/0G5VCtLizpE9Yo7dKDi6itfoBif/Er9JdF5okvR0VqXedoHsn2Gep5Pb
        I8bvLpiAPoYnHDbct4I4jcmZ1UfCQhLCw+EeJjWbYKcvCdwwYEUaDqtcKoGUlhuDs6cS+KcfYVRjj
        GA8P+4w+htzZ2Xbf3Ey9u1RaSmBdZYjQztEX9nRhpQ5tIjrZQqSNXduz5rpW0RkQg23tpZNTpNPdz
        NasgSdfQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9chn-0006Nf-GC; Sat, 22 Aug 2020 23:13:48 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/8] net: batman-adv: fragmentation.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:13:29 -0700
Message-Id: <20200822231335.31304-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "not".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/batman-adv/fragmentation.c
+++ linux-next-20200731/net/batman-adv/fragmentation.c
@@ -306,7 +306,7 @@ free:
  * set *skb to merged packet; 2) Packet is buffered: Return true and set *skb
  * to NULL; 3) Error: Return false and free skb.
  *
- * Return: true when the packet is merged or buffered, false when skb is not not
+ * Return: true when the packet is merged or buffered, false when skb is not
  * used.
  */
 bool batadv_frag_skb_buffer(struct sk_buff **skb,
