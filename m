Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC7E10F575
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 04:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLCDI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 22:08:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7187 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbfLCDIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 22:08:46 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 76D60534AC1FFA763A07;
        Tue,  3 Dec 2019 11:08:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Tue, 3 Dec 2019 11:08:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes for -net
Date:   Tue, 3 Dec 2019 11:08:52 +0800
Message-ID: <1575342535-2981-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes misc fixes for the HNS3 ethernet driver.

[patch 1/3] fixes a TX queue not restarted problem.

[patch 2/3] fixes a use-after-free issue.

[patch 3/3] fixes a VF ID issue for setting VF VLAN.


Jian Shen (1):
  net: hns3: fix VF ID issue for setting VF VLAN

Yunsheng Lin (2):
  net: hns3: fix for TX queue not restarted problem
  net: hns3: fix a use after free problem in hns3_nic_maybe_stop_tx()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 53 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 18 +++-----
 2 files changed, 34 insertions(+), 37 deletions(-)

-- 
2.7.4

