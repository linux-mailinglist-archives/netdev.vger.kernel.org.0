Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77543FB75A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhH3N4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:56:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18988 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbhH3Nz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 09:55:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GysDD6P2VzbkYG;
        Mon, 30 Aug 2021 21:51:08 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 21:55:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 21:55:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: add some cleanups
Date:   Mon, 30 Aug 2021 21:51:05 +0800
Message-ID: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some cleanups for the HNS3 ethernet driver.

Guojia Liao (1):
  net: hns3: clean up a type mismatch warning

Hao Chen (2):
  net: hns3: add some required spaces
  net: hns3: remove unnecessary spaces

Jian Shen (1):
  net: hns3: refine function hns3_set_default_feature()

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 66 ++++++----------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 16 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 24 ++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  9 ++-
 6 files changed, 51 insertions(+), 74 deletions(-)

-- 
2.8.1

