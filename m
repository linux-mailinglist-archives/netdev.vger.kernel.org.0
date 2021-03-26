Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0398349EC5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCZBgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14603 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhCZBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JX0xcnz19JGM;
        Fri, 26 Mar 2021 09:34:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/9] net: hns3: add some cleanups
Date:   Fri, 26 Mar 2021 09:36:19 +0800
Message-ID: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some cleanups for the HNS3 ethernet driver.

Guojia Liao (1):
  net: hns3: split out hclge_tm_vport_tc_info_update()

Huazhong Tan (3):
  net: hns3: remove unused parameter from hclge_dbg_dump_loopback()
  net: hns3: fix prototype warning
  net: hns3: fix some typos in hclge_main.c

Jian Shen (1):
  net: hns3: remove unused code of vmdq

Jiaran Zhang (1):
  net: hns3: remove redundant query in hclge_config_tm_hw_err_int()

Peng Li (2):
  net: hns3: remove redundant blank lines
  net: hns3: remove unused parameter from hclge_set_vf_vlan_common()

Yufeng Mo (1):
  net: hns3: split function hclge_reset_rebuild()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   7 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 283 +++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   1 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 -
 12 files changed, 130 insertions(+), 197 deletions(-)

-- 
2.7.4

