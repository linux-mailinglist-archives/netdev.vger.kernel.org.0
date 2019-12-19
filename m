Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C386F125BB8
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLSG5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:57:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726670AbfLSG5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:49 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CE0824AD6ABD91E5A6B8;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/8] net: hns3: misc updates for -net-next
Date:   Thu, 19 Dec 2019 14:57:39 +0800
Message-ID: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3 ethernet driver.

[patch 1] adds FE bit check before calling hns3_add_frag().
[patch 2] removes an unnecessary lock.
[patch 3] adds a little optimization for CMDQ uninitialization.
[patch 4] refactors the dump of FD tcams.
[patch 5] implements ndo_features_check ops.
[patch 6] adds some VF VLAN information for command "ip link show".
[patch 7] adds a debug print.
[patch 8] modifies the timing of print misc interrupt status when
handling hardware error event.

Huazhong Tan (5):
  net: hns3: remove useless mutex vport_cfg_mutex in the struct
    hclge_dev
  net: hns3: optimization for CMDQ uninitialization
  net: hns3: add some VF VLAN information for command "ip link show"
  net: hns3: add a log for getting chain failure in
    hns3_nic_uninit_vector_data()
  net: hns3: only print misc interrupt status when handling fails

Yufeng Mo (1):
  net: hns3: get FD rules location before dump in debugfs

Yunsheng Lin (2):
  net: hns3: check FE bit before calling hns3_add_frag()
  net: hns3: implement ndo_features_check ops for hns3 driver

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 85 +++++++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 16 +---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 74 +++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 21 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +-
 7 files changed, 130 insertions(+), 72 deletions(-)

-- 
2.7.4

