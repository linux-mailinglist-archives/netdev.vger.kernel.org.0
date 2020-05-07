Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740491C8616
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 11:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgEGJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:50:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:58776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 05:50:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 42FC5AFF2;
        Thu,  7 May 2020 09:50:25 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, johan@kernel.org, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usb: hso: correct debug message
Date:   Thu,  7 May 2020 11:49:49 +0200
Message-Id: <20200507094949.11121-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you do not find the OUT endpoint, you should say so,
rather than copy the error message for the IN endpoint.
Presumably a copy and paste error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 417e42c9fd03..bb8c34d746ab 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2659,7 +2659,7 @@ static struct hso_device *hso_create_bulk_serial_device(
 	if (!
 	    (serial->out_endp =
 	     hso_get_ep(interface, USB_ENDPOINT_XFER_BULK, USB_DIR_OUT))) {
-		dev_err(&interface->dev, "Failed to find BULK IN ep\n");
+		dev_err(&interface->dev, "Failed to find BULK OUT ep\n");
 		goto exit2;
 	}
 
-- 
2.16.4

