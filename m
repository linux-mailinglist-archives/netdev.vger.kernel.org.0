Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448411B76A4
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgDXNLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:11:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727118AbgDXNLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:11:50 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 25AFB57A1C4CB01FF60C;
        Fri, 24 Apr 2020 21:11:45 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 21:11:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] liquidio: remove unused inline functions
Date:   Fri, 24 Apr 2020 21:11:34 +0800
Message-ID: <20200424131134.41928-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit b6334be64d6f ("net/liquidio: Delete driver version assignment")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.h b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
index 3d01d3602d8f..fb380b4f3e02 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
@@ -712,18 +712,6 @@ struct octeon_device *lio_get_device(u32 octeon_id);
  */
 int lio_get_device_id(void *dev);
 
-static inline u16 OCTEON_MAJOR_REV(struct octeon_device *oct)
-{
-	u16 rev = (oct->rev_id & 0xC) >> 2;
-
-	return (rev == 0) ? 1 : rev;
-}
-
-static inline u16 OCTEON_MINOR_REV(struct octeon_device *oct)
-{
-	return oct->rev_id & 0x3;
-}
-
 /** Read windowed register.
  *  @param  oct   -  pointer to the Octeon device.
  *  @param  addr  -  Address of the register to read.
-- 
2.17.1


