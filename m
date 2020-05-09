Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D2F1CBFCC
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEIJ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:28:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4375 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbgEIJ25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 05:28:57 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4A09986E8AC1AD636F9F;
        Sat,  9 May 2020 17:28:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:28:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: misc updates for -next
Date:   Sat, 9 May 2020 17:27:36 +0800
Message-ID: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes some misc updates for the HNS3 ethernet driver.

#1 & #2 add two cleanups.
#3 provides an interface for the client to query the CMDQ's status.
#4 adds a little optimization about debugfs.
#5 prevents 1000M auto-negotiation off setting.

Huazhong Tan (3):
  net: hns3: remove a redundant register macro definition
  net: hns3: modify two uncorrect macro names
  net: hns3: provide .get_cmdq_stat interface for the client

Yufeng Mo (2):
  net: hns3: optimized the judgment of the input parameters of dump ncl
    config
  net: hns3: disable auto-negotiation off with 1000M setting in ethtool

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  7 +++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  4 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 15 ++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 25 ++++++++++++++--------
 6 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.7.4

