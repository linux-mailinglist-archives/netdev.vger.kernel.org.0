Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5EAC20B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404327AbfIFVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:31:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43866 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404164AbfIFVbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:31:32 -0400
Received: by mail-io1-f66.google.com with SMTP id u185so15991214iod.10;
        Fri, 06 Sep 2019 14:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=26yRkKngdeGZdYrj7tLUW2NHxKx3LhkS3JePK0gY+8A=;
        b=eQaw1beEZr2GTZtMQnwD4KoxcrO7wW+xNyWWkrP2z15GUpMkkEapVjQ5w4SEAkrgCO
         JX4dYw7L8W1ldVldtUTF1hOTmCYawc2cJF4QqsVbi7Z/6m/I3RzqmfWu/aIJjLV7Udpv
         0OT0FkVKdko1sg8GJUu5/LuSqn5bFMptposIKM54yDJR2zsnmeV6koBfyVkTDZxmd6py
         u4yrGx/h2XPaHO1twcAz4NfRFPGfDQL0RWq2/he7dLycoq64oF2Mu7FOjvJWdEJfBLHv
         2tX90211ztFSB1Os14T6P2lbrWzDWeu8tzMmjGPpzRLtz805qGw5UHORPK8fzVI439Ya
         J2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=26yRkKngdeGZdYrj7tLUW2NHxKx3LhkS3JePK0gY+8A=;
        b=ta7TGR0+XX28UXXyvtgiPBemPQHeKmTTbMntpZttrInz9JB4QSdfs1grruOY3080iS
         A3kq7ZUIknSqDNvr76x/zu4NGTE9TVa9Q8GBaw3V4SdP/Vj3mjMoMnzxWvQTWyIiCPcB
         0NRx3VmjJlEItChgrcUyv0n/mJ0ZtVdNWfhvStPXMAQDVsCSzp9jL/Vw2Cm5LxeosJ1p
         C1wHYqnSt+KNmSwof0DIN4oyfFGTyLufnbW8YhSrwqztSeurm8IlAdx+KWnsN1KciS2b
         Y5/bq8PX10vqq3Eg2kS34HXSTcOM3NodW4yOjlueiPVQ5Xi4arqZhyg8aJ1JXgwWCuEt
         iUkw==
X-Gm-Message-State: APjAAAV0P+cDNtskwiHEWHl8YAGpV058o5m8AtEqbu3j3yYQuPAZ7444
        BcuonO+AW+KGn/g2E7iExn2yItO5+g==
X-Google-Smtp-Source: APXvYqzcCiaPEcke/zEYQ0pYn1CgYsKteKJ06NbqPe0dchKECo4QjXZDiChHP9gfa1tKb+fBtG9SVA==
X-Received: by 2002:a5d:8506:: with SMTP id q6mr598789ion.43.1567805491405;
        Fri, 06 Sep 2019 14:31:31 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r2sm4158110ioh.61.2019.09.06.14.31.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 14:31:31 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: microchip: remove NET_DSA_TAG_KSZ_COMMON
Date:   Fri,  6 Sep 2019 16:30:54 -0500
Message-Id: <20190906213054.48908-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906213054.48908-1-george.mccollister@gmail.com>
References: <20190906213054.48908-1-george.mccollister@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the superfluous NET_DSA_TAG_KSZ_COMMON and just use the existing
NET_DSA_TAG_KSZ. Update the description to mention the three switch
families it supports. No functional change.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/dsa/Kconfig  | 9 ++-------
 net/dsa/Makefile | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2f69d4b53d46..29e2bd5cc5af 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -73,16 +73,11 @@ config NET_DSA_TAG_MTK
 	  Say Y or M if you want to enable support for tagging frames for
 	  Mediatek switches.
 
-config NET_DSA_TAG_KSZ_COMMON
-	tristate
-	default n
-
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 9893 family of switches"
-	select NET_DSA_TAG_KSZ_COMMON
+	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 9893 family of switches.
+	  Microchip 8795/9477/9893 families of switches.
 
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index c342f54715ba..2c6d286f0511 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
-obj-$(CONFIG_NET_DSA_TAG_KSZ_COMMON) += tag_ksz.o
+obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
-- 
2.11.0

