Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3F200455
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbgFSIuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:50:00 -0400
Received: from smtp33.i.mail.ru ([94.100.177.93]:41864 "EHLO smtp33.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgFSItz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 04:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=TJYxete+I+r7IlxYlqR6yR1TEZNOPqx1PxJK3nfaXak=;
        b=m3/SoOnMPTO/VZaFHg97o00GnwIyaShgIz+SEX4Km3QBWFtNdls1vRyOYh6Aq1kqXO9ntSuCetjsdI00Tyxpm1kkcJXWKTYRdHinfIv6eBSeQGyt2PrideC/MDwrNDhEjKv05akc0cx8ToaCuYRETzUZ2xyejvdQyLNvGchvaC4=;
Received: by smtp33.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmCia-0005tu-1N; Fri, 19 Jun 2020 11:49:48 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/3] net: phy: marvell: use a single style for referencing functions
Date:   Fri, 19 Jun 2020 11:49:02 +0300
Message-Id: <20200619084904.95432-2-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619084904.95432-1-fido_max@inbox.ru>
References: <20200619084904.95432-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp33.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9FF4B5D0D517DDB95DEA0EE25CBF7BAE029D10CA1861E8D39182A05F538085040028F9FDBA818FE68C7D53A8E0AF32ECAC1138BA5512F6D18B920700249C46612
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7484B509D84968742EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377A7A7D315BEE81B48638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC5347410A10DF4ECD241249CFF21807A88F749EC3BB7EAF1E389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C018974E66F091C0F58941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3CF36E64A7E3F8E58117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C271926AB75068159040F9FF01DFDA4A84AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C3D93757D16521BF5176E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F7900637BF1C901A33650803A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F83C798A30B85E16BC6EABA9B74D0DA47B5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DB374A87274649D866574AF45C6390F7469DAA53EE0834AAEE
X-C8649E89: F64E627A00717B24B68A7A8A64A3AC393D15A6645ECFE900E24F9CEF97B76DF62C8E8D542A5B7AB3CE513E50372689E1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj7ZRlLMijxWqWm6PX0a0CLQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB242766D898BDB74DCB3BC88FDC9ECCE82D8EE157D5E0A256CDEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
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
index 7fc8e10c5f33..db5257f3b362 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2157,12 +2157,12 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2175,12 +2175,12 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2195,13 +2195,13 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2216,12 +2216,12 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2233,15 +2233,15 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2256,16 +2256,16 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2278,13 +2278,13 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2299,12 +2299,12 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2317,12 +2317,12 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2335,11 +2335,11 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2353,17 +2353,17 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1510",
 		.features = PHY_GBIT_FIBRE_FEATURES,
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
@@ -2379,14 +2379,14 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1540",
 		/* PHY_GBIT_FEATURES */
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
@@ -2401,14 +2401,14 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1545",
 		.probe = m88e1510_probe,
 		/* PHY_GBIT_FEATURES */
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
@@ -2423,14 +2423,14 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2443,14 +2443,14 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E6390",
 		/* PHY_GBIT_FEATURES */
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

