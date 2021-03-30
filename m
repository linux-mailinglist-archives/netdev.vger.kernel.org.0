Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4659234E1B0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhC3HDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:03:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15036 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhC3HDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:03:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8gMp6G29zPmNL;
        Tue, 30 Mar 2021 15:01:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:03:41 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/4] net: remove repeated words
Date:   Tue, 30 Mar 2021 15:04:02 +0800
Message-ID: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
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

