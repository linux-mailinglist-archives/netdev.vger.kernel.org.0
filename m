Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF75D3877CA
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbhERLhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 07:37:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3581 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240092AbhERLhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 07:37:33 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fkv5P4TcwzsRmC;
        Tue, 18 May 2021 19:33:29 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Tue, 18 May 2021 19:35:59 +0800
Message-ID: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some bugfixes for the HNS3 ethernet driver.

Huazhong Tan (1):
  net: hns3: fix user's coalesce configuration lost issue

Jian Shen (1):
  net: hns3: put off calling register_netdev() until client initialize
    complete

Jiaran Zhang (1):
  net: hns3: fix incorrect resp_msg issue

Yunsheng Lin (1):
  net: hns3: check the return of skb_checksum_help()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 110 ++++++++++-----------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  64 +++++-------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 3 files changed, 77 insertions(+), 101 deletions(-)

-- 
2.7.4

