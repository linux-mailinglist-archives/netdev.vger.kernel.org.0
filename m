Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C107347170
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 07:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhCXGNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 02:13:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14137 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhCXGNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 02:13:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F4yYJ0xPPz19Gq5;
        Wed, 24 Mar 2021 14:11:32 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 14:13:26 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/tls: Fix a typo in tls_device.c
Date:   Wed, 24 Mar 2021 14:16:22 +0800
Message-ID: <20210324061622.8665-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/beggining/beginning/

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f7fb7d2c1de1..89a5d4fad0a2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -601,7 +601,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 	if (!info ||
 	    before(seq, info->end_seq - info->len)) {
 		/* if retransmit_hint is irrelevant start
-		 * from the beggining of the list
+		 * from the beginning of the list
 		 */
 		info = list_first_entry_or_null(&context->records_list,
 						struct tls_record_info, list);
-- 
2.17.1

