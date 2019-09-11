Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288AAAF466
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfIKCnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:43:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51154 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbfIKCnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:43:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C23CC2D90DDC6853B61;
        Wed, 11 Sep 2019 10:43:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 10:42:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH V2 net-next 0/7] net: hns3: add a feature & bugfixes & cleanups
Date:   Wed, 11 Sep 2019 10:40:32 +0800
Message-ID: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes a VF feature, bugfixes and cleanups for the HNS3
ethernet controller driver.

[patch 01/07] adds ethtool_ops.set_channels support for HNS3 VF driver

[patch 02/07] adds a recovery for setting channel fail.

[patch 03/07] fixes an error related to shaper parameter algorithm.

[patch 04/07] fixes an error related to ksetting.

[patch 05/07] adds cleanups for some log pinting.

[patch 06/07] adds a NULL pointer check before function calling.

[patch 07/07] adds some debugging information for reset issue.

Change log:
V1->V2: fixes comment from David Miller.

Guangbin Huang (4):
  net: hns3: add ethtool_ops.set_channels support for HNS3 VF driver
  net: hns3: fix port setting handle for fibre port
  net: hns3: modify some logs format
  net: hns3: check NULL pointer before use

Huazhong Tan (1):
  net: hns3: add some DFX info for reset issue

Peng Li (1):
  net: hns3: revert to old channel when setting new channel num fail

Yonglong Liu (1):
  net: hns3: fix shaper parameter algorithm

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 54 ++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 16 +++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 32 ++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 13 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 11 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 83 ++++++++++++++++++++--
 9 files changed, 174 insertions(+), 46 deletions(-)

-- 
2.7.4

