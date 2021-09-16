Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABF240DAB4
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhIPNKC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Sep 2021 09:10:02 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.2]:29276 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239621AbhIPNKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:10:01 -0400
Received: from [100.112.192.69] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-west-1.aws.symcld.net id 0F/A7-02979-2D143416; Thu, 16 Sep 2021 13:08:34 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRWlGSWpSXmKPExsWi1/P8kO4lR+d
  Eg2kbJCzO3z3EbPHr3RF2i0XvZ7BaHFsg5sDisXPWXXaPnTs+M3l83iQXwBzFmpmXlF+RwJqx
  ruMhU8FFtYobJ3ayNTA+U+hi5OIQEljJKHFtyXkmCGczo8SihS/Zuxg5OdgEdCSOdU5iBEmIC
  LQwSvybNp8JJMEsYCrx7PRbFhBbWMBdomXBc7AGEQEfiZXN3UA1HEC2nsT939YgYRYBVYlnK7
  sZQWxeAUeJle1P2UBsRgFZib4TR9ggRopLbHr2nRXElhAQkFiy5zwzhC0q8fLxP1aQkRICGhJ
  LL3tBhCUk9u3uZYOwDSS2Lt3HAmHLS8yecQMqzinR/e8x1HgdiQW7P0HZ2hLLFr5mhjhHUOLk
  zCcsExjFZiG5YhaSlllIWmYhaVnAyLKK0TypKDM9oyQ3MTNH19DAQNfQ0EjX0NJY19hSL7FKN
  1EvtVS3PLW4RNdQL7G8WK+4Mjc5J0UvL7VkEyMwJlMKDqrvYPz4+oPeIUZJDiYlUd6DN50Shf
  iS8lMqMxKLM+KLSnNSiw8xynBwKEnwZtg7JwoJFqWmp1akZeYA0wNMWoKDR0mEVwOYIoR4iws
  Sc4sz0yFSpxiNOSa8nLuImePg0XmLmIVY8vLzUqXEea85AJUKgJRmlObBDYKlrUuMslLCvIwM
  DAxCPAWpRbmZJajyrxjFORiVhHlbQabwZOaVwO17BXQKE9ApR/Y7gJxSkoiQkmpgKk3Qea+6X
  3Hf1Ekh5cd23YvZMdfNUJHFXkTeWWfyX6Z2F/vXVnuvMx/79urvpcKYrdU5TQZTTMT3P0qQcj
  7XzPLvtN6zDy+fKJq3r92bNdHO+GeS2rbTE0sWPtjtEfvfP4b9UMyS5xYrzky/9qBnlaX9bP/
  n0YdnH9HZMzlrl5WA4uJvHx8uON9/l1PBuZY1d92iqkB507x52y++1Z97tfN128JdUf/vV/kr
  GpSUKB74FZEoY6/g91nrstHS+MN2McvXBQVsr3woGpcpd2wCJ8vz+YecEr9eXXTtSLB6ztP5l
  RuD7LNzxNZwXGtUXSJnFZP2rvdq+AGnisdpE/fuUfP9K/iOySitUrY+8I/rESWW4oxEQy3mou
  JEABvyQhLWAwAA
X-Env-Sender: Walter.Stoll@duagon.com
X-Msg-Ref: server-22.tower-262.messagelabs.com!1631797713!381771!1
X-Originating-IP: [46.140.231.194]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 24782 invoked from network); 16 Sep 2021 13:08:34 -0000
Received: from 46-140-231-194.static.upc.ch (HELO chdua14.duagon.ads) (46.140.231.194)
  by server-22.tower-262.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 16 Sep 2021 13:08:34 -0000
Received: from chdua14.duagon.ads (172.16.90.14) by chdua14.duagon.ads
 (172.16.90.14) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Thu, 16 Sep
 2021 15:08:21 +0200
Received: from chdua14.duagon.ads ([fe80::4058:63e9:621d:cb5]) by
 chdua14.duagon.ads ([fe80::4058:63e9:621d:cb5%12]) with mapi id
 15.00.1497.023; Thu, 16 Sep 2021 15:08:21 +0200
From:   Walter Stoll <Walter.Stoll@duagon.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [BUG] net/phy: ethtool versus phy_state_machine race condition
Thread-Topic: [BUG] net/phy: ethtool versus phy_state_machine race condition
Thread-Index: Adeq+zlOM+IIDk7fQpuG9NCcUwJ8Zg==
Date:   Thu, 16 Sep 2021 13:08:21 +0000
Message-ID: <0a11298161d641eb8bd203daeac38db1@chdua14.duagon.ads>
Accept-Language: en-US, de-CH
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-codetwo-clientsignature-inserted: true
x-codetwoprocessed: true
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.17.0.41]
x-loop: 1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Effect observed
---------------

