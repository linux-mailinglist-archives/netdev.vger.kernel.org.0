Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D29FA04DB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfH1OZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:25:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5233 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfH1OZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:39 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1C7947BC4F351F1B1D10;
        Wed, 28 Aug 2019 22:25:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: add some cleanups and optimizations
Date:   Wed, 28 Aug 2019 22:23:04 +0800
Message-ID: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes cleanups, optimizations and bugfix for
the HNS3 ethernet controller driver.

[patch 01/12] adds code optimization for debugfs command "dump reg".

[patch 02/12] fixes magic number issues.

[patch 03/12] modifies some parameters about hclge_dbg_dump_tm_map().

[patch 04/12] removes some unused parameters.

[patch 05/12] refactors some logs to make them more readable.

[patch 06/12] makes some resusable codes into functions.

[patch 07/12] fixes some type errors.

[patch 08/12] reduces the waiting time for per TQP reset.

[patch 09/12] implements .process_hw_error for hns3 client.

[patch 10/12] adds phy selftest for HNS3 driver.

[patch 11/12] adds checking for reset interrupt status when reset fails.

[patch 12/12] prevents SSU loopback when running ethtool -t.

Guojia Liao (2):
  net: hns3: reduce the parameters of some functions
  net: hns3: fix incorrect type in assignment.

Huazhong Tan (3):
  net: hns3: use macro instead of magic number
  net: hns3: modify base parameter of kstrtouint in
    hclge_dbg_dump_tm_map
  net: hns3: check reset interrupt status when reset fails

Weihang Li (1):
  net: hns3: implement .process_hw_error for hns3 client

Yonglong Liu (1):
  net: hns3: make some reusable codes into a function

Yufeng Mo (3):
  net: hns3: optimize some log printings
  net: hns3: add phy selftest function
  net: hns3: not allow SSU loopback while execute ethtool -t dev

Zhongzhu Liu (2):
  net: hns3: code optimization for debugfs related to "dump reg"
  net: hns3: optimize waiting time for TQP reset

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  25 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  24 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  16 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  28 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  54 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 271 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  19 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  42 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 268 ++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  10 +-
 14 files changed, 546 insertions(+), 235 deletions(-)

-- 
2.7.4

