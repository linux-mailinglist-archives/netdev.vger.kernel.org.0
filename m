Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B72D5207
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgLJDt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:49:56 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9418 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbgLJDn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:26 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x59JMz7CB3;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Thu, 10 Dec 2020 11:42:05 +0800
Message-ID: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for tc mqprio offload, hw tc
offload of tc flower, and adpation for max rss size changes.

Guojia Liao (3):
  net: hns3: add support for max 512 rss size
  net: hns3: adjust rss indirection table configure command
  net: hns3: adjust rss tc mode configure command

Jian Shen (4):
  net: hns3: refine the struct hane3_tc_info
  net: hns3: add support for tc mqprio offload
  net: hns3: add support for forwarding packet to queues of specified TC
    when flow director rule hit
  net: hns3: add support for hw tc offload of tc flower

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  34 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 112 ++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  16 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 126 +++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 466 ++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  28 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  98 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  21 +-
 12 files changed, 759 insertions(+), 151 deletions(-)

-- 
2.7.4

