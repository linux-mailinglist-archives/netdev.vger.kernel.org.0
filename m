Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2AA227E21
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgGULHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:07:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7806 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727991AbgGULHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:07:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1C47810CE4E6F6BD047;
        Tue, 21 Jul 2020 19:07:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 19:06:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Tue, 21 Jul 2020 19:03:50 +0800
Message-ID: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some bugfixes for the HNS3 ethernet driver.

Jian Shen (1):
  net: hns3: fix return value error when query MAC link status fail

Yunsheng Lin (3):
  net: hns3: fix for not unmapping TX buffer correctly
  net: hns3: fix for not calculating TX BD send size correctly
  net: hns3: fix error handling for desc filling

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 24 +++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 49 ++++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  3 ++
 5 files changed, 38 insertions(+), 41 deletions(-)

-- 
2.7.4

