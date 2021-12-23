Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3016A47E38F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348507AbhLWMfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:35:07 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30168 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbhLWMfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:35:07 -0500
Received: from kwepemi100007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JKV2g1RH2z8vq6;
        Thu, 23 Dec 2021 20:32:43 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100007.china.huawei.com (7.221.188.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 20:35:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 20:35:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 0/2] net: hns3: add support for TX push
Date:   Thu, 23 Dec 2021 20:30:11 +0800
Message-ID: <20211223123013.29367-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This series adds TX push support for the HNS3 ethernet driver.
And it relies on "asm-generic: introduce io_stop_wc() and add
implementation for ARM64"[1], which has not been merged into
the net-next branch yet.

[1]https://git.kernel.org/arm64/c/d5624bb29f49

Yufeng Mo (2):
  net: hns3: add support for TX push mode
  net: hns3: add ethtool priv-flag for TX push

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 82 ++++++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  6 ++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 21 ++++-
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         |  1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 11 ++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  8 ++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       |  1 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 11 ++-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  8 ++
 10 files changed, 142 insertions(+), 9 deletions(-)

-- 
2.33.0

