Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E71C68056
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGNQ4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 12:56:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55687 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbfGNQ4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 12:56:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so12892450wmj.5
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 09:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+9lhk6bNnduoLFvxQOj6r1ZdbN7Net/4PT8u3Z4AhvU=;
        b=Xrg4Y31Mgh4+zA2R59dtGA1ExHe0hWKOO0BXFBBWXvJDz3n3tVzW4FouLJyd8S36HS
         xsSLhpzxVqcFX7RDCpvTdjEf7JFofxGpkhCEB0MOmS/ANqu44hJ4SVskPrl0r/8R5ip3
         tMNFggigPlgsago5PG0a5NMGfnxPmORU5wN26Y93r+Zsh8GWEbnSmoK5bcIikJBwh/dm
         WLzBqnraNgSoPFNzdPzrOd7lG79bQOZvwF2lJWdMLwtF6I1yyx9MjibR9H7vMsICfb4o
         Qe4nvD+mcznp4CwBx6c4//7d2RXi6ghYCIWOmiMD9u4l/lB49W4A/ZgS7lRKT6vjYMoX
         bNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+9lhk6bNnduoLFvxQOj6r1ZdbN7Net/4PT8u3Z4AhvU=;
        b=pZ4tIWbef+LjLr6cnwd/SxkUUewCE/sYWsw/ex5t3+0GGzcYh74/+tOeRvSPVXO+oT
         wqw4CtGC4x8qQJDdMA0VI/rGlR+mY372CZwk9WHKXTZul4BYIQ35bkTqKwOgWScCLWXu
         HCSjvyvaF/XDzX/Fz0wcCvAyU5n0WTghW91AYutJhqprvHfPWkhc08U2JbijviBrP69n
         QL4L/VSVEyMv5iki1Usfm4yNEtwivmovXddkG84viOtf5egR5TzExUmYzE9P3N4jN3DU
         rzfcmXTmqQboVXZwSqNUpx/lVks0BVkK0ZoEaHxPrFEMzOa1e1GMrGM5xHhze1K7cyq+
         d8tQ==
X-Gm-Message-State: APjAAAXzExYqEfuNYUeGq5Ubkm6vHlVAcp91p9oDecEFKKIpZFc/kIOw
        CEg5VEgQHX3/MOfTs9M=
X-Google-Smtp-Source: APXvYqy9kn3ufFebCKN1BNNGfXHO8rTtRj5OcTg2D6zf28GI90gSfW4WcCA6pxp16EzZruJ9jxpRbw==
X-Received: by 2002:a05:600c:284:: with SMTP id 4mr19650665wmk.12.1563123396667;
        Sun, 14 Jul 2019 09:56:36 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-178-201-112-148.hsi08.unitymediagroup.de. [178.201.112.148])
        by smtp.gmail.com with ESMTPSA id c30sm22410872wrb.15.2019.07.14.09.56.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 14 Jul 2019 09:56:36 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org, andrew@lunn.ch
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: correct a few typos
Date:   Sun, 14 Jul 2019 18:56:27 +0200
Message-Id: <20190714165627.32765-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct a few typos in comments and debug text.

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index aba6eea72..6e07f5eba 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -262,7 +262,7 @@ static int sis900_get_mac_addr(struct pci_dev *pci_dev,
 	/* check to see if we have sane EEPROM */
 	signature = (u16) read_eeprom(ioaddr, EEPROMSignature);
 	if (signature == 0xffff || signature == 0x0000) {
-		printk (KERN_WARNING "%s: Error EERPOM read %x\n",
+		printk (KERN_WARNING "%s: Error EEPROM read %x\n",
 			pci_name(pci_dev), signature);
 		return 0;
 	}
@@ -359,9 +359,9 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
  *
  *	SiS962 or SiS963 model, use EEPROM to store MAC address. And EEPROM
  *	is shared by
- *	LAN and 1394. When access EEPROM, send EEREQ signal to hardware first
+ *	LAN and 1394. When accessing EEPROM, send EEREQ signal to hardware first
  *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be accessed
- *	by LAN, otherwise is not. After MAC address is read from EEPROM, send
+ *	by LAN, otherwise it is not. After MAC address is read from EEPROM, send
  *	EEDONE signal to refuse EEPROM access by LAN.
  *	The EEPROM map of SiS962 or SiS963 is different to SiS900.
  *	The signature field in SiS962 or SiS963 spec is meaningless.
-- 
2.17.1

