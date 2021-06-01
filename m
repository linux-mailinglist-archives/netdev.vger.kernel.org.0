Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB03974D7
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhFAOEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:04:16 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6119 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhFAOEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:04:15 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvYgm0vwlzYpfx;
        Tue,  1 Jun 2021 21:59:48 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:02:30 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] macvlan: Fix a typo
Date:   Tue, 1 Jun 2021 22:16:10 +0800
Message-ID: <20210601141610.4131373-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

underlaying  ==> underlying

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1b998aa481f8..80de9768ecd4 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1781,7 +1781,7 @@ static int macvlan_device_event(struct notifier_block *unused,
 		unregister_netdevice_many(&list_kill);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
-		/* Forbid underlaying device to change its type. */
+		/* Forbid underlying device to change its type. */
 		return NOTIFY_BAD;
 
 	case NETDEV_NOTIFY_PEERS:
-- 
2.25.1

