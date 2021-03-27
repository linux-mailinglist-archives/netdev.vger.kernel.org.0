Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1582234B564
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhC0IOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14930 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhC0IOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:40 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6s5x5BbBzkl3F;
        Sat, 27 Mar 2021 16:12:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:25 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 9/9] NFC: digital: Correct function name in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:56 +0800
Message-ID: <20210327081556.113140-10-wangxiongfeng2@huawei.com>
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

 net/nfc/digital_core.c:473: warning: expecting prototype for start_poll operation(). Prototype was for digital_start_poll() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/nfc/digital_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index da7e2112771f..5044c7db577e 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -457,7 +457,7 @@ static void digital_add_poll_tech(struct nfc_digital_dev *ddev, u8 rf_tech,
 }
 
 /**
- * start_poll operation
+ * digital_start_poll - start_poll operation
  * @nfc_dev: device to be polled
  * @im_protocols: bitset of nfc initiator protocols to be used for polling
  * @tm_protocols: bitset of nfc transport protocols to be used for polling
-- 
2.20.1

