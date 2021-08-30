Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9DA3FB10E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 08:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhH3GLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 02:11:45 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15228 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbhH3GLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 02:11:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gyg061vWzz1DDxK;
        Mon, 30 Aug 2021 14:09:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 14:10:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 14:10:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: add some cleanups
Date:   Mon, 30 Aug 2021 14:06:35 +0800
Message-ID: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some cleanups for the HNS3 ethernet driver.


Guangbin Huang (2):
  net: hns3: reconstruct function hclge_ets_validate()
  net: hns3: refine function hclge_dbg_dump_tm_pri()

Hao Chen (3):
  net: hns3: modify a print format of hns3_dbg_queue_map()
  net: hnss3: use max() to simplify code
  net: hns3: uniform parameter name of hclge_ptp_clean_tx_hwts()

Jiaran Zhang (1):
  net: hns3: initialize each member of structure array on a separate
    line

Peng Li (1):
  net: hns3: reconstruct function hns3_self_test

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |    2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |    3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  101 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   47 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   70 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 1665 +++++++++++++-------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |    2 +-
 7 files changed, 1260 insertions(+), 630 deletions(-)

-- 
2.8.1

