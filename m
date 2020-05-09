Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2A1CC4D3
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEIV6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:58:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50198 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIV6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:58:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXXTo-00055J-Lw; Sat, 09 May 2020 21:57:56 +0000
From:   Colin King <colin.king@canonical.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: qmi_wwan: remove redundant assignment to variable status
Date:   Sat,  9 May 2020 22:57:55 +0100
Message-Id: <20200509215756.506840-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable status is being initializeed with a value that is never read
and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 4bb8552a00d3..b0eab6e5279d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -719,7 +719,7 @@ static int qmi_wwan_change_dtr(struct usbnet *dev, bool on)
 
 static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	int status = -1;
+	int status;
 	u8 *buf = intf->cur_altsetting->extra;
 	int len = intf->cur_altsetting->extralen;
 	struct usb_interface_descriptor *desc = &intf->cur_altsetting->desc;
-- 
2.25.1

