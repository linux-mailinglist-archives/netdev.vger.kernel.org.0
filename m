Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E562D143883
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAUImc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:32 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727969AbgAUImb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F0B8BBC162D6B6F1ED93;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:20 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/9] net: hns3: misc updates for -net-next
Date:   Tue, 21 Jan 2020 16:42:04 +0800
Message-ID: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3 ethernet driver.

[patch 1] adds a limitation for the error log in the
hns3_clean_tx_ring().
[patch 2] adds a check for pfmemalloc flag before reusing pages
since these pages may be used some special case.
[patch 3] assigns a default reset type 'HNAE3_NONE_RESET' to
VF's reset_type after initializing or reset.
[patch 4] unifies macro HCLGE_DFX_REG_TYPE_CNT's definition into
header file.
[patch 5] refines the parameter 'size' of snprintf() in the
hns3_init_module().
[patch 6] rewrites a debug message in hclge_put_vector().
[patch 7~9] adds some cleanups related to coding style.

Guangbin Huang (1):
  net: hns3: delete unnecessary blank line and space for cleanup

Guojia Liao (2):
  net: hns3: move duplicated macro definition into header
  net: hns3: refine the input parameter 'size' for snprintf()

Huazhong Tan (3):
  net: hns3: set VF's default reset_type to HNAE3_NONE_RESET
  net: hns3: remove redundant print on ENOMEM
  net: hns3: cleanup some coding style issue

Yonglong Liu (1):
  net: hns3: rewrite a log in hclge_put_vector()

Yunsheng Lin (2):
  net: hns3: limit the error logging in the hns3_clean_tx_ring()
  net: hns3: do not reuse pfmemalloc pages

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  6 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 22 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  2 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 91 +++++++---------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 37 ++++-----
 7 files changed, 59 insertions(+), 107 deletions(-)

-- 
2.7.4

