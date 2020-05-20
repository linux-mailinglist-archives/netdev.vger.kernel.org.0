Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB51DA719
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgETBVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:21:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4817 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726348AbgETBVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 21:21:48 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E6589CCFBD304388998F;
        Wed, 20 May 2020 09:21:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 09:21:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: adds two VLAN feature
Date:   Wed, 20 May 2020 09:20:11 +0800
Message-ID: <1589937613-40545-1-git-send-email-tanhuazhong@huawei.com>
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
[patch 2] adds support for 'QOS' field to PVID.

GuoJia Liao (2):
  net: hns3: adds support for dynamic VLAN mode
  net: hns3: add support for 'QOS' in port based VLAN configuration

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

