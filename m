Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC701CC4C9
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgEIVsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:48:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50131 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIVsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:48:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXXKF-0004eS-Oc; Sat, 09 May 2020 21:48:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org (open), netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: huawei_cdc_ncm: remove redundant assignment to variable ret
Date:   Sat,  9 May 2020 22:48:03 +0100
Message-Id: <20200509214803.506276-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initializeed with a value that is never read
and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/usb/huawei_cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/huawei_cdc_ncm.c b/drivers/net/usb/huawei_cdc_ncm.c
index 099d84827004..a87f0dabcdb7 100644
--- a/drivers/net/usb/huawei_cdc_ncm.c
+++ b/drivers/net/usb/huawei_cdc_ncm.c
@@ -67,7 +67,7 @@ static int huawei_cdc_ncm_bind(struct usbnet *usbnet_dev,
 {
 	struct cdc_ncm_ctx *ctx;
 	struct usb_driver *subdriver = ERR_PTR(-ENODEV);
-	int ret = -ENODEV;
+	int ret;
 	struct huawei_cdc_ncm_state *drvstate = (void *)&usbnet_dev->data;
 	int drvflags = 0;
 
-- 
2.25.1

