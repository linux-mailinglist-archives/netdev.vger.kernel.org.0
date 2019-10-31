Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C348EAED3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfJaLW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:22:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5663 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbfJaLW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:22:59 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 07DF3BF0279C04143074;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/9] net: hns3: add some optimizations ane cleanups
Date:   Thu, 31 Oct 2019 19:23:15 +0800
Message-ID: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some code optimizations and cleanups for
the HNS3 ethernet driver.

[patch 1/9] dumps some debug information when reset fail.

[patch 2/9] dumps some struct netdev_queue information when
TX timeout.

[patch 3/9] cleanups some magic numbers.

[patch 4/9] cleanups some coding style issue.

[patch 5/9] fixes a compiler warning.

[patch 6/9] optimizes some local variable initialization.

[patch 7/9] modifies some comments.

[patch 8/9] cleanups some print format warnings.

[patch 9/9] cleanups byte order issue.

Guangbin Huang (3):
  net: hns3: cleanup some coding style issues
  net: hns3: optimize local variable initialization
  net: hns3: add or modify some comments

Guojia Liao (4):
  net: hns3: cleanup some magic numbers
  net: hns3: cleanup a format-truncation warning
  net: hns3: cleanup some print format warning
  net: hns3: cleanup byte order issues when printed

Huazhong Tan (1):
  net: hns3: dump some debug information when reset fail

Yunsheng Lin (1):
  net: hns3: add struct netdev_queue debug info for TX timeout

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  69 +++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  29 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  12 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  30 ++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 109 ++++++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 109 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  15 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  10 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  50 ++++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  18 ++--
 20 files changed, 278 insertions(+), 207 deletions(-)

-- 
2.7.4

