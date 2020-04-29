Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6358F1BD1E3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgD2BvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:51:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgD2BvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:51:22 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 186C7FF45E3026D6D1AD;
        Wed, 29 Apr 2020 09:51:21 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 09:51:14 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <aviad.krawczyk@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] hinic: make symbol 'dump_mox_reg' static
Date:   Wed, 29 Apr 2020 09:58:24 +0800
Message-ID: <20200429015824.36496-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:601:6: warning: symbol 'dump_mox_reg' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index f8626dfd192e..d5cf31529dbf 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -598,7 +598,7 @@ static void write_mbox_msg_attr(struct hinic_mbox_func_to_func *func_to_func,
 			     HINIC_FUNC_CSR_MAILBOX_CONTROL_OFF, mbox_ctrl);
 }

-void dump_mox_reg(struct hinic_hwdev *hwdev)
+static void dump_mox_reg(struct hinic_hwdev *hwdev)
 {
 	u32 val;

--
2.26.0.106.g9fadedd

