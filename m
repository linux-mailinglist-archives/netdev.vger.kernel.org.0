Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A926E10472
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfEAESD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfEAESC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j/zA/r05fvJFmzAUwDp4XThm0N0tDJJN2D6Da0pFCUU=; b=DMDc2wyPf+w8ZrvfoNBqGh95V
        CcYKJ6ZwLjFGGOe+sZa+MOdkO5pb0JBVc8CpsGIJ+j9yOIJaY5AMJ1P4OXvZoqqKSkrxL/zd1OY9W
        SLzu2FxLWJtGYwV0sPRuDStDxvu/5DqtJBBNZntrO2GY9KcAMdawFP8D9bfOxCmqYhNxAeH0XaS3P
        1I8daSsxY8KF15edSCVg2pcb8Z9nW2FMt9ojIc4sgt748afCkiymwgeNJMO20qRTw7wroUoxls9MZ
        dIrgaXcdFSUqnNRQSNGBDCmC/OQKS3fWVOiupxaY2q07whjyjfIEbHLYH94nqQaTPX5ewGprpbQIz
        mTD7HYdFg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggz-0002GP-5J; Wed, 01 May 2019 04:18:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 2/5] net: Reorder the contents of skb_frag_t
Date:   Tue, 30 Apr 2019 21:17:54 -0700
Message-Id: <20190501041757.8647-4-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
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

