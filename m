Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C47184284
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 09:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCMIY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 04:24:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbgCMIY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 04:24:26 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BADCD137EAF52A967879;
        Fri, 13 Mar 2020 16:24:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Mar 2020 16:24:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: add two optimizations for mailbox handling
Date:   Fri, 13 Mar 2020 16:23:41 +0800
Message-ID: <1584087823-61800-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes two code optimizations for mailbox handling.

Jian Shen (1):
  net: hns3: add a conversion for mailbox's response code

Yufeng Mo (1):
  net: hns3: optimize the message response between pf and vf

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  54 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 386 ++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 306 ++++++++--------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  50 +--
 5 files changed, 414 insertions(+), 386 deletions(-)

-- 
2.7.4

