Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F0C34B560
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhC0IOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15068 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhC0IOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6s5W0sRMz1BFZC;
        Sat, 27 Mar 2021 16:12:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:21 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 4/9] net: core: Correct function name netevent_unregister_notifier() in the kerneldoc
Date:   Sat, 27 Mar 2021 16:15:51 +0800
Message-ID: <20210327081556.113140-5-wangxiongfeng2@huawei.com>
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

 net/core/netevent.c:45: warning: expecting prototype for netevent_unregister_notifier(). Prototype was for unregister_netevent_notifier() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/core/netevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netevent.c b/net/core/netevent.c
index d76ed7739c70..5bb615e963cc 100644
--- a/net/core/netevent.c
+++ b/net/core/netevent.c
@@ -32,7 +32,7 @@ int register_netevent_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(register_netevent_notifier);
 
 /**
- *	netevent_unregister_notifier - unregister a netevent notifier block
+ *	unregister_netevent_notifier - unregister a netevent notifier block
  *	@nb: notifier
  *
  *	Unregister a notifier previously registered by
-- 
2.20.1

