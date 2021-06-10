Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849A33A2CAE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhFJNS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:18:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3836 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFJNSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:18:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G14BV6cLtzWqfk;
        Thu, 10 Jun 2021 21:12:02 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 21:16:56 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 21:16:55 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <dccp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>
Subject: [PATCH -next] dccp: tfrc: fix doc warnings in tfrc_equation.c
Date:   Thu, 10 Jun 2021 21:26:03 +0800
Message-ID: <20210610132603.597563-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for `tfrc_invert_loss_event_rate` to fix the W=1 warnings:

 net/dccp/ccids/lib/tfrc_equation.c:695: warning: Function parameter or
  member 'loss_event_rate' not described in 'tfrc_invert_loss_event_rate'

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 net/dccp/ccids/lib/tfrc_equation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dccp/ccids/lib/tfrc_equation.c b/net/dccp/ccids/lib/tfrc_equation.c
index e2a337fa9ff7..92a8c6bea316 100644
--- a/net/dccp/ccids/lib/tfrc_equation.c
+++ b/net/dccp/ccids/lib/tfrc_equation.c
@@ -688,6 +688,7 @@ u32 tfrc_calc_x_reverse_lookup(u32 fvalue)
 
 /**
  * tfrc_invert_loss_event_rate  -  Compute p so that 10^6 corresponds to 100%
+ * @loss_event_rate: loss event rate to invert
  * When @loss_event_rate is large, there is a chance that p is truncated to 0.
  * To avoid re-entering slow-start in that case, we set p = TFRC_SMALLEST_P > 0.
  */
-- 
2.31.1

