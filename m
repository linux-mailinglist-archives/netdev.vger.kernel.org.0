Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41E27C15E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgI2Jew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:34:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14771 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727819AbgI2Jew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:52 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 98115AD9875CEAF75CE3;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Tue, 29 Sep 2020 17:31:58 +0800
Message-ID: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some misc updates for the HNS3 ethernet driver.
#1 uses the queried BD number as the limit for TSO.
#2 renames trace event hns3_over_8bd since #1.
#3 adds UDP segmentation offload support.
#4 adds RoCE VF reset support.
#5 is a minor cleanup.
#6 & #7 add debugfs for device specifications and TQP enable status.

Guangbin Huang (2):
  net: hns3: debugfs add new command to query device specifications
  net: hns3: dump tqp enable status in debugfs

Guojia Liao (1):
  net: hns3: remove unused code in hns3_self_test()

Huazhong Tan (4):
  net: hns3: replace macro HNS3_MAX_NON_TSO_BD_NUM
  net: hns3: rename trace event hns3_over_8bd
  net: hns3: add UDP segmentation offload support
  net: hns3: Add RoCE VF reset support

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 50 ++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 71 ++++++++++++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  8 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  9 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h   |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 50 +++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 8 files changed, 157 insertions(+), 37 deletions(-)

-- 
2.7.4

