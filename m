Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743731E8CC2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgE3BKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:10:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49950 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgE3BKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:10:09 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 60814BD16905A523B23B;
        Sat, 30 May 2020 09:10:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 30 May 2020 09:09:56 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/6] net: hns3: adds some cleanups for -next
Date:   Sat, 30 May 2020 09:08:26 +0800
Message-ID: <1590800912-52467-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some cleanups for the HNS3 ethernet driver, fix an
incorrect print format, an incorrect comment and some coding
style issues, also remove some unused codes and macros.

Huazhong Tan (6):
  net: hns3: fix a print format issue in hclge_mac_mdio_config()
  net: hns3: remove an unused macro hclge_is_csq
  net: hns3: remove two unused macros in hclgevf_cmd.c
  net: hns3: fix an incorrect comment for num_tqps in struct hclgevf_dev
  net: hns3: fix two coding style issues in hclgevf_main.c
  net: hns3: remove some unused codes in hns3_nic_set_features()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 6 ------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  | 3 ---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 +-
 6 files changed, 3 insertions(+), 15 deletions(-)

-- 
2.7.4

