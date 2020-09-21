Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAC6271994
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 05:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIUDaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 23:30:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13781 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgIUD37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 23:29:59 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9B87682B58608BC0DFA1;
        Mon, 21 Sep 2020 11:29:56 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 11:29:50 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ktkhai@virtuozzo.com>,
        <pabeni@redhat.com>, <tklauser@distanz.ch>,
        <steffen.klassert@secunet.com>, <cai@lca.pw>,
        <pankaj.laxminarayan.bharadiya@intel.com>, <arnd@arndb.de>,
        <vcaputo@pengaru.com>, <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] net: unix: remove redundant assignment to variable 'err'
Date:   Mon, 21 Sep 2020 11:29:52 +0800
Message-ID: <20200921032952.99894-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 37ab4fa7844a ("net: unix: allow bind to fail on mutex lock"),
the assignment to err is redundant. So remove it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 net/unix/af_unix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92784e51ee7d..eb82bdc6cf7c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -878,7 +878,6 @@ static int unix_autobind(struct socket *sock)
 	if (err)
 		return err;
 
-	err = 0;
 	if (u->addr)
 		goto out;
 
-- 
2.17.1

