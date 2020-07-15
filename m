Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C304C2212D7
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGOQnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgGOQmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:42:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D6C08C5DB;
        Wed, 15 Jul 2020 09:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DOJlt9WwfqvtxRtQsVD4HWEtnnEyii8gz7SD33MqTBM=; b=OPihS1FnhrhLYvowRAiFznnovY
        0wQD938emlP8/LoTHLK7SiJGGLbcCRwsfOdhQGu90L7/5i3r2V/oWc9FBPVG/R0kU39qfIdDjZkF1
        kINffO+FPgycao/YhqbxefX3ksmLEh1FCmOBKBuG7nRqTcCiFqGU1tWPzulGiuvzlveAQPUZJ5uEo
        hUpaxhjj8zNI1VQZk4olLl6kajDteU5DSsKYhObErzdgZDZbHTQr4+TC6VvwrXCFUx7etA1nuzeCK
        ARIiBN9v9kgAIBcYGp6j8DxTHohceDR1dQMfSzC35xx44TYcEXhsfjayNWjb+g5UeV6/Gh+kG3ftT
        Tyb4uRJQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUe-0000Bh-Pn; Wed, 15 Jul 2020 16:42:53 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 2/9 v2 net-next] net: skbuff.h: drop duplicate words in comments
Date:   Wed, 15 Jul 2020 09:42:39 -0700
Message-Id: <20200715164246.9054-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words in several comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series.

 include/linux/skbuff.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200714.orig/include/linux/skbuff.h
+++ linux-next-20200714/include/linux/skbuff.h
@@ -1329,7 +1329,7 @@ void skb_flow_dissect_meta(const struct
 			   void *target_container);
 
 /* Gets a skb connection tracking info, ctinfo map should be a
- * a map of mapsize to translate enum ip_conntrack_info states
+ * map of mapsize to translate enum ip_conntrack_info states
  * to user states.
  */
 void
@@ -3813,7 +3813,7 @@ static inline bool skb_defer_rx_timestam
  * must call this function to return the skb back to the stack with a
  * timestamp.
  *
- * @skb: clone of the the original outgoing packet
+ * @skb: clone of the original outgoing packet
  * @hwtstamps: hardware time stamps
  *
  */
