Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18DC35190
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFDVCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:02:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40464 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDVCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:02:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so12436195wre.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5D6azhTCvLijc8bWqTac5h6ENp0j2aWiiLM/Bku6aQA=;
        b=i1h/dqoCG6+ljrVmzbyY839DdQCBt00q0R85n7/0vPc+fiPR7P7SpWSGvjQ4ftoXrE
         jDtE6d+nR29Qy30P1QrTMkw0EgEpA3kLSUogveGzQiWNxSFugR6uefc7CVuCl5eJLyqI
         uibNfUK+Nm2tNdODNyey3kt2hkHQERDf3fMT0aWhMDTMlMiexQqKqTSGGJjhGkS+uyxo
         vAp0l0jSZ2EaPBWTzxURt0uY1SIwq18jD4HqjV7gyVeLiibVqQYbVxhL0mrJDGI8P+pv
         IMziL+7ijwWTjFetpT3ZoMR2h+X6uJdv+NNK87/CPK92xyeXRuTdDwuAalrEvDle1Tx6
         +Xjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5D6azhTCvLijc8bWqTac5h6ENp0j2aWiiLM/Bku6aQA=;
        b=Nyo+GlDlVLqaW+tfoGSHkFUqpe6x73NXqQq/PFruQCd9xvva21INg/QE0JenK383iI
         dyiHoRBMngdY5ueUPjLDBMmFvdmpn6q5gLf7OE8sNmcK7qkfuX8a22gZ26K4gYlkQl96
         P2VE4nGYdMQZZbaT8Na7Ie/y8SWEH6JDNuZtQktS7s4EHCjD/NcnC8//Gw5Nek9wIx8B
         ZsCe6PV7J3yV5bnGDB0NAjDu+83PghMjCpUz1ZOHeK7GtV24XwhGQEjG/5tE4Jah+39/
         T/PSZG0QtHy1wgA2L0VjD0DpiGuWaVcUVj2Pcp0jt/5zw9UJbJonuwg90LXtdCOE8jQH
         SJXA==
X-Gm-Message-State: APjAAAXco+6+g0NkFSSjgoHKbFvzxTVRY9o11vxdYb8b4biMqIjsZMSV
        LLhbcRuxzQaj9jxTbZQfHfXVGyRL
X-Google-Smtp-Source: APXvYqyjPpxvoHLi6zyRvkRklsDexfqm229tfifEFsf5X9HPzHL1lRrKhE9JguEasbfjNkzznLXeBQ==
X-Received: by 2002:adf:e2c8:: with SMTP id d8mr7697455wrj.14.1559682160863;
        Tue, 04 Jun 2019 14:02:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2? (p200300EA8BF3BD00CD0DE1C0529B04E2.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2])
        by smtp.googlemail.com with ESMTPSA id h90sm50836267wrh.15.2019.06.04.14.02.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:02:40 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: remove state PHY_FORCING
Message-ID: <5c3bded5-ddcb-ffe5-5769-cf237b8352a3@gmail.com>
Date:   Tue, 4 Jun 2019 23:02:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the early days of phylib we had a functionality that changed to the
next lower speed in fixed mode if no link was established after a
certain period of time. This functionality has been removed years ago,
and state PHY_FORCING isn't needed any longer. Instead we can go from
UP to RUNNING or NOLINK directly (same as in autoneg mode).

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 26 ++------------------------
 include/linux/phy.h   | 11 -----------
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 84671d868..8aab104bb 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -43,7 +43,6 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(UP)
 	PHY_STATE_STR(RUNNING)
 	PHY_STATE_STR(NOLINK)
-	PHY_STATE_STR(FORCING)
 	PHY_STATE_STR(HALTED)
 	}
 
@@ -562,15 +561,8 @@ int phy_start_aneg(struct phy_device *phydev)
 	if (err < 0)
 		goto out_unlock;
 
-	if (phy_is_started(phydev)) {
-		if (phydev->autoneg == AUTONEG_ENABLE) {
-			err = phy_check_link_status(phydev);
-		} else {
-			phydev->state = PHY_FORCING;
-			phydev->link_timeout = PHY_FORCE_TIMEOUT;
-		}
-	}
-
+	if (phy_is_started(phydev))
+		err = phy_check_link_status(phydev);
 out_unlock:
 	mutex_unlock(&phydev->lock);
 
@@ -936,20 +928,6 @@ void phy_state_machine(struct work_struct *work)
 	case PHY_RUNNING:
 		err = phy_check_link_status(phydev);
 		break;
-	case PHY_FORCING:
-		err = genphy_update_link(phydev);
-		if (err)
-			break;
-
-		if (phydev->link) {
-			phydev->state = PHY_RUNNING;
-			phy_link_up(phydev);
-		} else {
-			if (0 == phydev->link_timeout--)
-				needs_aneg = true;
-			phy_link_down(phydev, false);
-		}
-		break;
 	case PHY_HALTED:
 		if (phydev->link) {
 			phydev->link = 0;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index b2ffd82b1..e957f9aff 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -298,12 +298,6 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  * - irq or timer will set RUNNING if link comes back
  * - phy_stop moves to HALTED
  *
- * FORCING: PHY is being configured with forced settings
- * - if link is up, move to RUNNING
- * - If link is down, we drop to the next highest setting, and
- *   retry (FORCING) after a timeout
- * - phy_stop moves to HALTED
- *
  * RUNNING: PHY is currently up, running, and possibly sending
  * and/or receiving packets
  * - irq or timer will set NOLINK if link goes down
@@ -320,7 +314,6 @@ enum phy_state {
 	PHY_UP,
 	PHY_RUNNING,
 	PHY_NOLINK,
-	PHY_FORCING,
 };
 
 /**
@@ -348,8 +341,6 @@ struct phy_c45_device_ids {
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
  * state: state of the PHY for management purposes
  * dev_flags: Device-specific flags used by the PHY driver.
- * link_timeout: The number of timer firings to wait before the
- * giving up on the current attempt at acquiring a link
  * irq: IRQ number of the PHY's interrupt (-1 if none)
  * phy_timer: The timer for handling the state machine
  * attached_dev: The attached enet driver's device instance ptr
@@ -417,8 +408,6 @@ struct phy_device {
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
-	int link_timeout;
-
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
 	unsigned int phy_num_led_triggers;
-- 
2.21.0


