Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C4A31469E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhBICpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:45:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12876 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhBICnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:43:42 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DZRwp2C02z7jBn;
        Tue,  9 Feb 2021 10:41:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 10:42:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 00/11] net: hns3: some cleanups for -next
Date:   Tue, 9 Feb 2021 10:41:50 +0800
Message-ID: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some cleanups for the HNS3 ethernet driver.

change log:
V2: remove previous #3 which should target net.

previous version:
V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612784382-27262-1-git-send-email-tanhuazhong@huawei.com/

Huazhong Tan (2):
  net: hns3: remove redundant return value of hns3_uninit_all_ring()
  net: hns3: remove an unused parameter in hclge_vf_rate_param_check()

Jian Shen (2):
  net: hns3: remove redundant client_setup_tc handle
  net: hns3: cleanup for endian issue for VF RSS

Jiaran Zhang (1):
  net: hns3: modify some unmacthed types print parameter

Peng Li (4):
  net: hns3: remove the shaper param magic number
  net: hns3: change hclge_parse_speed() param type
  net: hns3: change hclge_query_bd_num() param type
  net: hns3: remove unused macro definition

Yonglong Liu (1):
  net: hns3: clean up some incorrect variable types in
    hclge_dbg_dump_tm_map()

Yufeng Mo (1):
  net: hns3: clean up unnecessary parentheses in macro definitions

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  7 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 31 ++++------------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 11 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 27 -------------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 11 ++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  4 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 14 +++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  5 +---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 14 +++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  6 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 11 ++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 19 ++++++++-----
 16 files changed, 61 insertions(+), 109 deletions(-)

-- 
2.7.4

