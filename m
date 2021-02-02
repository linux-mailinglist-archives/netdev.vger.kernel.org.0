Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F5A30BE68
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhBBMlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:41:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12103 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhBBMlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:41:14 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk333Qz162Zt;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Tue, 2 Feb 2021 20:39:46 +0800
Message-ID: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

#1~#6 add some code optimizations and compatibility handlings.
#7 fixes a clang warning.

Guangbin Huang (3):
  net: hns3: RSS indirection table and key use device specifications
  net: hns3: debugfs add max tm rate specification print
  net: hns3: replace macro of max qset number with specification

GuoJia Liao (1):
  net: hns3: optimize the code when update the tc info

Huazhong Tan (1):
  net: hns3: remove unnecessary check in hns3_dbg_read()

Jian Shen (1):
  net: hns3: add api capability bits for firmware

Yufeng Mo (1):
  net: hns3: add support for obtaining the maximum frame length

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  8 +---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 ++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 10 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  9 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  8 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 53 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 14 ++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 15 ++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 10 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  6 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 44 ++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  | 11 +++--
 13 files changed, 115 insertions(+), 90 deletions(-)

-- 
2.7.4

