Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD65224B18
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGRL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:58:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42386 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbgGRL6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 07:58:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 39BF683B1E412CCBC0D4;
        Sat, 18 Jul 2020 19:58:01 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 19:57:56 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <zorik@amazon.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <sameehj@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] net: ena: use NULL instead of zero
Date:   Sat, 18 Jul 2020 19:56:33 +0800
Message-ID: <20200718115633.37464-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse build warning:

drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
 Using plain integer as NULL pointer

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 91be3ffa1c5c..11303a4b94be 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2190,7 +2190,7 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
 static void ena_init_napi_in_range(struct ena_adapter *adapter,
 				   int first_index, int count)
 {
-	struct ena_napi *napi = {0};
+	struct ena_napi *napi = NULL;
 	int i;
 
 	for (i = first_index; i < first_index + count; i++) {
-- 
2.17.1

