Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA359985
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfF1LwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726656AbfF1LwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:08 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 078A6C70308820D69ECF;
        Fri, 28 Jun 2019 19:52:06 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:51:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: some code optimizations & cleanups & bugfixes
Date:   Fri, 28 Jun 2019 19:50:06 +0800
Message-ID: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[patch 01/12] fixes a TX timeout issue.

[patch 02/12 - 04/12] adds some patch related to TM module.

[patch 05/12] fixes a compile warning.

[patch 06/12] adds Asym Pause support for autoneg

[patch 07/12] optimizes the error handler for VF reset.

[patch 08/12] deals with the empty interrupt case.

[patch 09/12 - 12/12] adds some cleanups & optimizations.

Huazhong Tan (3):
  net: hns3: fix __QUEUE_STATE_STACK_XOFF not cleared issue
  net: hns3: re-schedule reset task while VF reset fail
  net: hns3: handle empty unknown interrupt

Jian Shen (1):
  net: hns3: remove unused linkmode definition

Peng Li (1):
  net: hns3: optimize the CSQ cmd error handling

Yonglong Liu (2):
  net: hns3: fix a -Wformat-nonliteral compile warning
  net: hns3: add Asym Pause support to fix autoneg problem

Yufeng Mo (1):
  net: hns3: fix a statistics issue about l3l4 checksum error

Yunsheng Lin (4):
  net: hns3: enable DCB when TC num is one and pfc_en is non-zero
  net: hns3: change SSU's buffer allocation according to UM
  net: hns3: add some error checking in hclge_tm module
  net: hns3: remove RXD_VLD check in hns3_handle_bdinfo

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 66 +++++++----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 20 ------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 15 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 84 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  7 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 25 ++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  3 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 19 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 30 +++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 13 files changed, 184 insertions(+), 91 deletions(-)

-- 
2.7.4

