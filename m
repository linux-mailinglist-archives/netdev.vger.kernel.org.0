Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8689F1836FE
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCLRLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:11:14 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:57816 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726610AbgCLRLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:11:13 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6A53742811;
        Thu, 12 Mar 2020 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584033073; bh=abwk2yud7QwjDJOyU50WeyPy+p3/jpJNUXfcqJc6hhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=bmtGEnxwDMOIzhys6tmt2m0uUCdEwd+2FfyMR5D1L5ugCRaNVXKHku2UJWNjR3kcx
         SDXZTL66lUDNt+YU/aPmB+ke2l6gT1t3cwMJg6RkUvwparmKKeREnAfSaWghks+W35
         YpO7zylZT2IVYcv1axmGJbWvgivOSSLu+Rdkp+s4nwpMIrllWiaNkZ6DzPfgaKf1TZ
         vCjTU9K1T22HI+0m5DPOgYPet/usj4+w5ur5MzqxhYSZfW/VuL9zE/TbzqFL1KeayA
         mart8YftuKDC5A8nUBwqm14uiAebpzjugD4uOJhZkBOUKlZrzgBiVP9vWSGWwkicDU
         9VYRcc1vmzthQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C4832A0063;
        Thu, 12 Mar 2020 17:11:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: phy: Add XLGMII interface define
Date:   Thu, 12 Mar 2020 18:10:09 +0100
Message-Id: <279342f40d5f26e1f9d7752f2fb376e5d4cecf2b.1584031294.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584031294.git.Jose.Abreu@synopsys.com>
References: <cover.1584031294.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584031294.git.Jose.Abreu@synopsys.com>
References: <cover.1584031294.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a define for XLGMII interface.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index e72dbd0d2d6a..fb62f1469aa2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -94,6 +94,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_RTBI,
 	PHY_INTERFACE_MODE_SMII,
 	PHY_INTERFACE_MODE_XGMII,
+	PHY_INTERFACE_MODE_XLGMII,
 	PHY_INTERFACE_MODE_MOCA,
 	PHY_INTERFACE_MODE_QSGMII,
 	PHY_INTERFACE_MODE_TRGMII,
@@ -165,6 +166,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "smii";
 	case PHY_INTERFACE_MODE_XGMII:
 		return "xgmii";
+	case PHY_INTERFACE_MODE_XLGMII:
+		return "xlgmii";
 	case PHY_INTERFACE_MODE_MOCA:
 		return "moca";
 	case PHY_INTERFACE_MODE_QSGMII:
-- 
2.7.4

