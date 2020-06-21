Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262AE202978
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgFUIAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:00:51 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:46020 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729470AbgFUIAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=Tnly/+cThEzo4AUA9Dh4b+WPWz31Ec4VG2GXQWwNZrU=;
        b=JtvXBnvXXgT9ztv+Y/thrdTBI+a5O88LNCQm/xOAR0Cn7FLILMyjSK8XJ6MSbt5h6orvXg9TtKJ5v1IjssPw9fTrbFK/MZKpHl3HBZBkf+vdT/6HkzytDBpwy/wDbsKRsTy0M6jWjP1pGM6O76YIq14jsZbgBgvREfRNpq6tlIU=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmuuB-0000ou-Ns; Sun, 21 Jun 2020 11:00:44 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/3] net: phy: marvell: use a single style for referencing functions
Date:   Sun, 21 Jun 2020 10:59:50 +0300
Message-Id: <20200621075952.11970-2-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621075952.11970-1-fido_max@inbox.ru>
References: <20200621075952.11970-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E7E618D9A39B32F60E885B15504778218182A05F538085040F836DE010EEBA2B259E797113EC38994C1FF518F9FB8D1092E99995F3FC63007
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE763424119D34F5CBFEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637770CCD3A0ADFB7EEEA1F7E6F0F101C674E70A05D1297E1BBC6CDE5D1141D2B1C8C8ACEB81267838A705D479E9436643906DFFA23709D277B9FA2833FD35BB23D9E625A9149C048EE9647ADFADE5905B128451B159A507268D2E47CDBA5A96583BD4B6F7A4D31EC0BB23A54CFFDBC96A8389733CBF5DBD5E9D5E8D9A59859A8B652D31B9D28593E51CC7F00164DA146DA6F5DAA56C3B73B23E7DDDDC251EA7DABD81D268191BDAD3DC09775C1D3CA48CF7AC6CA6474BF70F7BA3038C0950A5D36C8A9BA7A39EFB7669EC76388C36FFEC7BA3038C0950A5D36D5E8D9A59859A8B6DE1D4839412891D576E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F79006377870F476E0DB9443A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F83C798A30B85E16B262FEC7FBD7D1F5BB5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DB48C21F01D89DB561574AF45C6390F7469DAA53EE0834AAEE
X-C8649E89: 8CEAF2896777E911A64208AB62F08C93F922BA1B288855F9AF6843FF01480231FD4643120F166991CE513E50372689E1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojijaCqZVrqPEHGfocAwqXxg==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD289934128EF6D947A40B90BDA7A5DDCEA0BC305B1D49A047E6701026EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel in general does not use &func referencing format.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
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

