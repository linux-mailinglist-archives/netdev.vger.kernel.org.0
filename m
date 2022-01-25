Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2849ADA0
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359407AbiAYH3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:29:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17806 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445145AbiAYH1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 02:27:04 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jjdg723Fpz9sSC;
        Tue, 25 Jan 2022 15:25:39 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:57 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RESEND PATCH net-next 0/2] net: hns3: add support for TX push
Date:   Tue, 25 Jan 2022 15:21:47 +0800
Message-ID: <20220125072149.56604-1-huangguangbin2@huawei.com>
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

This series adds TX push support for the HNS3 ethernet driver.

Yufeng Mo (2):
  net: hns3: add support for TX push mode
  net: hns3: add ethtool priv-flag for TX push

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 82 ++++++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  6 ++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 21 ++++-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 11 ++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  8 ++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 11 ++-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  8 ++
 8 files changed, 140 insertions(+), 9 deletions(-)

-- 
2.33.0

