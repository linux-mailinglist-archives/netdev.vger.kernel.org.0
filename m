Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D242534B561
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhC0IOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14633 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC0IOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6s5W0f6rz1BFYK;
        Sat, 27 Mar 2021 16:12:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:24 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 8/9] ip6_tunnel:: Correct function name parse_tvl_tnl_enc_lim() in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:55 +0800
Message-ID: <20210327081556.113140-9-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following W=1 kernel build warning(s):

 net/ipv6/ip6_tunnel.c:401: warning: expecting prototype for parse_tvl_tnl_enc_lim(). Prototype was for ip6_tnl_parse_tlv_enc_lim() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3fa0eca5a06f..cd78f5b2cd75 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -388,7 +388,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
 }
 
 /**
- * parse_tvl_tnl_enc_lim - handle encapsulation limit option
+ * ip6_tnl_parse_tlv_enc_lim - handle encapsulation limit option
  *   @skb: received socket buffer
  *   @raw: the ICMPv6 error message data
  *
-- 
2.20.1

