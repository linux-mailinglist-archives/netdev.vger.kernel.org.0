Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6369C113998
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfLECMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:12:22 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728393AbfLECMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:12:22 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C2BB0B779A70E4EF1BAF;
        Thu,  5 Dec 2019 10:12:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Dec 2019 10:12:08 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net 0/3] net: hns3: fixes for -net
Date:   Thu, 5 Dec 2019 10:12:26 +0800
Message-ID: <1575511949-1613-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes misc fixes for the HNS3 ethernet driver.

[patch 1/3] fixes a TX queue not restarted problem.

[patch 2/3] fixes a use-after-free issue.

[patch 3/3] fixes a VF ID issue for setting VF VLAN.

change log:
V1->V2: keeps 'ring' as parameter in hns3_nic_maybe_stop_tx()
	in [patch 1/3], suggestted by David.
	rewrites [patch 2/3]'s commit log to make it be easier
	to understand, suggestted by David.

Jian Shen (1):
  net: hns3: fix VF ID issue for setting VF VLAN

Yunsheng Lin (2):
  net: hns3: fix for TX queue not restarted problem
  net: hns3: fix a use after free problem in hns3_nic_maybe_stop_tx()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 50 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 18 +++-----
 2 files changed, 32 insertions(+), 36 deletions(-)

-- 
2.7.4

