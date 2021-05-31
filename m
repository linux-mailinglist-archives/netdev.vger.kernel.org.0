Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF221395562
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhEaGYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:24:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3301 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhEaGYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:24:46 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FtlTr1Gfsz1BGcK;
        Mon, 31 May 2021 14:18:24 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 14:23:02 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] xprtrdma: Fix spelling mistakes
Date:   Mon, 31 May 2021 14:36:40 +0800
Message-ID: <20210531063640.3018843-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
succes  ==> success

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 5238bc829235..1e651447dc4e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -483,7 +483,7 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
  * @iov: kvec to write
  *
  * Returns:
- *   On succes, returns zero
+ *   On success, returns zero
  *   %-E2BIG if the client-provided Write chunk is too small
  *   %-ENOMEM if a resource has been exhausted
  *   %-EIO if an rdma-rw error occurred
@@ -504,7 +504,7 @@ static int svc_rdma_iov_write(struct svc_rdma_write_info *info,
  * @length: number of bytes to write
  *
  * Returns:
- *   On succes, returns zero
+ *   On success, returns zero
  *   %-E2BIG if the client-provided Write chunk is too small
  *   %-ENOMEM if a resource has been exhausted
  *   %-EIO if an rdma-rw error occurred
@@ -526,7 +526,7 @@ static int svc_rdma_pages_write(struct svc_rdma_write_info *info,
  * @data: pointer to write arguments
  *
  * Returns:
- *   On succes, returns zero
+ *   On success, returns zero
  *   %-E2BIG if the client-provided Write chunk is too small
  *   %-ENOMEM if a resource has been exhausted
  *   %-EIO if an rdma-rw error occurred
-- 
2.25.1

