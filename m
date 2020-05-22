Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E631DDD6B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgEVCvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:51:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4885 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727080AbgEVCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 22:51:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A8D2C669D7020FC37829;
        Fri, 22 May 2020 10:51:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 22 May 2020 10:51:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: misc updates for -next
Date:   Fri, 22 May 2020 10:49:41 +0800
Message-ID: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes some misc updates for the HNS3 ethernet driver.

#1 adds support for dump VF's mapping of ring and vector, this
   is needed by the hns3 DPDK VF PMD driver.
#2 adds a resetting check in hclgevf_init_nic_client_instance().
#3 adds a preparatory work for RMDA VF's driver.
#4 removes some unnecessary operations in app loopback.
#5 adds an error log for debugging.

Guangbin Huang (2):
  net: hns3: add support for VF to query ring and vector mapping
  net: hns3: add a resetting check in hclgevf_init_nic_client_instance()

Huazhong Tan (1):
  net: hns3: add a print for initializing CMDQ when reset pending

Yufeng Mo (2):
  net: hns3: change the order of reinitializing RoCE and NIC client
    during reset
  net: hns3: remove unnecessary MAC enable in app loopback

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 91 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  9 +++
 5 files changed, 108 insertions(+), 7 deletions(-)

-- 
2.7.4

