Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972C82212CF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGOQpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgGOQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEFDC061755;
        Wed, 15 Jul 2020 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=R8L7E9J17oJBVxDMTdXtIBtl2fG+b8RvtCrZeriXTcw=; b=k32+E9Abyo4aSq4c/sp+1T4nlk
        ZATy3+MOMQ9tsCp3/UCEyLvje82HBVMtIrheFZgcn3uvik2DI91r2QigM8p3Nnd56MooyHm6DVIb3
        iyEP99KmVFqEqnCZHtYCYpDAbXv0CKWOEFLRtzdET1l/EHb/up/v2jltVuj5oM5v6y3Takc66bqDo
        +fFt0leUQ2HFQ/y2OzOiJB3dEQx3NjQ/4Mv3wbpgbvxH5+4DQgETXNor348H4WUM9XjwzvKyzoEBk
        v+I4as8b5zhq3c/Edonu9P6U3jnCXd2HRhf/mNexe3glxHUB5nz1fEqWR9DjqFXefbfbYJcP/VNjq
        lJisNPxQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkVJ-0000EP-Tc; Wed, 15 Jul 2020 16:43:34 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/5 -next] net/wireless: mac80211.h: drop duplicate words in comments
Date:   Wed, 15 Jul 2020 09:43:24 -0700
Message-Id: <20200715164325.9109-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164325.9109-1-rdunlap@infradead.org>
References: <20200715164325.9109-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words "are" and "by" in comments.
Change doubled "to to" to "to the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
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
