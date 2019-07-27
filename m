Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55477829
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfG0Kck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:32:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45048 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfG0Kci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:32:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so56837267wrf.11
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EINUmWh/fPHQVKE7j9DF0lXq9lD1sinGrFalYEHoHDQ=;
        b=p6/c3P9VrqFwcPbjDegcs2p1/gtbwH32IcY5ZLBJPc8SGMgeiqvZWNOODQCoxtf2pR
         xaHHdVSaC1qKH6gGyyGwAFN6ZCOunKnensM2i+EsAn5CAjDBVi4qTtqf1G4UhNMv044Q
         RHTBHGCQ0mdG8bdzQ4lVGxdsw/LjqGYckbt+uHNnRwQpp/ayP84gIEKI8bDIIZnY0dun
         YE08oi+EoJ+MZdpS9cY2Q+tq01LsYGz5KoB423ktmp8v6I/tL66LSPhTJHtF8Uj8h9Ag
         OLn544c8GtrRpUuJhxWojieTI80zhOrwUW5WymsfeDaB63QLEQRC6XUEi5HveEIPhM5N
         Axpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EINUmWh/fPHQVKE7j9DF0lXq9lD1sinGrFalYEHoHDQ=;
        b=BaFYGuIsWep1g5J6+ZK1UtIpzgrLIyz1R77IklsP2fuQgYWu+MY0cr5DWTD2M7Yt4P
         MLM87ArwfyhHcoYjuDimAyCLrThD0o2ISSAhd/HJLCP3lZyDQaTeCyyVaIKpg7FwvAnO
         T5byHAAKUAoUuDCW6RTdrP3V5QPhhCexZLOB2Z3d3ustsqUR28iTmgEARMX6D5d5tTZB
         rX8+z2Sb1rDxjWewO8M+xJu7Sy/Jzi7CHnrr3axe+hAVoMohL8MFIGMhWS0HQlbzKoSE
         r4JDtbf8JYKbr1JC/3hlT7A3nqN2MYG9pF8zNRzKR00gL1G6HjV8UHtt6KKp2Uw72+Pr
         /ppA==
X-Gm-Message-State: APjAAAXzcCEwLZZdZHXwjwClDHSA7gyE/1x9WxFZc0R+UMuKsi3xeanQ
        Lkm0kF8bCjGlMNK2LHBw8fogC/3v
X-Google-Smtp-Source: APXvYqxBSPRU0DUpNLfYYTjAwMXtDZtiW/ARzJlqVDTYBofYq/neQigaZ6pHMbpS/xE2clx9Hs3Zsg==
X-Received: by 2002:adf:cf0b:: with SMTP id o11mr90469808wrj.10.1564223556172;
        Sat, 27 Jul 2019 03:32:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:c0a4:381:9a20:d2e8? (p200300EA8F434200C0A403819A20D2E8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:c0a4:381:9a20:d2e8])
        by smtp.googlemail.com with ESMTPSA id s10sm40063276wrt.49.2019.07.27.03.32.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 03:32:35 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bernhard Held <berny156@gmx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] Revert ("r8169: remove 1000/Half from supported modes")
Message-ID: <56f11453-59fd-3990-7f32-52820fee238e@gmail.com>
Date:   Sat, 27 Jul 2019 12:32:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit a6851c613fd7fccc5d1f28d5d8a0cbe9b0f4e8cc.
It was reported that RTL8111b successfully finishes 1000/Full autoneg
but no data flows. Reverting the original patch fixes the issue.
It seems to be a HW issue with the integrated RTL8211B PHY. This PHY
version used also e.g. on RTL8168d, so better revert the original patch.

Reported-by: Bernhard Held <berny156@gmx.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6272115b2..a71dd669a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6136,10 +6136,7 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (ret)
 		return ret;
 
-	if (tp->supports_gmii)
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	else
+	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
 	phy_support_asym_pause(phydev);
-- 
2.22.0

