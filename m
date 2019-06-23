Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8884FAAD
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfFWHrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:47:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38451 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFWHrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:47:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so10536185wrs.5
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 00:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5HNlgdempNROc7wE8vJ/Gwgy93opOAwBbmjcYw4apw0=;
        b=CSQajxwGCFgtzSTAbokR4FwDQOob2rJMdfCvj6Wj/wbeByHzxTqgRItD+9mF57Q3P9
         ujKW2ViB0ixav+L2mEf15+zVVGuonhDknkMrSSmTbwzYvstWj/da3dQtHTIMbZBb8gwY
         00JcTqDFjLljPikjx9VLCdyxBXBou3RSdVPb34kjV452xVlTT/SaD8KpujnHMLy+tfEA
         KG4IK66IjItrjDeYm9BYYi1ETQaO0Lqr5Q6BXgnd92ofeIWfPgjtsEXPtRLG22442XCb
         NXGLOR/SNcBu+qE1XETOLOvZzUa46pmgdubm/Uq0v00mMnCSCXixQwI29DF33NQEqcTs
         s7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5HNlgdempNROc7wE8vJ/Gwgy93opOAwBbmjcYw4apw0=;
        b=lafGR9Lz+v8g7/79PbSROcSRBZQPdzn+Zm1+hQKAg22IJUSGL8s9N5yd96Rqii24iK
         MMGkmWTJj5APQNquf3VWJHd4flDAOa8J25GOg/XNI7Umq2pCf4z0FJ4N9FMz2FVtKRav
         ZYpn8j8cz2wRdBbrbSOJ92O1QLHU1z5g6JR1Xi5tiMCmbtBORaImkWrf63/aJ0KEDC23
         OBtHZyNn9Tnoo9lbj3LZW/XLzCqDibvQy8bWrLBt74HsogCwzBpPdHVEoH2miJV5c8kS
         8nm2iEUQRcyQ6/sKBl9t3dEZ8cdaNtfRmfdYpPHXMqkcz5irDWq2rPJy7jdtFnXjZyW7
         iCfQ==
X-Gm-Message-State: APjAAAWWzY6dW+X201YBAIobK7qdiARWvQIe0ReLH/rYEvI26XoU6QkJ
        eQ3QFwOfOmZQwA==
X-Google-Smtp-Source: APXvYqxAJ1vhLLFBvfw6ArIsSPj6aEMot0AXQw202FZMh6npMC67hF6MmMB6tPfOvbIphjydjqII9A==
X-Received: by 2002:adf:fdc2:: with SMTP id i2mr54313450wrs.146.1561276057931;
        Sun, 23 Jun 2019 00:47:37 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id 90sm15387428wrn.97.2019.06.23.00.47.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 00:47:37 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: increment revision number
Date:   Sun, 23 Jun 2019 09:47:07 +0200
Message-Id: <20190623074707.6348-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment revision number to 1.08.11 (TX completion fix).

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index abb9b42e..09b4e1c5 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1,6 +1,6 @@
 /* sis900.c: A SiS 900/7016 PCI Fast Ethernet driver for Linux.
    Copyright 1999 Silicon Integrated System Corporation
-   Revision:	1.08.10 Apr. 2 2006
+   Revision:	1.08.11 Jun. 23 2019
 
    Modified from the driver which is originally written by Donald Becker.
 
@@ -16,7 +16,8 @@
    preliminary Rev. 1.0 Nov. 10, 1998
    SiS 7014 Single Chip 100BASE-TX/10BASE-T Physical Layer Solution,
    preliminary Rev. 1.0 Jan. 18, 1998
-
+   
+   Rev 1.08.11 Jun. 23 2019 Sergej Benilov TX completion fix
    Rev 1.08.10 Apr.  2 2006 Daniele Venzano add vlan (jumbo packets) support
    Rev 1.08.09 Sep. 19 2005 Daniele Venzano add Wake on LAN support
    Rev 1.08.08 Jan. 22 2005 Daniele Venzano use netif_msg for debugging messages
@@ -79,7 +80,7 @@
 #include "sis900.h"
 
 #define SIS900_MODULE_NAME "sis900"
-#define SIS900_DRV_VERSION "v1.08.10 Apr. 2 2006"
+#define SIS900_DRV_VERSION "v1.08.11 Jun. 23 2019"
 
 static const char version[] =
 	KERN_INFO "sis900.c: " SIS900_DRV_VERSION "\n";
-- 
2.17.1

