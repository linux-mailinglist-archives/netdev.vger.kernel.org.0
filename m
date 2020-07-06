Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF921565E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgGFL16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:27:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728831AbgGFL15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 07:27:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 63C1AA2961644E9B8A74;
        Mon,  6 Jul 2020 19:27:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 19:27:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Mon, 6 Jul 2020 19:25:58 +0800
Message-ID: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some fixes about reset issue and a use-after-free
of self-test.

Huazhong Tan (3):
  net: hns3: check reset pending after FLR prepare
  net: hns3: fix for mishandle of asserting VF reset fail
  net: hns3: add a missing uninit debugfs when unload driver

Yonglong Liu (1):
  net: hns3: fix use-after-free when doing self test

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++++
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.7.4

