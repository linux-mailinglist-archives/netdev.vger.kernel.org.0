Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E7AF88E3
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfKLGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:52:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbfKLGwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:52:30 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 036FE78FBA56A4CC50DD;
        Tue, 12 Nov 2019 14:52:27 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 14:52:19 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH net-next v2 2/2] net: atlantic: make function 'aq_ethtool_get_priv_flags','aq_ethtool_set_priv_flags' static
Date:   Tue, 12 Nov 2019 14:59:42 +0800
Message-ID: <1573541982-100413-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
References: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c:706:5: warning: symbol 'aq_ethtool_get_priv_flags' was not declared. Should it be static?
drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c:713:5: warning: symbol 'aq_ethtool_set_priv_flags' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: ea4b4d7fc106 ("net: atlantic: loopback tests via private flags")
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 6353a5c..a1f99be 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -703,14 +703,14 @@ static void aq_set_msg_level(struct net_device *ndev, u32 data)
 	aq_nic->msg_enable = data;
 }

-u32 aq_ethtool_get_priv_flags(struct net_device *ndev)
+static u32 aq_ethtool_get_priv_flags(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);

 	return aq_nic->aq_nic_cfg.priv_flags;
 }

-int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
+static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
--
2.7.4

