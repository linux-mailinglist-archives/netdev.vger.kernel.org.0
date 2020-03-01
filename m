Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE8174FBD
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 21:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCAU5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 15:57:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52385 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgCAU5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 15:57:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so9010287wmc.2
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 12:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0OGCgsunf9EvquF6Ai13UgGPqjgXcqRb6OOTuXW/MJU=;
        b=ejOeqDwwvwmgPSxDmT+9R9yug/rYwR1WGBszljH6ZWs1HhT5qod9k/gKdjIZ/Asxog
         a6SvrW1n3ABa81OiiQznrTrsR09hje7jb2moz+Vyscxkk0rHG+dF3f0ebfwsDWVBdR7C
         AARsGoqzthVWJhYJxf/gpW0cwvjz9J0icHQkea7SZBEEddm2hbNhdGwtGtHhUsUQUx1Q
         YUGhcwBXdDDkWVTJEYW6kCFKbxcQn0DIxdGOZctsnY4GKln9TFXxEz+/jQ8oS6bJd+nJ
         R0VT11TURfLsx5/bkAi/G/L+oeg61K95o9xzR85Jpe31GJEPkgEvBel9Ymz5Alwemo3j
         a1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0OGCgsunf9EvquF6Ai13UgGPqjgXcqRb6OOTuXW/MJU=;
        b=IP5p2HGzzi605/fmnVn6XtveZFv7qz2SWXNwBrQm7V/XVsySEsJXzUa3k651jqT0xr
         K+dB59GO1S2nxrjKgmHcMPSsRizn0F0y4SG3eDomMyusoij1/6zlEHEQM0bbzJ4sZEGk
         0tbkN+0Now0BGmB0MQI85BOc4qcD4ikxvZ8GE/l5sqTI6VjiKvoW1ID6TPV07dNybr0g
         QyASd+4IIHXqJXE1kV3sR4qWjPkXxmsO1zqSmppZV5GVzBNhhJN3bAu0o3VVIkdknNwN
         v11sLHgjoMJHBDuEm6hCSG6hbUtOFvfcz1g7u9eMNIUNWp0YfDrFbgqZtUEdBO2wVy/y
         Y+jg==
X-Gm-Message-State: APjAAAU5/U7AtQSwrHr2T0ojnUVnvv+1jPDYYRyQ0NQeWkf2ADj/74xz
        wTHgwRrjqGsiuYdv9w/+WthRTALk
X-Google-Smtp-Source: APXvYqx1nzK64HNL/tu7Ogg6Tw5oXxL3xa0v310HKl1NAXTetghNTytQ75H9LSiVta2a5J28rZMD/g==
X-Received: by 2002:a05:600c:104d:: with SMTP id 13mr15688411wmx.50.1583096234843;
        Sun, 01 Mar 2020 12:57:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:f915:e49c:5a8a:4fcb? (p200300EA8F296000F915E49C5A8A4FCB.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f915:e49c:5a8a:4fcb])
        by smtp.googlemail.com with ESMTPSA id z9sm11209588wrh.91.2020.03.01.12.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 12:57:14 -0800 (PST)
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: mscc: add constants for used interrupt
 mask bits
Message-ID: <6503f7cf-477d-954b-ab7c-c9805cfa3692@gmail.com>
Date:   Sun, 1 Mar 2020 21:57:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add constants for the used interrupts bits. This avoids the magic
number for MII_VSC85XX_INT_MASK_MASK.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mscc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 8b1535c4d..32b551cbb 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -80,10 +80,16 @@ enum rgmii_rx_clock_delay {
 #define MSCC_PHY_EXT_PHY_CNTL_2		  24
 
 #define MII_VSC85XX_INT_MASK		  25
-#define MII_VSC85XX_INT_MASK_MASK	  0xa020
-#define MII_VSC85XX_INT_MASK_WOL	  0x0040
+#define MII_VSC85XX_INT_MASK_MDINT	  BIT(15)
+#define MII_VSC85XX_INT_MASK_LINK_CHG	  BIT(13)
+#define MII_VSC85XX_INT_MASK_WOL	  BIT(6)
+#define MII_VSC85XX_INT_MASK_EXT	  BIT(5)
 #define MII_VSC85XX_INT_STATUS		  26
 
+#define MII_VSC85XX_INT_MASK_MASK	  (MII_VSC85XX_INT_MASK_MDINT    | \
+					   MII_VSC85XX_INT_MASK_LINK_CHG | \
+					   MII_VSC85XX_INT_MASK_EXT)
+
 #define MSCC_PHY_WOL_MAC_CONTROL          27
 #define EDGE_RATE_CNTL_POS                5
 #define EDGE_RATE_CNTL_MASK               0x00E0
-- 
2.25.1

