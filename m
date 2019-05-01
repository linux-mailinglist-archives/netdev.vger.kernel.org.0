Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CA210420
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfEADGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:06:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55902 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfEADGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 23:06:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3EF22203D959EF74287A;
        Wed,  1 May 2019 11:06:39 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 11:06:30 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: enhance capabilities for fibre port
Date:   Wed, 1 May 2019 11:05:41 +0800
Message-ID: <1556679944-100941-1-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patchset enhances more capabilities for fibre port,
include multipe media type identification, autoneg,
change port speed and FEC encoding.

Jian Shen (3):
  net: hns3: add support for multiple media type
  net: hns3: add autoneg and change speed support for fibre port
  net: hns3: add support for FEC encoding control

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  34 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 180 ++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  30 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 409 ++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  16 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  15 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 8 files changed, 619 insertions(+), 73 deletions(-)

-- 
1.9.1

