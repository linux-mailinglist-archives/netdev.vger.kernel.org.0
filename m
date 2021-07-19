Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9643CD05E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbhGSIgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:36:01 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11341 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbhGSIgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:36:00 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GSx1c5DF1z7tDW;
        Mon, 19 Jul 2021 17:12:04 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <fengchengwen@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Mon, 19 Jul 2021 17:13:04 +0800
Message-ID: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some bugfixes for the HNS3 ethernet driver.

Chengwen Feng (1):
  net: hns3: fix possible mismatches resp of mailbox

Jian Shen (2):
  net: hns3: disable port VLAN filter when support function level VLAN
    filter control
  net: hns3: fix rx VLAN offload state inconsistent issue

Peng Li (1):
  net: hns3: add match_id to check mailbox response from PF to VF

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h       |  7 +++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  8 ++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 ++++++++++
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 19 +++++++++++++++++++
 5 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.8.1

