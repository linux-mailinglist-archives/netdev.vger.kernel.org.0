Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DD51E3447
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgE0BBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:01:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5339 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbgE0BAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:00:44 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D10635346B3F8AB462B2;
        Wed, 27 May 2020 09:00:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 09:00:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/4] net: hns3: misc updates for -next
Date:   Wed, 27 May 2020 08:59:13 +0800
Message-ID: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
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

#1 adds a resetting check in hclgevf_init_nic_client_instance().
#2 adds a preparatory work for RMDA VF's driver.
#3 removes some unnecessary operations in app loopback.
#4 adds an error log for debugging.

Change log:
V1->V2: removes previous patch#1 which may needs further discussion.

Guangbin Huang (1):
  net: hns3: add a resetting check in hclgevf_init_nic_client_instance()

Huazhong Tan (1):
  net: hns3: add a print for initializing CMDQ when reset pending

Yufeng Mo (2):
  net: hns3: change the order of reinitializing RoCE and NIC client
    during reset
  net: hns3: remove unnecessary MAC enable in app loopback

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 11 ++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |  9 +++++++++
 3 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.7.4

