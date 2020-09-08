Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9E2608E0
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgIHDDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:03:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728372AbgIHDCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:02:30 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9E815FCC73654E726394;
        Tue,  8 Sep 2020 11:02:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:02:18 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: misc updates
Date:   Tue, 8 Sep 2020 10:59:47 +0800
Message-ID: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some misc updates for the HNS3 ethernet driver.

#1 narrows two local variable range in hclgevf_reset_prepare_wait().
#2 adds reset failure check in periodic service task.
#3~#7 adds some cleanups.

Guangbin Huang (2):
  net: hns3: skip periodic service task if reset failed
  net: hns3: fix a typo in struct hclge_mac

Guojia Liao (1):
  net: hns3: remove some unused function hns3_update_promisc_mode()

Huazhong Tan (4):
  net: hns3: narrow two local variable range in
    hclgevf_reset_prepare_wait()
  net: hns3: remove unused field 'io_base' in struct hns3_enet_ring
  net: hns3: remove unused field 'tc_num_last_time' in struct hclge_dev
  net: hns3: remove some unused macros related to queue

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c          | 16 ----------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h          |  7 -------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h  |  3 +--
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c    | 15 +++++++++------
 5 files changed, 13 insertions(+), 31 deletions(-)

-- 
2.7.4

