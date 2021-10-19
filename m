Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A598433849
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhJSOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:08 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26166 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSOXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HYbV15qmsz8tky;
        Tue, 19 Oct 2021 22:19:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/8] net: hns3: add some fixes for -net
Date:   Tue, 19 Oct 2021 22:16:27 +0800
Message-ID: <20211019141635.43695-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (2):
  net: hns3: reset DWRR of unused tc to zero
  net: hns3: add limit ets dwrr bandwidth cannot be 0

Jiaran Zhang (1):
  net: hns3: Add configuration of TM QCN error event

Peng Li (1):
  net: hns3: disable sriov before unload hclge layer

Yufeng Mo (1):
  net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin (3):
  net: hns3: fix the max tx size according to user manual
  net: hns3: fix for miscalculation of rx unused desc
  net: hns3: schedule the polling again when allocation fails

 drivers/net/ethernet/hisilicon/hns3/hnae3.c   | 21 +++++++++++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 37 +++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  7 ++--
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  9 +++++
 .../hisilicon/hns3/hns3pf/hclge_err.c         |  5 ++-
 .../hisilicon/hns3/hns3pf/hclge_err.h         |  2 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  6 +--
 10 files changed, 68 insertions(+), 23 deletions(-)

-- 
2.33.0

