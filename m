Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F912E7972
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbfJ1Tyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:54:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36737 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfJ1Tye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:54:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id c22so217780wmd.1
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ifHZq9hoKmRAhlvzVIgkxLAJzygRJrQS2ZczbFWMxNk=;
        b=dzGNVMthTGCcuDFGYcOIPrtPfFEOsPZgVwrIj4ehuxItn91UmQWFgM00ee5Anfhxpz
         qjol6l4ZF51q+Ebavdp3Q5D/2AL6iyS7F6LtJk/JEt7CjAjFdt1dGFFEa9I25lOrk+v6
         IFVEjanefbb3aKM9fgR77kC8ZW6JOk9q1Bn1ZEBWAdpRYNrWhBScrwv1Qxi/k4SALFGm
         Zad8sZKl1e1jK1t2kVshsTa2Hc9uhVJRZkT02wa7PnGSkQMQyfbIqN4TZKbnjpxNyEOa
         UPzEcWXiXOFK5DpR0yQ7y6al0JCeo2DH2lXycL3zFgCG99gR5y4v923bXbwseh/d6YlN
         24vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifHZq9hoKmRAhlvzVIgkxLAJzygRJrQS2ZczbFWMxNk=;
        b=A/2WB1UF+/TcdSZQSCYowRf3OTkxViIxaX7lELnULxJ9OdCA7oGS7vhrsBNzpi4PO6
         NhaEasqcQheXZYjNsZvBE8TKT+zaBKH9QrNIWZHOPrJMnkh0H0mx/XawZvSP3Oc2mSvs
         M/HW5iVVRv9+V2+EMoZPw+ZBpcDz9+o6tWvs2yKg1b/moJh0O7lcOoEkqdXQJwtL0VyC
         x8NFezQmvPM3I4J3oSss+Dy+v/lMxcPcEblHjaGuRgOTcln79JKK/TFdc/TPZ2lFE/Vm
         oFrU/nuMc5KsPIJamvQxT1m/L3ZJrZmYRmbMFMbg762CJrwPDlgWKCIVqDKEXygGodog
         ZcPg==
X-Gm-Message-State: APjAAAWXD5+USGK8cEDZZ6+ewH+hTQ9rhHMe27MCHR6HPqxKWP3OUTzA
        B/ACahcgaKla0xtqfDrTdjk=
X-Google-Smtp-Source: APXvYqxhxCGqvXqHqmcmh2Ie2R+qINuECy6Wp8eNEtSfsfFAk/iEMfqgy3ccpmN7fxg5DGZHpgr3/g==
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr832047wmh.39.1572292472430;
        Mon, 28 Oct 2019 12:54:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id r19sm14748747wrr.47.2019.10.28.12.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:54:32 -0700 (PDT)
Subject: [PATCH net-next 2/4] net: phy: marvell: fix downshift function naming
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Message-ID: <2cf44878-02e5-3f0f-6eec-cc9d51a18127@gmail.com>
Date:   Mon, 28 Oct 2019 20:52:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got access to the M88E1111 datasheet, and this PHY version uses
another register for downshift configuration. Therefore change prefix
to m88e1011, aligned with constants like MII_M1011_PHY_SCR.

Fixes: a3bdfce7bf9c ("net: phy: marvell: support downshift as PHY tunable")
Reported-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e77fc25ba..68ef84c23 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -784,7 +784,7 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
-static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
+static int m88e1011_get_downshift(struct phy_device *phydev, u8 *data)
 {
 	int val, cnt, enable;
 
@@ -800,7 +800,7 @@ static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
 	return 0;
 }
 
-static int m88e1111_set_downshift(struct phy_device *phydev, u8 cnt)
+static int m88e1011_set_downshift(struct phy_device *phydev, u8 cnt)
 {
 	int val;
 
@@ -820,29 +820,29 @@ static int m88e1111_set_downshift(struct phy_device *phydev, u8 cnt)
 			  val);
 }
 
-static int m88e1111_get_tunable(struct phy_device *phydev,
+static int m88e1011_get_tunable(struct phy_device *phydev,
 				struct ethtool_tunable *tuna, void *data)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
-		return m88e1111_get_downshift(phydev, data);
+		return m88e1011_get_downshift(phydev, data);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static int m88e1111_set_tunable(struct phy_device *phydev,
+static int m88e1011_set_tunable(struct phy_device *phydev,
 				struct ethtool_tunable *tuna, const void *data)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
-		return m88e1111_set_downshift(phydev, *(const u8 *)data);
+		return m88e1011_set_downshift(phydev, *(const u8 *)data);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static void m88e1111_link_change_notify(struct phy_device *phydev)
+static void m88e1011_link_change_notify(struct phy_device *phydev)
 {
 	int status;
 
@@ -875,7 +875,7 @@ static int m88e1116r_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	err = m88e1111_set_downshift(phydev, 8);
+	err = m88e1011_set_downshift(phydev, 8);
 	if (err < 0)
 		return err;
 
@@ -1177,7 +1177,7 @@ static int m88e1540_get_tunable(struct phy_device *phydev,
 	case ETHTOOL_PHY_FAST_LINK_DOWN:
 		return m88e1540_get_fld(phydev, data);
 	case ETHTOOL_PHY_DOWNSHIFT:
-		return m88e1111_get_downshift(phydev, data);
+		return m88e1011_get_downshift(phydev, data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1190,7 +1190,7 @@ static int m88e1540_set_tunable(struct phy_device *phydev,
 	case ETHTOOL_PHY_FAST_LINK_DOWN:
 		return m88e1540_set_fld(phydev, data);
 	case ETHTOOL_PHY_DOWNSHIFT:
-		return m88e1111_set_downshift(phydev, *(const u8 *)data);
+		return m88e1011_set_downshift(phydev, *(const u8 *)data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2283,9 +2283,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
-		.get_tunable = m88e1111_get_tunable,
-		.set_tunable = m88e1111_set_tunable,
-		.link_change_notify = m88e1111_link_change_notify,
+		.get_tunable = m88e1011_get_tunable,
+		.set_tunable = m88e1011_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2425,7 +2425,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
-		.link_change_notify = m88e1111_link_change_notify,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -2488,7 +2488,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
-		.link_change_notify = m88e1111_link_change_notify,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 };
 
-- 
2.23.0


