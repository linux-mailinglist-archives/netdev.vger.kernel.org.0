Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40EB38E35E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhEXJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:32:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXJc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:32:29 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpX225HR3z1BR7Z;
        Mon, 24 May 2021 17:28:10 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 17:31:00 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 17:31:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: add two promisc mode updates
Date:   Mon, 24 May 2021 17:30:41 +0800
Message-ID: <1621848643-18567-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two updates related to promisc mode for the HNS3
ethernet driver.

Jian Shen (2):
  net: hns3: configure promisc mode for VF asynchronously
  net: hns3: use HCLGE_VPORT_STATE_PROMISC_CHANGE to replace
    HCLGE_STATE_PROMISC_CHANGED

 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 55 ++++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  6 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 40 ++++------------
 3 files changed, 48 insertions(+), 53 deletions(-)

-- 
2.7.4