During final test of one of our products, we use ethtool to set the mode of
the ethernet port eth0 as follows:

ethtool -s eth0 speed 100 duplex full autoneg off

However, very rarely the command does not work as expected. Even though the
command executes without error, the port is not set accordingly. As a result,
the test fails.

We observed the effect with kernel version v5.4.138-rt62. However, we think
that the most recent kernel exhibits the same behavior because the structure of
the sources in question (see below) did not change. This also holds for the non
realtime kernel.


Root cause
----------

We found that there exists a race condition between ethtool and the PHY state-
machine.

Execution of the ethtool command involves the phy_ethtool_ksettings_set()
function being executed, see 
https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L315

Here the mode is stored in the phydev structure. The phy_start_aneg() function
then takes the mode from the phydev structure and finally stores the mode into
the PHY.

However, the phy_ethtool_ksettings_set() function can be interrupted by the
phy_state_machine() worker thread. If this happens just before the
phy_start_aneg() function is called, then the new settings are overwritten by
the current settings of the PHY. This is because the phy_state_machine()
function reads back the PHY settings, see
https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L918

This is exactly what happens in our case. We were able to proof this by
inserting various dev_info() calls in the code. 

Note, that we operate the PHY in polling mode. We are not sure if the effect
can occur also in interrupt mode.


Bug fix proposal
----------------

The phydev structure accessed inside the phy_ethtool_ksettings_set() function
must be locked. We applied a patch (see below), which resolved the issue.

Please note the following:
- Our code does not execute the phy_ethtool_sset() function, but we think there
    is exactly the same issue.
- The mutex should possibly be locked earlier (after variable definition ?).
- The phy_start_aneg() function cannot be called anymore (deadlock) inside the
    phy_ethtool_ksettings_set() and phy_ethtool_sset() functions.
- We replaced phy_start_aneg() by phy_config_aneg(). This might be too simple.
- The phy_ethtool_ksettings_get() function should possibly also lock the mutex.


diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b0b8a3ce82b6..a21508da3848 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -252,6 +252,20 @@ static void phy_sanitize_settings(struct phy_device *phydev)
 	}
 }
 
+static int phy_config_aneg(struct phy_device *phydev)
+{
+	if (phydev->drv->config_aneg)
+		return phydev->drv->config_aneg(phydev);
+
+	/* Clause 45 PHYs that don't implement Clause 22 registers are not
+	 * allowed to call genphy_config_aneg()
+	 */
+	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
+		return genphy_c45_config_aneg(phydev);
+
+	return genphy_config_aneg(phydev);
+}
+
 /**
  * phy_ethtool_sset - generic ethtool sset function, handles all the details
  * @phydev: target phy_device struct
@@ -292,6 +306,8 @@ int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd)
 	      cmd->duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
+
 	phydev->autoneg = cmd->autoneg;
 
 	phydev->speed = speed;
@@ -306,7 +322,9 @@ int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd)
 	phydev->mdix_ctrl = cmd->eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	phy_config_aneg(phydev);
+
+	mutex_unlock(&phydev->lock);
 
 	return 0;
 }
@@ -343,6 +361,8 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	      duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
+
 	phydev->autoneg = autoneg;
 
 	if (autoneg == AUTONEG_DISABLE) {
@@ -358,7 +378,9 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	phy_config_aneg(phydev);
+
+	mutex_unlock(&phydev->lock);
 
 	return 0;
 }
@@ -504,20 +526,6 @@ static void phy_trigger_machine(struct phy_device *phydev)
 	phy_queue_state_machine(phydev, 0);
 }
 
-static int phy_config_aneg(struct phy_device *phydev)
-{
-	if (phydev->drv->config_aneg)
-		return phydev->drv->config_aneg(phydev);
-
-	/* Clause 45 PHYs that don't implement Clause 22 registers are not
-	 * allowed to call genphy_config_aneg()
-	 */
-	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
-		return genphy_c45_config_aneg(phydev);
-
-	return genphy_config_aneg(phydev);
-}
-
 /**
  * phy_check_link_status - check link status and set state accordingly
  * @phydev: the phy_device struct

