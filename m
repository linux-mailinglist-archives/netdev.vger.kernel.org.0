Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40F01894A9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCRD6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:58:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726553AbgCRD57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 23:57:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 570E46E38FFF20C2D751;
        Wed, 18 Mar 2020 11:57:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Mar 2020 11:57:41 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: add three optimizations for mailbox handling
Date:   Wed, 18 Mar 2020 11:57:04 +0800
Message-ID: <1584503827-12025-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes three code optimizations for mailbox handling.

[patch 1] adds a response code conversion.
[patch 2] refactors some structure definitions about PF and
VF mailbox.
[patch 3] refactors the condition whether PF responds VF's mailbox.

Huazhong Tan (1):
  net: hns3: refactor mailbox response scheme between PF and VF

Jian Shen (1):
  net: hns3: add a conversion for mailbox's response code

Yufeng Mo (1):
  net: hns3: refactor the mailbox message between PF and VF

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  54 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 387 ++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 311 +++++++++--------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  50 +--
 5 files changed, 420 insertions(+), 386 deletions(-)

-- 
2.7.4

