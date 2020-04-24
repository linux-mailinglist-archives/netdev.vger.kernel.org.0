Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3756C1B76AD
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgDXNNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:13:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2853 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbgDXNNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:13:12 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4897A677668F0BC76E48;
        Fri, 24 Apr 2020 21:13:06 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 21:13:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <gustavo@embeddedor.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] qlcnic: remove unused inline function qlcnic_hw_write_wx_2M
Date:   Fri, 24 Apr 2020 21:12:56 +0800
Message-ID: <20200424131256.10400-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree anymore.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index 134611aa2c9a..d838774af5a6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1880,12 +1880,6 @@ static inline void qlcnic_write_crb(struct qlcnic_adapter *adapter, char *buf,
 	adapter->ahw->hw_ops->write_crb(adapter, buf, offset, size);
 }
 
-static inline int qlcnic_hw_write_wx_2M(struct qlcnic_adapter *adapter,
-					ulong off, u32 data)
-{
-	return adapter->ahw->hw_ops->write_reg(adapter, off, data);
-}
-
 static inline int qlcnic_get_mac_address(struct qlcnic_adapter *adapter,
 					 u8 *mac, u8 function)
 {
-- 
2.17.1


