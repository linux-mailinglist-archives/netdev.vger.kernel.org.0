Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D136200526
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbgFSJbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:31:44 -0400
Received: from smtp.asem.it ([151.1.184.197]:52619 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731510AbgFSJbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 05:31:09 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000329281.MSG 
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:31:06 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 19
 Jun 2020 11:31:03 +0200
Received: from flavio-x.asem.intra (172.16.17.208) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 19 Jun 2020 11:31:03 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
Subject: [PATCH 1/1] net: wireless: intersil: orinoco: fix spelling mistake
Date:   Fri, 19 Jun 2020 11:31:02 +0200
Message-ID: <20200619093102.29487-1-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090208.5EEC85D9.0007,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo: "EZUSB_REQUEST_TRIGER" --> "EZUSB_REQUEST_TRIGGER"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 651c676b5506..11fa38fedd87 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -158,7 +158,7 @@ MODULE_FIRMWARE("orinoco_ezusb_fw");
 
 
 #define EZUSB_REQUEST_FW_TRANS		0xA0
-#define EZUSB_REQUEST_TRIGER		0xAA
+#define EZUSB_REQUEST_TRIGGER		0xAA
 #define EZUSB_REQUEST_TRIG_AC		0xAC
 #define EZUSB_CPUCS_REG			0x7F92
 
@@ -1318,12 +1318,12 @@ static int ezusb_hard_reset(struct orinoco_private *priv)
 	netdev_dbg(upriv->dev, "sending control message\n");
 	retval = usb_control_msg(upriv->udev,
 				 usb_sndctrlpipe(upriv->udev, 0),
-				 EZUSB_REQUEST_TRIGER,
+				 EZUSB_REQUEST_TRIGGER,
 				 USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				 USB_DIR_OUT, 0x0, 0x0, NULL, 0,
 				 DEF_TIMEOUT);
 	if (retval < 0) {
-		err("EZUSB_REQUEST_TRIGER failed retval %d", retval);
+		err("EZUSB_REQUEST_TRIGGER failed retval %d", retval);
 		return retval;
 	}
 #if 0
-- 
2.17.1

