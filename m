Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89801470157
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbhLJNRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:17:55 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29178 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhLJNRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:17:55 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J9WXB2nKVz8vmC;
        Fri, 10 Dec 2021 21:12:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/2] net: hns3: add some fixes for -net
Date:   Fri, 10 Dec 2021 21:09:32 +0800
Message-ID: <20211210130934.36278-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Jie Wang (1):
  net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Yufeng Mo (1):
  net: hns3: fix race condition in debugfs

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 ++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 20 +++++++++++++------
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  3 ++-
 3 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.33.0

