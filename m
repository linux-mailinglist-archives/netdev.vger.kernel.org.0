Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53471DCC3B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgEULjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:39:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbgEULjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 07:39:52 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B028071144CF9A1710A5;
        Thu, 21 May 2020 19:39:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 21 May 2020 19:39:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
Date:   Thu, 21 May 2020 19:38:23 +0800
Message-ID: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds two new VLAN feature.

[patch 1] adds a new dynamic VLAN mode.
[patch 2] adds support for 'QoS' field to PVID.

Change log:
V1->V2: modifies [patch 1]'s commit log, suggested by Jakub Kicinski.

GuoJia Liao (2):
  net: hns3: adds support for dynamic VLAN mode
  net: hns3: add support for 'QoS' in port based VLAN configuration

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 151 ++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  25 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  10 +-
 7 files changed, 155 insertions(+), 47 deletions(-)

-- 
2.7.4

