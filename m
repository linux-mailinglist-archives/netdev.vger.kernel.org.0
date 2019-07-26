Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F346A7707C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 19:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfGZRoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 13:44:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbfGZRoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 13:44:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TxBXv81UXL72jbAW+Nm1r0I2mwSA/z9cyR+T0DYjoA8=; b=a3rGC+Yonf+DsdlVfzEcJ1uKWm
        YIVJR/Q0dfAChwhQDOO5q8sEPI1UftVm5bhISNWhKUGU5zbaanNNWUaRMDfTtrieLstl4+UxKolLn
        AxSnHDCu52RKX0V3pBXc38zaJ0fgWK3lDj36oDg6I5ZEFMBU81ZpSwf0qHhuj4Af76pY1ap7kabsZ
        W9uLhw25CB6Vp2A1DJzRrQ1usfXk3sIGZg7N2ZCAEok/dAW1lmE9G6Q6OBCKMShbhAEDe/cLZpWGW
        8vNcqoXR+KQLGffPDrdLi/c1bta/BPgQbw5qr8AuXTlbHJjngyf/7gkkHqgdBooyK8oSnqu/bdjqq
        ZlVoTC7Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hr4GY-0001nD-Lf; Fri, 26 Jul 2019 17:44:26 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, aaro.koskinen@iki.fi, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: [PATCH 1/2] octeon: Fix typo
Date:   Fri, 26 Jul 2019 10:44:24 -0700
Message-Id: <20190726174425.6845-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190726174425.6845-1-willy@infradead.org>
References: <20190726174425.6845-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Compile fix from skb_frag_t conversion.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 46a6fcf1414d..44f79cd32750 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -284,7 +284,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			hw_buffer.s.addr =
 				XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
-			hw_buffer.s.size = skb_drag_size(fs);
+			hw_buffer.s.size = skb_frag_size(fs);
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
 		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
-- 
2.20.1

