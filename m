Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74B339FCA
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFHND4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:03:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39895 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfFHNDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:03:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so4276194wma.4
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kH7cTNKzXAl7w0isQMDYh/vyxa08pdn3kODTCppe4Lg=;
        b=d7oakhBlFJ7Vf8aXiDAHodLWg23ISQj0Vml/BD91OUSCNgSyeaNdQ2dHCk73SCzDVJ
         xa00RRP4AXXevjqqUGI1UmeR2VILbG4jgeefan0U7ZQGx5lfJzcPtnPJtcXex9YMuGo9
         1mtaVAr9FItHhk5W5BmW1r77utgqn+VGGDHfwuYVz/7HBN6nk/0fW+BwGA5f9b1QzQCT
         oM+97gzZUBVoORA82wC4OcqQOv4n0XcUt5CfBEQROP4B4keQJOrDdEKpowlJc8GhHm1N
         cafiY+IlOGXnmBe7NKhUmcCy96rXE54riRZytgB9TghwpK7d9TiVTEtDQViph469VCJ6
         d9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kH7cTNKzXAl7w0isQMDYh/vyxa08pdn3kODTCppe4Lg=;
        b=XDyM2F2GB9ETLy8PH3XCldCjbrmocY0qpgfZrSDIRy4ZcDlFtK9/skEwCP8YPkAJ84
         Ols1ZrROlwiKaAygre2EKMmZlDKmPUq+z7MKfeoqTlpaqlEoah3rrKWOoiiOcC4npvy1
         cfnIfnRUIgo67ncDVlTvRyXvJ2aF/lfpeXJyYdfisaI0WlJMFX31cLVssPxca/uZIA6J
         HxERGZJxovnIZelQMbWfFMDsCoH4qrKPwr65FpO9BKq3HS8qOhSgJ9AavO+kQSkEOf3K
         WDLo6s8elpNiY2METt463ief1VBXv5wTvauG8bjXuPPrlOmpzCiDPqXSl8w3SsoMyIW1
         hA6g==
X-Gm-Message-State: APjAAAWzOz9uw4rs7An+PegktaScOb2UpgGwi8hg3W/aSnm8Ay0E5W59
        08fVT4fQTp/65eEZLvOJnwk=
X-Google-Smtp-Source: APXvYqwq/a6D4bBbug3L9CiA6ekvy31UnEpTZJ84jhd3DGcfrb9NZWwsuDAslZEB7VoKVCb465aIpw==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr1347477wmk.5.1559999032288;
        Sat, 08 Jun 2019 06:03:52 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id 128sm4632766wme.12.2019.06.08.06.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:03:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/4] net: dsa: sja1105: Update some comments about PHYLIB
Date:   Sat,  8 Jun 2019 16:03:42 +0300
Message-Id: <20190608130344.661-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608130344.661-1-olteanv@gmail.com>
References: <20190608130344.661-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver is now using PHYLINK exclusively, it makes sense to
remove all references to it and replace them with PHYLINK.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig        | 2 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 049cea8240e4..105e8d3e380e 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -9,7 +9,7 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	  This is the driver for the NXP SJA1105 automotive Ethernet switch
 	  family. These are 5-port devices and are managed over an SPI
 	  interface. Probing is handled based on OF bindings and so is the
-	  linkage to phylib. The driver supports the following revisions:
+	  linkage to PHYLINK. The driver supports the following revisions:
 	    - SJA1105E (Gen. 1, No TT-Ethernet)
 	    - SJA1105T (Gen. 1, TT-Ethernet)
 	    - SJA1105P (Gen. 2, No SGMII, No TT-Ethernet)
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 580568922f35..d7f4dbfdb15d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -70,8 +70,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		/* Keep standard IFG of 12 bytes on egress. */
 		.ifg = 0,
 		/* Always put the MAC speed in automatic mode, where it can be
-		 * retrieved from the PHY object through phylib and
-		 * sja1105_adjust_port_config.
+		 * adjusted at runtime by PHYLINK.
 		 */
 		.speed = SJA1105_SPEED_AUTO,
 		/* No static correction for 1-step 1588 events */
@@ -116,7 +115,6 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 	if (!table->entries)
 		return -ENOMEM;
 
-	/* Override table based on phylib DT bindings */
 	table->entry_count = SJA1105_NUM_PORTS;
 
 	mac = table->entries;
@@ -157,7 +155,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 	if (!table->entries)
 		return -ENOMEM;
 
-	/* Override table based on phylib DT bindings */
+	/* Override table based on PHYLINK DT bindings */
 	table->entry_count = SJA1105_MAX_XMII_PARAMS_COUNT;
 
 	mii = table->entries;
-- 
2.17.1

