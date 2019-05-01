Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE90C1097D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfEAOpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j/zA/r05fvJFmzAUwDp4XThm0N0tDJJN2D6Da0pFCUU=; b=P5tO4shCIyqkItd3xmgQyRxr7
        fxZ1TPJIsavHu6NcmfNNeWdufYGKTDjJnkKSQecdEmEp4KzpTydfnRWrcWhp6l2hpLbhzkVu6ny3Q
        05oeuflH/BdMqTY9abX8EKft7WiSboAoUgpJxa5oIo2QBST3VsnDY8ChCzVHnc86SlH0p6Rs0FZAX
        8FOkNG+Xald3z6FNxwoVW3oehad4vuu5B0BAtmP0j/ZLW2p3R+PFDYTAsIzh0j/h0MUQOygnS1rxL
        vFmuCS1aOO7DSsI36xM7/LMns2i7z+8XDF3reJ3cokQuLa0DJrR9Iy0rQHM9e5ro4tPZun5sMLs8y
        5780OWgMw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTj-00025T-Mc; Wed, 01 May 2019 14:44:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/7] net: Reorder the contents of skb_frag_t
Date:   Wed,  1 May 2019 07:44:52 -0700
Message-Id: <20190501144457.7942-3-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Match the layout of bio_vec.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 23f05c64aa31..9c6193a57241 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -318,8 +318,8 @@ struct skb_frag_struct {
 	struct {
 		struct page *p;
 	} page;
-	__u32 page_offset;
 	__u32 size;
+	__u32 page_offset;
 };
 
 /**
-- 
2.20.1

