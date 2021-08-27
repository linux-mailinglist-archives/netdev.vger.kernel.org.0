Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA233F971A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbhH0Jdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14426 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244738AbhH0JdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwvXZ5LgjzbdVF;
        Fri, 27 Aug 2021 17:28:30 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/8] net: hns3: add some cleanups
Date:   Fri, 27 Aug 2021 17:28:16 +0800
Message-ID: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
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

Guangbin Huang (1):
  net: hns3: add macros for mac speeds of firmware command

Hao Chen (1):
  net: hns3: uniform type of function parameter cmd

Huazhong Tan (1):
  net: hns3: add hns3_state_init() to do state initialization

Peng Li (5):
  net: hns3: remove redundant param mbx_event_pending
  net: hns3: use memcpy to simplify code
  net: hns3: remove redundant param to simplify code
  net: hns3: package new functions to simplify hclgevf_mbx_handler code
  net: hns3: merge some repetitive macros

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  29 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  23 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  58 +++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  22 ++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  10 --
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  22 ++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  22 ++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 122 ++++++++++-----------
 9 files changed, 151 insertions(+), 162 deletions(-)

-- 
2.8.1

