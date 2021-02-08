Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3131313D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhBHLqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:46:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12152 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhBHLlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:41:16 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT0Ld0z165PK;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: some cleanups for -next
Date:   Mon, 8 Feb 2021 19:39:30 +0800
Message-ID: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some cleanups for the HNS3 ethernet driver.

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

Yufeng Mo (2):
  net: hns3: check cmdq message parameters sent from VF
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
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 21 ++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  5 +---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 31 ++++++++++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 14 +++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  6 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 11 ++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 19 ++++++++-----
 16 files changed, 93 insertions(+), 113 deletions(-)

-- 
2.7.4

