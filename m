Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185EB382924
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhEQKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:00:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34580 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbhEQJ7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:59:52 -0400
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1lia1D-0002S2-IP
        for netdev@vger.kernel.org; Mon, 17 May 2021 09:58:35 +0000
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a0564020950b029038cbdae8cbaso3592091edz.6
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S1hixJXRBnAuYfS34qwOSOa+37qwmbzyMLfpr9/CNNY=;
        b=tcQj+SFZggXgjtH9JWUw48G2PwSL8r496tnjC/S+UqToTpi8/nUfjtGeWofR4GRB5P
         Mc23YWeDdTFPxmMhdSTclgkS1UNThgaxsy6VSz9fmcDo0PRoNE/c+DsK9HgAV7oH3pku
         8eN/hyJu1/Zsdy7sEvdzXtzWmvfZabK3q795Y+4qm876dWNnO2S8EM/iRCIb+Q3HQyke
         E5s4DFKFQZfVNOqPyYJki+mqdrVDkkkHfQknmczGWUI3CDjhvKOZcMteAxbWUhQlHUb2
         YR3sXh5N49+g53ENN8LLpGdmstn08YvdkBJPHkI6XAVmm+JxD5Bhi6AAIBKcfDYv8wju
         MMRw==
X-Gm-Message-State: AOAM530W8xolBh8BPhlqMepTb6H0qpfAZ5B/LvFMV7F/KJlebV4aOjha
        ScfrlKb4fNr7ukm/fIDq6gU7xLatrBGg1ZF08Bz/Tpr4cX7CP1Ujv9x2QVvwKlVYlvtOEmHh2ud
        65v0eIgoVH7Ls0zPPE8aAOwJroa7XHgCNsw==
X-Received: by 2002:a17:906:aac8:: with SMTP id kt8mr8323480ejb.402.1621245515282;
        Mon, 17 May 2021 02:58:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxihu71PQJinwnPLesofvKtoWr/e4cHWmOZUdXpwvJfKhflr8ymd0rE726XY/CayNammMGrFw==
X-Received: by 2002:a17:906:aac8:: with SMTP id kt8mr8323465ejb.402.1621245515117;
        Mon, 17 May 2021 02:58:35 -0700 (PDT)
Received: from gollum.fritz.box ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id z7sm11245004edi.39.2021.05.17.02.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:58:34 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, juergh@canonical.com
Subject: [PATCH] drivers/net: Remove leading spaces in Kconfig
Date:   Mon, 17 May 2021 11:58:33 +0200
Message-Id: <20210517095833.81681-1-juergh@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove leading spaces before tabs in Kconfig file(s) by running the
following command:

  $ find drivers/net -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 drivers/net/usb/Kconfig | 10 +++++-----
 drivers/net/wan/Kconfig |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index fbbe78643631..179308782888 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -169,7 +169,7 @@ config USB_NET_AX8817X
 	  This option adds support for ASIX AX88xxx based USB 2.0
 	  10/100 Ethernet adapters.
 
- 	  This driver should work with at least the following devices:
+	  This driver should work with at least the following devices:
 	    * Aten UC210T
 	    * ASIX AX88172
 	    * Billionton Systems, USB2AR
@@ -220,13 +220,13 @@ config USB_NET_CDCETHER
 	  CDC Ethernet is an implementation option for DOCSIS cable modems
 	  that support USB connectivity, used for non-Microsoft USB hosts.
 	  The Linux-USB CDC Ethernet Gadget driver is an open implementation.
- 	  This driver should work with at least the following devices:
+	  This driver should work with at least the following devices:
 
 	    * Dell Wireless 5530 HSPA
- 	    * Ericsson PipeRider (all variants)
+	    * Ericsson PipeRider (all variants)
 	    * Ericsson Mobile Broadband Module (all variants)
- 	    * Motorola (DM100 and SB4100)
- 	    * Broadcom Cable Modem (reference design)
+	    * Motorola (DM100 and SB4100)
+	    * Broadcom Cable Modem (reference design)
 	    * Toshiba (PCX1100U and F3507g/F3607gw)
 	    * ...
 
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 83c9481995dd..473df2505c8e 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -49,7 +49,7 @@ config COSA
 	  network device.
 
 	  You will need user-space utilities COSA or SRP boards for downloading
- 	  the firmware to the cards and to set them up. Look at the
+	  the firmware to the cards and to set them up. Look at the
 	  <http://www.fi.muni.cz/~kas/cosa/> for more information. You can also
 	  read the comment at the top of the <file:drivers/net/wan/cosa.c> for
 	  details about the cards and the driver itself.
@@ -108,7 +108,7 @@ config HDLC
 	  Generic HDLC driver currently supports raw HDLC, Cisco HDLC, Frame
 	  Relay, synchronous Point-to-Point Protocol (PPP) and X.25.
 
- 	  To compile this driver as a module, choose M here: the
+	  To compile this driver as a module, choose M here: the
 	  module will be called hdlc.
 
 	  If unsure, say N.
-- 
2.27.0

