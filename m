Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C3E520A8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 04:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfFYCcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 22:32:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:19103 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfFYCcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 22:32:51 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2EBA02D62198397EADAF;
        Tue, 25 Jun 2019 10:32:48 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 10:32:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <jakub.kicinski@netronome.com>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <xdp-newbies@vger.kernel.org>, <bpf@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] xdp: Make __mem_id_disconnect static
Date:   Tue, 25 Jun 2019 10:31:37 +0800
Message-ID: <20190625023137.29272-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

net/core/xdp.c:88:6: warning:
 symbol '__mem_id_disconnect' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index b29d7b5..829377c 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-bool __mem_id_disconnect(int id, bool force)
+static bool __mem_id_disconnect(int id, bool force)
 {
 	struct xdp_mem_allocator *xa;
 	bool safe_to_remove = true;
-- 
2.7.4


