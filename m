Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F243636E716
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbhD2Ifn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:35:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16170 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhD2Ifm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:35:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FW7yV1yMszlW2c;
        Thu, 29 Apr 2021 16:31:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 16:34:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: add some fixes for -net
Date:   Thu, 29 Apr 2021 16:34:49 +0800
Message-ID: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Jian Shen (1):
  net: hns3: add check for HNS3_NIC_STATE_INITED in
    hns3_reset_notify_up_enet()

Yufeng Mo (2):
  net: hns3: fix incorrect configuration for igu_egu_hw_err
  net: hns3: initialize the message content in hclge_get_link_mode()

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c        | 5 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.7.4

