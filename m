Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84BFBDED
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 03:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNCcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 21:32:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6657 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726505AbfKNCcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 21:32:21 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B3A827862A61D44B8ED7;
        Thu, 14 Nov 2019 10:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 14 Nov 2019 10:32:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes for -net
Date:   Thu, 14 Nov 2019 10:32:38 +0800
Message-ID: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes misc fixes for the HNS3 ethernet driver.

[patch 1/3] adds a compatible handling for configuration of
MAC VLAN swithch parameter.

[patch 2/3] re-allocates SSU buffer when pfc_en changed.

[patch 3/3] fixes a bug for ETS bandwidth validation.

Guangbin Huang (1):
  net: hns3: add compatible handling for MAC VLAN switch parameter
    configuration

Yonglong Liu (1):
  net: hns3: fix ETS bandwidth validation bug

Yunsheng Lin (1):
  net: hns3: reallocate SSU' buffer size when pfc_en changes

 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    | 19 +++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 16 ++++++++++++++--
 2 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.7.4

