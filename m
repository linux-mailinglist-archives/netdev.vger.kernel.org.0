Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030682BA5C2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgKTJQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8562 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgKTJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:23 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK0Sp9zLqhx;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: misc updates for -next
Date:   Fri, 20 Nov 2020 17:16:18 +0800
Message-ID: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3 ethernet driver.

#1 adds support for 1280 queues
#2 adds mapping for BAR45 which is needed by RoCE client.
#3 extend the interrupt resources.
#4&#5 add support to query firmware's calculated shaping parameters.

Huazhong Tan (1):
  net: hns3: add support for mapping device memory

Yonglong Liu (3):
  net: hns3: add support for 1280 queues
  net: hns3: add support to utilize the firmware calculated shaping
    parameters
  net: hns3: adds debugfs to dump more info of shaping parameters

Yufeng Mo (1):
  net: hns3: add support for pf querying new interrupt resources

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  23 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  48 ++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 160 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  80 ++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  26 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   3 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  49 ++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 11 files changed, 310 insertions(+), 88 deletions(-)

-- 
2.7.4

