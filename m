Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4167D434
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfHAD5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3725 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbfHAD5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 82FEBD816E9FEF7E7BE7;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: some code optimizations & bugfixes & features
Date:   Thu, 1 Aug 2019 11:55:33 +0800
Message-ID: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes code optimizations, bugfixes and features for
the HNS3 ethernet controller driver.

[patch 01/12] adds support for reporting link change event.

[patch 02/12] adds handler for NCSI error.

[patch 03/12] fixes bug related to debugfs.

[patch 04/12] adds a code optimization for setting ring parameters.

[patch 05/12 - 09/12] adds some cleanups.

[patch 10/12 - 12/12] adds some patches related to reset issue.

Guojia Liao (1):
  net: hns3: rename a member in struct hclge_mac_ethertype_idx_rd_cmd

Huazhong Tan (4):
  net: hns3: add handler for NCSI error mailbox
  net: hns3: fix some reset handshake issue
  net: hns3: clear reset interrupt status in hclge_irq_handle()
  net: hns3: activate reset timer when calling reset_event

Jian Shen (3):
  net: hns3: add link change event report
  net: hns3: refine for set ring parameters
  net: hns3: remove unnecessary variable in
    hclge_get_mac_vlan_cmd_status()

Weihang Li (1):
  net: hns3: simplify hclge_cmd_query_error()

Yufeng Mo (1):
  net: hns3: do not query unsupported commands in debugfs

Yunsheng Lin (2):
  net: hns3: minor cleanup in hns3_clean_rx_ring
  net: hns3: minior error handling change for hclge_tm_schd_info_init

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  22 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  88 +++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  33 ++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  25 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  76 ++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  19 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 137 +++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   8 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  45 +++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  18 +--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  60 ++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   3 +
 16 files changed, 397 insertions(+), 153 deletions(-)

-- 
2.7.4

