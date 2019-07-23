Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC970F8B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfGWDIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730004AbfGWDIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NObK792DRogfq6NYIsYP8xp6bAmUu/ANqQyGN3l9BqU=; b=cMrd90EfhWk//i0kVVobGM133y
        bbpf9sSggPk/AxqBxGAVGKgYXaqfJf6grbl7ZxTccR57CjYkSai4Pg/4RHVo97pYPe2RssrCO2Odr
        aK48iKDSTMfqxMXAr7zrpVinTZ+6cnLED2B3EKmT/S7WdVNql/Ep7g39bkEYt0+uLI6jbeFBV4D71
        JyfMSUQGDjwsOGMvn+RkQrmX092J68ubLHWfBCn9dB+2CBwSw06FjQPPEGjJQLidwq+d3uYh+RhNa
        RdvZkxfkixHYqIup6Uypw0JUbkC+xrb6df1aQToLdZgWVz8cqfmx+8H7sAEebq0HXRiCRiWcdUBPI
        DoF65fLw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036o-G2; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Date:   Mon, 22 Jul 2019 20:08:28 -0700
Message-Id: <20190723030831.11879-5-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
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

