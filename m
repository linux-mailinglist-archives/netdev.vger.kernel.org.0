Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E8829705
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390920AbfEXLVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:21:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17561 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390535AbfEXLVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:21:17 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AB8CB4C07225AD491552;
        Fri, 24 May 2019 19:21:15 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 24 May 2019 19:21:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: add aRFS feature and fix FEC bugs for HNS3 driver
Date:   Fri, 24 May 2019 19:19:44 +0800
Message-ID: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds some new features support and fixes some bugs:
[Patch 1/4 - 3/4] adds support for aRFS
[Patch 4/4] fix FEC configuration issue

Jian Shen (4):
  net: hns3: initialize CPU reverse mapping
  net: hns3: refine the flow director handle
  net: hns3: add aRFS support for PF
  net: hns3: fix for FEC configuration

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 108 +++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 336 +++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  16 +
 4 files changed, 404 insertions(+), 60 deletions(-)

-- 
2.7.4

