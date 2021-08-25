Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2C3F6D9A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 05:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhHYDJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 23:09:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18035 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbhHYDJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 23:09:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GvW6T2dwTzbj0D;
        Wed, 25 Aug 2021 11:04:33 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 11:08:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 11:08:07 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] netxen_nic: Remove the repeated declaration
Date:   Wed, 25 Aug 2021 11:06:55 +0800
Message-ID: <1629860815-37361-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'netxen_rom_fast_read' is declared twice, so remove the
repeated declaration.

Cc: Manish Chopra <manishc@marvell.com>
Cc: Rahul Verma <rahulv@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
index e5c51256243a..f13fa7396aef 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
@@ -1863,7 +1863,6 @@ static inline u32 netxen_tx_avail(struct nx_host_tx_ring *tx_ring)
 int netxen_get_flash_mac_addr(struct netxen_adapter *adapter, u64 *mac);
 int netxen_p3_get_mac_addr(struct netxen_adapter *adapter, u64 *mac);
 void netxen_change_ringparam(struct netxen_adapter *adapter);
-int netxen_rom_fast_read(struct netxen_adapter *adapter, int addr, int *valp);
 
 extern const struct ethtool_ops netxen_nic_ethtool_ops;
 
-- 
2.7.4

