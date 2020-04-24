Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93711B7047
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgDXJHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:07:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51426 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgDXJHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:07:04 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 11A9BDC05BA9F8BD9981;
        Fri, 24 Apr 2020 17:07:02 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 17:06:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tom@herbertland.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ipv6: remove unused inline function ip6_set_txhash
Date:   Fri, 24 Apr 2020 17:06:29 +0800
Message-ID: <20200424090629.33840-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/ipv6.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 1bf8065fe871..955badd1e8ff 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -908,7 +908,6 @@ static inline int ip6_default_np_autolabel(struct net *net)
 	}
 }
 #else
-static inline void ip6_set_txhash(struct sock *sk) { }
 static inline __be32 ip6_make_flowlabel(struct net *net, struct sk_buff *skb,
 					__be32 flowlabel, bool autolabel,
 					struct flowi6 *fl6)
-- 
2.17.1


