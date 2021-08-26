Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3935C3F8660
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbhHZL0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8776 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwL9n4cLHzYtrt;
        Thu, 26 Aug 2021 19:25:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 0/7] net: hns3: add some fixes for -net
Date:   Thu, 26 Aug 2021 19:21:54 +0800
Message-ID: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (1):
  net: hns3: fix get wrong pfc_en when query PFC configuration

Guojia Liao (1):
  net: hns3: fix duplicate node in VLAN list

Yonglong Liu (1):
  net: hns3: fix speed unknown issue in bond 4

Yufeng Mo (4):
  net: hns3: clear hardware resource when loading driver
  net: hns3: add waiting time before cmdq memory is released
  net: hns3: change the method of getting cmd index in debugfs
  net: hns3: fix GRO configuration error after reset

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 14 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  6 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  4 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 13 +-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 52 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  7 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 21 ++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  2 +-
 12 files changed, 90 insertions(+), 34 deletions(-)

-- 
2.8.1

