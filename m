Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80A1314B29
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhBIJK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:10:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12154 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhBIJFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:05:10 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZcN81JGLzlHyN;
        Tue,  9 Feb 2021 17:02:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 17:03:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes for -net
Date:   Tue, 9 Feb 2021 17:03:04 +0800
Message-ID: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameters sent from vf may be unreliable. If these
parameters are used directly, memory overwriting may occur.

So this series adds some checks for this case.

Yufeng Mo (3):
  net: hns3: add a check for queue_id in hclge_reset_vf_queue()
  net: hns3: add a check for tqp_index in
    hclge_get_ring_chain_from_mbx()
  net: hns3: add a check for index in hclge_get_rss_key()

 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 ++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 29 +++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

-- 
2.7.4

