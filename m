Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFEC357AD3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhDHDkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:40:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15959 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHDkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:40:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG6Qt2wSWzyNhd;
        Thu,  8 Apr 2021 11:37:42 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 11:39:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: add support for pm_ops
Date:   Thu, 8 Apr 2021 11:40:03 +0800
Message-ID: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for pm_ops in the HNS3 ethernet driver.

Jiaran Zhang (2):
  net: hns3: change flr_prepare/flr_done function names
  net: hns3: add suspend and resume pm_ops

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 37 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 29 ++++++++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 27 +++++++++-------
 4 files changed, 68 insertions(+), 30 deletions(-)

-- 
2.7.4

