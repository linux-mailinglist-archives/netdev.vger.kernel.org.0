Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8FE444A15
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 22:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhKCVLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 17:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhKCVLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 17:11:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B5CC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 14:08:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so2828425wmd.1
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 14:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=WqZqYInOPtFj1d1NPtRF1AXpHyZvEqxfW7F8QKAEvD8=;
        b=bflSdyeeU5XoP2TpH/sPJmepkwQxLdPDEaR3lmNlBJR4aQS4Zb7gStCUY7BVDgAcym
         W5DqSFcUB2QAnvvNUuzbqsMsgc0hBzVgzTgOkxRUtzA+6SG6yQZWohYY/GNPPaVLn5BX
         1MdakJLx76oAKD3/KtuZFbyhY8GCETObUwUs3NytH23dqgpjZhkJJVJMRYS6PY773O6j
         /Z1p7t2J7XudbwJMrId6F2WunNuSDGESoJUOLOwoJSrkvvNBno5xAc/8lzv5zflPxtMp
         hoof4FP3CQdANDOGPuuJs2AtazF7pCY+RhbTO8IJuRykw4N483Cl41CyfXoa5prM6uFl
         6+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=WqZqYInOPtFj1d1NPtRF1AXpHyZvEqxfW7F8QKAEvD8=;
        b=M6iBUhKMCvwt9CIBaKZZ8JTRjIGWuKpaHvE0W2auZLTQkq5QDD4Ay6Gn6b3gr/gK7q
         hYSg6GcW0jHyg7VCghSXA75sFAdpZ+GqUD626KvnOndY6Z1pe1fbS8XhbYnm+JG7/nfK
         bu5JcdYY7QsPigIFWUR8UXFIyb3Tzf8nsmmPxwcF1q5m+c2h0alRmkmljvSB5nze/euU
         JTGZZZSh8ULRUVdSR6/L/kiHzKZK9AV/3rjHDhB3h1wRzqTRTdw+jrTNv/EwiXvPsb8i
         HFloohUqurCG7KEjPxlu5ipB/DNeNUKShamMduEi9Y/CGUkIsFV1tu6q41b7J1hvrGTX
         8nyQ==
X-Gm-Message-State: AOAM532Xx09j844ookfApHR5HMxlRIx8wGCDrA2+drdSZXhhBCXUY1JC
        xuJPfK2MDYr/HedpNUrYFDewWVtKf2c=
X-Google-Smtp-Source: ABdhPJwpJG4w7gWdMny3DfH9KpdTEQV9vAXcY+iFlfZe4Kp7Cj4lYBIDA4o1K2eaZxg8fPQxfVq4Sg==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr18199383wmb.150.1635973719052;
        Wed, 03 Nov 2021 14:08:39 -0700 (PDT)
Received: from ?IPV6:2003:ea:8f1a:f00:304e:d540:1893:d784? (p200300ea8f1a0f00304ed5401893d784.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:304e:d540:1893:d784])
        by smtp.googlemail.com with ESMTPSA id t127sm6926086wma.9.2021.11.03.14.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 14:08:38 -0700 (PDT)
Message-ID: <7b8b9456-a93f-abbc-1dc5-a2c2542f932c@gmail.com>
Date:   Wed, 3 Nov 2021 22:08:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: fix duplex out of sync problem while changing
 settings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by Zhang there's a small issue if in forced mode the duplex
mode changes with the link staying up [0]. In this case the MAC isn't
notified about the change.

The proposed patch relies on the phylib state machine and ignores the
fact that there are drivers that uses phylib but not the phylib state
machine. So let's don't change the behavior for such drivers and fix
it w/o re-adding state PHY_FORCING for the case that phylib state
machine is used.

[0] https://lore.kernel.org/netdev/a5c26ffd-4ee4-a5e6-4103-873208ce0dc5@huawei.com/T/

Fixes: 2bd229df5e2e ("net: phy: remove state PHY_FORCING")
Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c..beb2b66da 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -815,7 +815,12 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	_phy_start_aneg(phydev);
+	if (phy_is_started(phydev)) {
+		phydev->state = PHY_UP;
+		phy_trigger_machine(phydev);
+	} else {
+		_phy_start_aneg(phydev);
+	}
 
 	mutex_unlock(&phydev->lock);
 	return 0;
-- 
2.33.1

