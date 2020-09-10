Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7069265065
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgIJUQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:16:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731045AbgIJO7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:59:19 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 81FD4D4E96C335395AA9;
        Thu, 10 Sep 2020 22:59:13 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:59:07 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <snelson@pensando.io>,
        <colin.king@canonical.com>, <maz@kernel.org>, <luobin9@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/6] hinic: Fix some kernel-doc warnings in hinic_hw_io.c
Date:   Thu, 10 Sep 2020 22:56:15 +0800
Message-ID: <20200910145620.27470-2-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910145620.27470-1-wanghai38@huawei.com>
References: <20200910145620.27470-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/huawei/hinic/hinic_hw_io.c:373: warning: Excess function parameter 'sq_msix_entry' description in 'hinic_io_create_qps'
drivers/net/ethernet/huawei/hinic/hinic_hw_io.c:373: warning: Excess function parameter 'rq_msix_entry' description in 'hinic_io_create_qps'

Rename these wrong names.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index 6772d8978722..4ef4008e65bd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -363,8 +363,8 @@ static void destroy_qp(struct hinic_func_to_io *func_to_io,
  * @func_to_io: func to io channel that holds the IO components
  * @base_qpn: base qp number
  * @num_qps: number queue pairs to create
- * @sq_msix_entry: msix entries for sq
- * @rq_msix_entry: msix entries for rq
+ * @sq_msix_entries: msix entries for sq
+ * @rq_msix_entries: msix entries for rq
  *
  * Return 0 - Success, negative - Failure
  **/
-- 
2.17.1

