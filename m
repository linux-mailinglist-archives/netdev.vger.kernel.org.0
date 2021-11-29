Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFEF461777
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbhK2OKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:25 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27315 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239491AbhK2OIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:24 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nDC2LTXzbhsX;
        Mon, 29 Nov 2021 22:04:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 00/10] net: hns3: some cleanups for -next
Date:   Mon, 29 Nov 2021 22:00:17 +0800
Message-ID: <20211129140027.23036-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability and simplicity, this series refactor some
functions in the HNS3 ethernet driver.

Guangbin Huang (3):
  net: hns3: refine function hclge_cfg_mac_speed_dup_hw()
  net: hns3: add new function hclge_tm_schd_mode_tc_base_cfg()
  net: hns3: refine function hclge_tm_pri_q_qs_cfg()

Hao Chen (1):
  net: hns3: refactor hns3_nic_reuse_page()

Jiaran Zhang (1):
  net: hns3: refactor reset_prepare_general retry statement

Jie Wang (1):
  net: hns3: refactor two hns3 debugfs functions

Yufeng Mo (4):
  net: hns3: split function hns3_get_tx_timeo_queue_info()
  net: hns3: split function hns3_nic_get_stats64()
  net: hns3: split function hns3_handle_bdinfo()
  net: hns3: split function hns3_set_l2l3l4()

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 434 ++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   5 +
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  93 ++--
 .../hisilicon/hns3/hns3pf/hclge_debugfs.h     |   5 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 103 ++---
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   5 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 108 +++--
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  32 +-
 8 files changed, 431 insertions(+), 354 deletions(-)

-- 
2.33.0

