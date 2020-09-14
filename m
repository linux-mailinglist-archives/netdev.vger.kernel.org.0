Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DEE2693A4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgINRiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:38:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726086AbgINM1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 08:27:04 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D6B8983436F9BA79B2F3;
        Mon, 14 Sep 2020 20:09:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 20:09:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/6] net: hns3: updates for -next
Date:   Mon, 14 Sep 2020 20:06:51 +0800
Message-ID: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
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

Yunsheng Lin (6):
  net: hns3: batch the page reference count updates
  net: hns3: batch tx doorbell operation
  net: hns3: optimize the tx clean process
  net: hns3: optimize the rx clean process
  net: hns3: use writel() to optimize the barrier operation
  net: hns3: use napi_consume_skb() when cleaning tx desc

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 225 ++++++++++++---------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  20 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   8 +-
 3 files changed, 141 insertions(+), 112 deletions(-)

-- 
2.7.4

