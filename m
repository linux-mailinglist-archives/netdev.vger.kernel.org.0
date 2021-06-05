Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8010739C617
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 07:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFEFpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 01:45:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4479 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFEFpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 01:45:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxpPj34B6zZc9Y;
        Sat,  5 Jun 2021 13:40:25 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 13:43:12 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 13:43:11 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: tulip: Remove the repeated declaration
Date:   Sat, 5 Jun 2021 13:42:56 +0800
Message-ID: <1622871776-20567-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'pnic2_lnk_change' is declared twice, so remove the
repeated declaration.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/ethernet/dec/tulip/tulip.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip.h b/drivers/net/ethernet/dec/tulip/tulip.h
index 815907259048..0ed598dc7569 100644
--- a/drivers/net/ethernet/dec/tulip/tulip.h
+++ b/drivers/net/ethernet/dec/tulip/tulip.h
@@ -478,7 +478,6 @@ void t21142_lnk_change(struct net_device *dev, int csr5);
 void pnic2_lnk_change(struct net_device *dev, int csr5);
 void pnic2_timer(struct timer_list *t);
 void pnic2_start_nway(struct net_device *dev);
-void pnic2_lnk_change(struct net_device *dev, int csr5);
 
 /* eeprom.c */
 void tulip_parse_eeprom(struct net_device *dev);
-- 
2.7.4

