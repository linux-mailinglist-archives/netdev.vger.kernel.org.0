Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41850277CEC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIYA3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14277 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbgIYA3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C85CBE201AADD8DA93EB;
        Fri, 25 Sep 2020 08:28:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/6] net: hns3: updates for -next
Date:   Fri, 25 Sep 2020 08:26:12 +0800
Message-ID: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some updates for the HNS3 ethernet driver.
#1 & #2 are two cleanups.
#3 adds new hardware error for the client.
#4 adds debugfs support the pf's interrupt resource.
#5 adds new pci device id for 200G device.
#6 renames the unsuitable macro of vf's pci device id.

Guangbin Huang (2):
  net: hns3: add support for 200G device
  net: hns3: rename macro of pci device id of vf

Yufeng Mo (4):
  net: hns3: refactor the function for dumping tc information in debugfs
  net: hns3: remove unnecessary variable initialization
  net: hns3: add a hardware error detect type
  net: hns3: add debugfs of dumping pf interrupt resources

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  6 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 17 +++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 27 ++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 60 +++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  6 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  7 +--
 11 files changed, 96 insertions(+), 38 deletions(-)

-- 
2.7.4

