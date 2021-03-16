Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5144F33CC1B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 04:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhCPD2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 23:28:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13960 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhCPD2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 23:28:09 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzzGD4ZBKzrW7T;
        Tue, 16 Mar 2021 11:26:12 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 11:27:55 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <corbet@lwn.net>,
        <wanghaibin.wang@huawei.com>, "Zenghui Yu" <yuzenghui@huawei.com>
Subject: [PATCH net] docs: net: ena: Fix ena_start_xmit() function name typo
Date:   Tue, 16 Mar 2021 11:27:37 +0800
Message-ID: <20210316032737.1429-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena.rst documentation referred to end_start_xmit() when it should refer
to ena_start_xmit(). Fix the typo.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 3561a8a29fd2..f8c6469f2bd2 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -267,7 +267,7 @@ DATA PATH
 Tx
 --
 
-end_start_xmit() is called by the stack. This function does the following:
+ena_start_xmit() is called by the stack. This function does the following:
 
 - Maps data buffers (skb->data and frags).
 - Populates ena_buf for the push buffer (if the driver and device are
-- 
2.19.1

