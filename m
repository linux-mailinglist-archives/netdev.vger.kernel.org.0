Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDE51B1C68
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgDUDKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:10:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbgDUDKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 23:10:32 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFB5FF6C1523A0C6D6D6;
        Tue, 21 Apr 2020 11:10:27 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Apr 2020
 11:10:17 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ila: remove unused macro 'ILA_HASH_TABLE_SIZE'
Date:   Tue, 21 Apr 2020 11:09:12 +0800
Message-ID: <20200421030912.37200-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ipv6/ila/ila_xlat.c:604:0: warning: macro "ILA_HASH_TABLE_SIZE" is not used [-Wunused-macros]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv6/ila/ila_xlat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 5fc1f4e0c0cf..a1ac0e3d8c60 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -601,8 +601,6 @@ int ila_xlat_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return ret;
 }
 
-#define ILA_HASH_TABLE_SIZE 1024
-
 int ila_xlat_init_net(struct net *net)
 {
 	struct ila_net *ilan = net_generic(net, ila_net_id);
-- 
2.17.1


