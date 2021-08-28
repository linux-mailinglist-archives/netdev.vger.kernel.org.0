Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBF3FA418
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhH1HAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:16 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8794 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbhH1HAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GxS982xTGzYvJS;
        Sat, 28 Aug 2021 14:58:36 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Sat, 28 Aug 2021 14:55:14 +0800
Message-ID: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
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

This series includes some updates for the HNS3 ethernet driver.

#1 add a trace in  hclge_gen_resp_to_vf().
#2~#4 refactor some functions.
#5~#7 add some cleanups.

This series includes some optimizations, cleanups and one 

Guangbin Huang (4):
  net: hns3: refactor function hclge_parse_capability()
  net: hns3: refactor function hclgevf_parse_capability()
  net: hns3: add new function hclge_get_speed_bit()
  net: hns3: don't config TM DWRR twice when set ETS

Hao Chen (2):
  net: hns3: remove unnecessary "static" of local variables in function
  net: hns3: add required space in comment

Yufeng Mo (1):
  net: hns3: add trace event in hclge_gen_resp_to_vf()

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 51 ++++++++----------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 63 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  5 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 29 +++++-----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  6 +++
 11 files changed, 92 insertions(+), 82 deletions(-)

-- 
2.8.1

