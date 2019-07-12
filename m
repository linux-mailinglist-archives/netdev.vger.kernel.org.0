Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA3B6705A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfGLNnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:43:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbfGLNnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NObK792DRogfq6NYIsYP8xp6bAmUu/ANqQyGN3l9BqU=; b=JkBoJFJa2EXDBe9/OWQ83i4kos
        gr9mfYbLeFsgUU7AB6NGK+dbtl+G59sjzaJ7LKuS5jTOQZTz6x7CHB1wM6UFQXeIgOU/Id4Sx4UnV
        0wNoXOjq5EyYOImsMrJhfXR4a8HMousZENsBUXWrYdDiFd6CEVLExvj+mf62FDq2uPu73T+RBno+o
        Siqz2EKhqc2bnWqABUE3Pum9oNDMNHDy1fRPLZVYfVdm2TCqqsE4f9Pxabc3QYRArEwEIcFDfTHsn
        t2nHz5ucbkbCKriy7UYN6C1nerD2iDAU7nu1ZA5fibb6Hv1yvuqTWs//h7JpwsK1PL55ejmeFw2ee
        GxmNfHNg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlvpz-0005A0-J2; Fri, 12 Jul 2019 13:43:47 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Date:   Fri, 12 Jul 2019 06:43:42 -0700
Message-Id: <20190712134345.19767-5-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712134345.19767-1-willy@infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 7910935410e6..b9dc8b4f24b1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -314,8 +314,8 @@ struct skb_frag_struct {
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

