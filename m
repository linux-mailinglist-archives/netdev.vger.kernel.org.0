Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770B23AF153
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhFURHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhFURHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:07:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E87DC058A43;
        Mon, 21 Jun 2021 09:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0qGNmtTIgq/rOcBlEd0P//rAoggocHQ3X+rJJygyLMA=; b=d1AGeKk96vLuEVV9pYLR97Van/
        ma6v0jfD2vu9x9OzQoJLrnqWyl5jKQlEJU7N3Riywk/SxtV87ouEgujyanJc/VVk+YubW6XzqhWGc
        ArBCbvpS4CPT5xZWpU5PZiC1aU9USbeLnh8JE9jtE4/QR62Hd7fwWUxQPyfinogziyXpeBILrJ992
        p4bNnNfXPsycUbu5OTuIMxOT/pQmLo5ihAlU6v5CAC+kcxBA8/c/QxaHVWcprVnQNReFEUgQQHrYI
        7+cJxZIS21kX/viFvgR40PnzppdtF3PCWDw6z317MNjhtq9QEZ8YzPli3JtSdyJ+t8lxtbeC11RtU
        BqQChFhQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvN6v-00DLT0-NP; Mon, 21 Jun 2021 16:49:30 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] net: Remove mm.h from net.h
Date:   Mon, 21 Jun 2021 17:49:19 +0100
Message-Id: <20210621164920.3180672-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need page_ref.h here (which provides page_count() directly
and PageSlab() by pulling in page-flags.h)

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index ba736b457a06..f54c8f478f3e 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -21,7 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/once.h>
 #include <linux/fs.h>
-#include <linux/mm.h>
+#include <linux/page_ref.h>
 #include <linux/sockptr.h>
 
 #include <uapi/linux/net.h>
-- 
2.30.2

