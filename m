Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EDC4673E9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379589AbhLCJ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:05 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29085 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351356AbhLCJ3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:04 -0500
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J56mv41tNz1DHyG;
        Fri,  3 Dec 2021 17:22:55 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 00/11] net: hns3: some cleanups for -next
Date:   Fri, 3 Dec 2021 17:20:48 +0800
Message-ID: <20211203092059.24947-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability and simplicity, this series add some cleanup
patches for the HNS3 ethernet driver.

Guangbin Huang (3):
  net: hns3: refactor function hclge_set_vlan_filter_hw
  net: hns3: add print vport id for failed message of vlan
  net: hns3: modify one argument type of function
    hclge_ncl_config_data_print

Hao Chen (6):
  net: hns3: Align type of some variables with their print type
  net: hns3: align return value type of atomic_read() with its output
  net: hns3: add void before function which don't receive ret
  net: hns3: add comments for hclge_dbg_fill_content()
  net: hns3: remove rebundant line for hclge_dbg_dump_tm_pg()
  net: hns3: replace one tab with space in for statement

Jie Wang (1):
  net: hns3: fix hns3 driver header file not self-contained issue

Yufeng Mo (1):
  net: hns3: optimize function hclge_cfg_common_loopback()

 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |   2 +-
 .../ethernet/hisilicon/hns3/hns3_debugfs.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   3 +
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  13 +-
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 121 +++++++++++-------
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_mdio.h        |   4 +
 .../hisilicon/hns3/hns3pf/hclge_ptp.h         |   3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |   6 +
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   2 +-
 11 files changed, 106 insertions(+), 54 deletions(-)

-- 
2.33.0

