Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9428B139FA9
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgANDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:01:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:41848 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728838AbgANDBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 22:01:37 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0793413FB1705E1B0F25;
        Tue, 14 Jan 2020 11:01:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Tue, 14 Jan 2020 11:01:24 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <davem@davemloft.net>, <poeschel@lemonage.de>,
        <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <keescook@chromium.org>, <netdev@vger.kernel.org>,
        <johan@kernel.org>, <gustavo@embeddedor.com>
CC:     <linuxarm@huawei.com>
Subject: [PATCH] nfc: No need to set .owner platform_driver_register
Date:   Tue, 14 Jan 2020 10:57:39 +0800
Message-ID: <1578970659-17809-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the i2c_add_driver will set the .owner to THIS_MODULE

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/nfc/pn533/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 7507176..0207e66 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -274,7 +274,6 @@ MODULE_DEVICE_TABLE(i2c, pn533_i2c_id_table);
 static struct i2c_driver pn533_i2c_driver = {
 	.driver = {
 		   .name = PN533_I2C_DRIVER_NAME,
-		   .owner = THIS_MODULE,
 		   .of_match_table = of_match_ptr(of_pn533_i2c_match),
 		  },
 	.probe = pn533_i2c_probe,
-- 
2.7.4

