Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCE2048EC
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgFWFBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:01:05 -0400
Received: from smtp49.i.mail.ru ([94.100.177.109]:40734 "EHLO smtp49.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgFWFBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 01:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=hVUFCibrbxi9FVHXHZD/1R3bng1jZqrdVR88VF8VT6s=;
        b=bQS7H2O9JE/3Y8AQUSWRLGk5kV6rigF8uSi6T3vy2YPK1DEhP6VjnON8Lc19VNGtT+0ssbIt0YJv0+kejryxL51ZKzqeI4sQN2a1ABXBhjbtwlTRh9j/aPMiMjDbjROW4rMvh/z2gVeE9O+m8mv16XcounEGN3rYjVVGT6alwm0=;
Received: by smtp49.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jnb3J-0007eW-97; Tue, 23 Jun 2020 08:00:57 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/3] net: phy: marvell: use a single style for referencing functions
Date:   Tue, 23 Jun 2020 08:00:42 +0300
Message-Id: <20200623050044.12303-2-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623050044.12303-1-fido_max@inbox.ru>
References: <20200623050044.12303-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp49.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E7E618D9A39B32F604F18773C824D9F38182A05F5380850402EC05C023651FDA8E6CD076DE3BF5B5D3E8C3D3C7C4D973470790977D09EF8E0
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE765E5AECD9E6F2223EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377A9AC615CFEE341F8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC457FB749D9510735B0CB94CE20B5F5A508E34D258E2B4A35389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C0AF05157F0BAFB9978941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C390BCC82C2C62A6D1117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C188B2BFCDC338A022D242C3BD2E3F4C64AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C3BC70C8FBAE0A4268BA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FCB835E6E385EA5AF075ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: CB3B1E24D26FD0DEB154DAE81122F9EA9B39667A6CE68C3E334F78B08C5F43BE9E57B01AEB3B6F29CE513E50372689E1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj1gHwMoBzqgcXIcOIFBA1CA==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD289934122E824C334710B5E029A2CF7F5F102C4E6706E61939857249EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel in general does not use &func referencing format.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/marvell.c | 222 +++++++++++++++++++-------------------
 1 file changed, 111 insertions(+), 111 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index c9ecf3c8c3fd..ee9c352f67ab 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2625,12 +2625,12 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1101",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &marvell_config_init,
-		.config_aneg = &m88e1101_config_aneg,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1101_config_aneg,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2643,12 +2643,12 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1112",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1111_config_init,
-		.config_aneg = &marvell_config_aneg,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1111_config_init,
+		.config_aneg = marvell_config_aneg,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2663,13 +2663,13 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1111",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1111_config_init,
-		.config_aneg = &marvell_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1111_config_init,
+		.config_aneg = marvell_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2684,12 +2684,12 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1118",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1118_config_init,
-		.config_aneg = &m88e1118_config_aneg,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1118_config_init,
+		.config_aneg = m88e1118_config_aneg,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2701,15 +2701,15 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1121R",
 		/* PHY_GBIT_FEATURES */
-		.probe = &m88e1121_probe,
-		.config_init = &marvell_config_init,
-		.config_aneg = &m88e1121_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.probe = m88e1121_probe,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1121_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2724,16 +2724,16 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1318S",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1318_config_init,
-		.config_aneg = &m88e1318_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.get_wol = &m88e1318_get_wol,
-		.set_wol = &m88e1318_set_wol,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1318_config_init,
+		.config_aneg = m88e1318_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.get_wol = m88e1318_get_wol,
+		.set_wol = m88e1318_set_wol,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2746,13 +2746,13 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1145",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1145_config_init,
-		.config_aneg = &m88e1101_config_aneg,
-		.read_status = &genphy_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1145_config_init,
+		.config_aneg = m88e1101_config_aneg,
+		.read_status = genphy_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2767,12 +2767,12 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1149R",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1149_config_init,
-		.config_aneg = &m88e1118_config_aneg,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1149_config_init,
+		.config_aneg = m88e1118_config_aneg,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2785,12 +2785,12 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1240",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1111_config_init,
-		.config_aneg = &marvell_config_aneg,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1111_config_init,
+		.config_aneg = marvell_config_aneg,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2803,11 +2803,11 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1116R",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e1116r_config_init,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e1116r_config_init,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2822,17 +2822,17 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1510",
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = &m88e1510_probe,
-		.config_init = &m88e1510_config_init,
-		.config_aneg = &m88e1510_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.get_wol = &m88e1318_get_wol,
-		.set_wol = &m88e1318_set_wol,
-		.resume = &marvell_resume,
-		.suspend = &marvell_suspend,
+		.probe = m88e1510_probe,
+		.config_init = m88e1510_config_init,
+		.config_aneg = m88e1510_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.get_wol = m88e1318_get_wol,
+		.set_wol = m88e1318_set_wol,
+		.resume = marvell_resume,
+		.suspend = marvell_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2852,14 +2852,14 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e1510_probe,
-		.config_init = &marvell_config_init,
-		.config_aneg = &m88e1510_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1510_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2878,14 +2878,14 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = m88e1510_probe,
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.config_init = &marvell_config_init,
-		.config_aneg = &m88e1510_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1510_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2903,14 +2903,14 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E3016",
 		/* PHY_BASIC_FEATURES */
 		.probe = marvell_probe,
-		.config_init = &m88e3016_config_init,
-		.aneg_done = &marvell_aneg_done,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = m88e3016_config_init,
+		.aneg_done = marvell_aneg_done,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
@@ -2924,14 +2924,14 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e6390_probe,
-		.config_init = &marvell_config_init,
-		.config_aneg = &m88e6390_config_aneg,
-		.read_status = &marvell_read_status,
-		.ack_interrupt = &marvell_ack_interrupt,
-		.config_intr = &marvell_config_intr,
-		.did_interrupt = &m88e1121_did_interrupt,
-		.resume = &genphy_resume,
-		.suspend = &genphy_suspend,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e6390_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
 		.get_sset_count = marvell_get_sset_count,
-- 
2.25.1

