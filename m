Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6034E22C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhC3H2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:28:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15391 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhC3H1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:27:44 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8gwV125pzqSKQ;
        Tue, 30 Mar 2021 15:26:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:27:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andrew@lunn.ch>, <elder@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net-next 0/4] net: remove repeated words
Date:   Tue, 30 Mar 2021 15:27:52 +0800
Message-ID: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set removes some repeated words in comments.

Peng Li (4):
  net: i40e: remove repeated words
  net: bonding: remove repeated word
  net: phy: remove repeated word
  net: ipa: remove repeated words

 drivers/net/bonding/bond_alb.c              | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 drivers/net/ipa/ipa_endpoint.c              | 4 ++--
 drivers/net/phy/mdio_bus.c                  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.7.4

