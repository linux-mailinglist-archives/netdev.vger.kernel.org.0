Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7339813D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhFBGmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:42:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3379 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhFBGmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:42:52 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fvzpq62dQz67Lm;
        Wed,  2 Jun 2021 14:37:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:41:06 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] 9p/trans_virtio: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:54:42 +0800
Message-ID: <20210602065442.104765-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reseting  ==> resetting
alloced  ==> allocated
accomodate  ==> accommodate

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/9p/trans_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 93f2f8654882..2bbd7dce0f1d 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -99,7 +99,7 @@ static unsigned int rest_of_page(void *data)
  * @client: client instance
  *
  * This reclaims a channel by freeing its resources and
- * reseting its inuse flag.
+ * resetting its inuse flag.
  *
  */
 
@@ -463,7 +463,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	 * For example TREAD have 11.
 	 * 11 is the read/write header = PDU Header(7) + IO Size (4).
 	 * Arrange in such a way that server places header in the
-	 * alloced memory and payload onto the user buffer.
+	 * allocated memory and payload onto the user buffer.
 	 */
 	in = pack_sg_list(chan->sg, out,
 			  VIRTQUEUE_NUM, req->rc.sdata, in_hdr_len);
@@ -760,7 +760,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	.cancelled = p9_virtio_cancelled,
 	/*
 	 * We leave one entry for input and one entry for response
-	 * headers. We also skip one more entry to accomodate, address
+	 * headers. We also skip one more entry to accommodate, address
 	 * that are not at page boundary, that can result in an extra
 	 * page in zero copy.
 	 */
-- 
2.25.1

