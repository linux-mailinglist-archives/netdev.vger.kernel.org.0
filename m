Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31EA380273
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhEND0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3670 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhEND0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB3qDTz1BMPy;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: updates for -next
Date:   Fri, 14 May 2021 11:25:08 +0800
Message-ID: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some updates for the HNS3 ethernet driver.
#1&#2 add support for a new RXD advanced layout.
#3~#12 refactor the debugfs procedure and some commands.

Huazhong Tan (4):
  net: hns3: support RXD advanced layout
  net: hns3: refactor out RX completion checksum
  net: hns3: refactor dump bd info of debugfs
  net: hns3: refactor dump mac list of debugfs

Jiaran Zhang (5):
  net: hns3: refactor dev capability and dev spec of debugfs
  net: hns3: refactor dump intr of debugfs
  net: hns3: refactor dump reset info of debugfs
  net: hns3: refactor dump m7 info of debugfs
  net: hns3: refactor dump ncl config of debugfs

Yufeng Mo (3):
  net: hns3: refactor the debugfs process
  net: hns3: refactor dump mng tbl of debugfs
  net: hns3: refactor dump loopback of debugfs

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  28 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 772 +++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  60 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 391 +++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  27 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  11 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 544 +++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  15 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  34 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  17 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 15 files changed, 1428 insertions(+), 486 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h

-- 
2.7.4

