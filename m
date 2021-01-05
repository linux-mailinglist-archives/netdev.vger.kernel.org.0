Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449DC2EA3F7
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbhAEDix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:38:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9666 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbhAEDiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:38:52 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D8yqJ2d0mz15nyK;
        Tue,  5 Jan 2021 11:37:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 11:38:03 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes for -net
Date:   Tue, 5 Jan 2021 11:37:25 +0800
Message-ID: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some bugfixes for the HNS3 ethernet driver.

Jian Shen (1):
  net: hns3: fix incorrect handling of sctp6 rss tuple

Yonglong Liu (1):
  net: hns3: fix a phy loopback fail issue

Yufeng Mo (1):
  net: hns3: fix the number of queues actually used by ARQ

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h           | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 ++
 5 files changed, 18 insertions(+), 8 deletions(-)

-- 
2.7.4

