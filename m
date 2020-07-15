Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0482202A3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgGOC7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgGOC7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEE3C061755;
        Tue, 14 Jul 2020 19:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oWtBgR/0I5e80OZnIIeE08bwhyK5/nQjTF5g2GYsdMA=; b=fLRh+FtPk1Q73RzpR9GLb0rlkD
        Mm3UkxhJKjNlcSt3xot1SktSYLtNmLHOHGevwbbMGyUT3enW5oYpv3IcOCCveTNdiK8AHxzwM7Uk9
        T4L4SCpI8nWaVLBP+Qw5kzDJHgxMdaFyE23cRQyvFKQb3cgevuJc9APCcatubst4HQbIJx6BqdCvs
        DikKV5aa3YatNh18kpTKz4FoptVa4GuiUuF1+S1Kr89X9o1nqlObWOKjj9YPQcbn/KXh3CgWmUODb
        1xBF6gDCfTOZg/X8qExb7NemRKUaO0mB4uFaDpBWD2J/+Tq5dgUXYEFDb7TItMwDoDw3O+NNXsjNa
        sMStIHOg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXe0-0001FT-DL; Wed, 15 Jul 2020 02:59:41 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/13 net-next] net: mac80211.h: drop duplicate words in comments
Date:   Tue, 14 Jul 2020 19:59:12 -0700
Message-Id: <20200715025914.28091-11-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words "are" and "by" in comments.
Change doubled "to to" to "to the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/mac80211.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200714.orig/include/net/mac80211.h
+++ linux-next-20200714/include/net/mac80211.h
@@ -2727,7 +2727,7 @@ void ieee80211_free_txskb(struct ieee802
  * for devices that support offload of data packets (e.g. ARP responses).
  *
  * Mac80211 drivers should set the @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 flag
- * when they are able to replace in-use PTK keys according to to following
+ * when they are able to replace in-use PTK keys according to the following
  * requirements:
  * 1) They do not hand over frames decrypted with the old key to
       mac80211 once the call to set_key() with command %DISABLE_KEY has been
@@ -4709,7 +4709,7 @@ void ieee80211_tx_status_irqsafe(struct
  *
  * Call this function for all transmitted data frames after their transmit
  * completion. This callback should only be called for data frames which
- * are are using driver's (or hardware's) offload capability of encap/decap
+ * are using driver's (or hardware's) offload capability of encap/decap
  * 802.11 frames.
  *
  * This function may not be called in IRQ context. Calls to this function
@@ -6344,7 +6344,7 @@ void ieee80211_unreserve_tid(struct ieee
  *
  * Note that this must be called in an rcu_read_lock() critical section,
  * which can only be released after the SKB was handled. Some pointers in
- * skb->cb, e.g. the key pointer, are protected by by RCU and thus the
+ * skb->cb, e.g. the key pointer, are protected by RCU and thus the
  * critical section must persist not just for the duration of this call
  * but for the duration of the frame handling.
  * However, also note that while in the wake_tx_queue() method,
