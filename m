Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50722F0ABD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 02:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbhAKBWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 20:22:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbhAKBWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 20:22:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C3922472;
        Mon, 11 Jan 2021 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610328130;
        bh=cvbAsuhaLg/5bw9/9alRa9UPb27yJCAE2f55+kF0euk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcvXRF/MGsAzurHp82uswko+8y7uMAMTFAHxPamVSPiYbHSzMU3PbJcO/bN9bN3FP
         OjEfkqmwU7et7zVxb7ecbHrKr7Aoh690f0S8yEUODKGaHbV3GDTH0oumKY5+j0gsNg
         keWSTUJa9H/6U7LDY3t9xyMu0awa6pdZAsn0olC43t013LMvFrrrwErPpak4bs4o8D
         CX3knEhGUDWovVYafDVKuUsxFcbkhLAxU6qja0i0qEmvPrFgNYSW3pBS7IJ/4P9Y5/
         BIeGKNFsYBaBRh2lHHGKlEf3i5U/aiBaDzBZ5O5wgSOHzU66XqSg8XJb4HAEIh80gS
         1AI2NevhQN4zA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v14 2/6] net: phy: Add 5GBASER interface mode
Date:   Mon, 11 Jan 2021 02:21:52 +0100
Message-Id: <20210111012156.27799-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111012156.27799-1-kabel@kernel.org>
References: <20210111012156.27799-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavana Sharma <pavana.sharma@digi.com>

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Marek Behún <kabel@kernel.org>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511acde..548372eb253a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -207,6 +209,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.26.2

