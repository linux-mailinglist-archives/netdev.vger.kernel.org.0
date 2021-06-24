Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1793B31D6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhFXO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhFXO6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:58:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F6BC061574;
        Thu, 24 Jun 2021 07:55:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h2so8985948edt.3;
        Thu, 24 Jun 2021 07:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OTyJyw/htMO1AJRTiqLNMT+bM+APi/6nePJGAuCnKuo=;
        b=QPbH8Y0VnStaK5O89g2nrwrNN5J0s5bfhGzIO4itFkEgwj8CclZ4Ga7IvsjkXvrwgW
         SA97Axc3KveRv3pk/yAZepAi2V6UCCghIzxJratOvWrCX3eWktpMcS7b3a+8l8Q4i2rT
         y4+sS3nXeZtlAtxratWy3c/aeF7YDtIapTa+dDHw9i5S2r+kIsbkbqW5+F7i2DKY/v5v
         FQNUl77flGdQZEukyQoGees8vWPw+Vydal77GbCFhGsWU1esVwW8sDMxE7Om9LAwyUSk
         abfH0wl5ESRQsE5g0UrNAddPJEaGwKXEv12GUnDWEDz3fr3HtWXOW9upPJ9l1TsXEyKf
         F6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTyJyw/htMO1AJRTiqLNMT+bM+APi/6nePJGAuCnKuo=;
        b=SOZf7rAy7/74lRzNMeyi8b4uGf/HFpYIyrxzwNaf1wzuo/F0X55N/ajh8O31Zxu2Hj
         jkxXavxpZib+hj0IpAE+GXyCYInGDEQquIm70hH+DFs7nTwNVVk6c9rPriJgJXKyI1AN
         FFblAML4U0hhLcYuy3iaqDvpiI8VbcVV3rYXaoclJRmtvjf/0YpzhWFsCoG1lMT/ZUje
         8zjoHEYLsfgQ2GPL622r8QKSGZK3aI1vN1V7PDDpll7DA1cuv2oS0Um2ZIOYiOTNu8uj
         ksMb6XAP/S/2U8Wktfap/DdsknM/cI3RAeik0NGppzXZwUq8ESiDuK+HrBoDrec55V4p
         loCA==
X-Gm-Message-State: AOAM530TK/bZnLz1VfcpXsI/0DyY5sZBKrTiPHR8DPbvSUoFQhcw3QnR
        aYuZBZBc8oV628MpsFXpEFA=
X-Google-Smtp-Source: ABdhPJypUVd6MVY4SDNAARmzzWBKlMDaIUg0/n63hwpAF/qvc3fcA0N9SR3X1S71H6VwhmZHcDpoZg==
X-Received: by 2002:aa7:d9cc:: with SMTP id v12mr7753769eds.232.1624546544524;
        Thu, 24 Jun 2021 07:55:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n2sm2034061edi.32.2021.06.24.07.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:55:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: document the SJA1110 in the Kconfig
Date:   Thu, 24 Jun 2021 17:55:24 +0300
Message-Id: <20210624145524.944878-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210624145524.944878-1-olteanv@gmail.com>
References: <20210624145524.944878-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Mention support for the SJA1110 in menuconfig.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 8383cd6d2178..b29d41e5e1e7 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -7,8 +7,8 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	select PACKING
 	select CRC32
 	help
-	  This is the driver for the NXP SJA1105 automotive Ethernet switch
-	  family. These are 5-port devices and are managed over an SPI
+	  This is the driver for the NXP SJA1105 (5-port) and SJA1110 (10-port)
+	  automotive Ethernet switch family. These are managed over an SPI
 	  interface. Probing is handled based on OF bindings and so is the
 	  linkage to PHYLINK. The driver supports the following revisions:
 	    - SJA1105E (Gen. 1, No TT-Ethernet)
@@ -17,6 +17,10 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1105Q (Gen. 2, No SGMII, TT-Ethernet)
 	    - SJA1105R (Gen. 2, SGMII, No TT-Ethernet)
 	    - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
+	    - SJA1110A (Gen. 3, SGMII, TT-Ethernet, 100base-TX PHY, 10 ports)
+	    - SJA1110B (Gen. 3, SGMII, TT-Ethernet, 100base-TX PHY, 9 ports)
+	    - SJA1110C (Gen. 3, SGMII, TT-Ethernet, 100base-TX PHY, 7 ports)
+	    - SJA1110D (Gen. 3, SGMII, TT-Ethernet, no 100base-TX PHY, 7 ports)
 
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
-- 
2.25.1

