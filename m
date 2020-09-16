Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B526C0BE
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgIPJg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:36:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53844 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbgIPJgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:36:51 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D7EE63535BF70C1C1A7;
        Wed, 16 Sep 2020 17:36:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 16 Sep 2020 17:36:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <saeed@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/6] net: hns3: updates for -next
Date:   Wed, 16 Sep 2020 17:33:44 +0800
Message-ID: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some optimizations related to IO path.

Change since V1:
- fixes a unsuitable handling in hns3_lb_clear_tx_ring() of #6 which
  pointed out by Saeed Mahameed.

previous version:
V1: https://patchwork.ozlabs.org/project/netdev/cover/1600085217-26245-1-git-send-email-tanhuazhong@huawei.com/

Yunsheng Lin (6):
  net: hns3: batch the page reference count updates
  net: hns3: batch tx doorbell operation
  net: hns3: optimize the tx clean process
  net: hns3: optimize the rx clean process
  net: hns3: use writel() to optimize the barrier operation
  net: hns3: use napi_consume_skb() when cleaning tx desc

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 225 ++++++++++++---------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  20 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 3 files changed, 140 insertions(+), 111 deletions(-)

-- 
2.7.4

