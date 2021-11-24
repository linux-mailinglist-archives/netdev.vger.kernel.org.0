Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF745B52A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhKXHTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240666AbhKXHTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:19:48 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6261FC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 23:16:39 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l16so2349828wrp.11
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 23:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=gJSjNgFxt98sWW/oxbvEJeLpdzgKITh1+FESlZHPPIM=;
        b=k+mxe2kd8HYFW3Ch3QdIqT0HsPnYs48ZQmMhpaU0F3sQOw9yAjxpqidHtl09nIrVGN
         XdWYZV67j3iYA8DvlSvVFtgvyQBBDMAPCJrNswna46ApXSmCe3UGT1fIVPTuhm5hf8cE
         /Vl1GRypd0NiUmUyDLDuB4PMvWO1oQDnUPpSxOjUhyn+EwQiqH8JGzwOukrt2mBl/ZyO
         LIUW/rMweVFva74+9xW6sQp8UakgLunD/DSd89n43XHwQQbJ/Tvbni2oFOxCBdLOF/ay
         ODHjSFA0/ngnA07C1AS760s3zgoUxYI9/rHB3PxA7MlrEHQkfPzIoXtPbNqOKhqURgbJ
         1rlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=gJSjNgFxt98sWW/oxbvEJeLpdzgKITh1+FESlZHPPIM=;
        b=LiEfRbeKvsCi4muJ0wXcVqoNjFVMO6Hntkf5ebAr3PaAy0J6P3WFeC1PKbR/djaB9C
         i2eqZfpyjz+dAk/jURIjVTsRfc++hmGKXqFdtry8XeqgtTx37aHmAhRA6vli/xf9tkWI
         cnCtAZkC3lJBBp+xm6DckFM3nUIZQ0A6BdB57kc7m9sbE+jMBfRwbyCXeKEq6IcUxsYJ
         u3GCxaTfw52h55CmwNktRprqf/eViD12r3vT6n87kGIjupZ+YUd+0vtteti0dcS974Oi
         r/PbeimSJCCuepgbLkC9MBfqtxPEfBK0wFTFVMhK7bLL6mS9FFbT30B7iesQiG8Al9Kd
         oXQQ==
X-Gm-Message-State: AOAM5337Bm9sa5DAeQZ3s2jjG+k0IakSthfJhAqEU8T9AqZmOHvNyLYv
        qC147RRch8PxApgKLNVxLBc=
X-Google-Smtp-Source: ABdhPJz7fT2mUsw2s53RM8v5aD8qNYZkdWOLFQB3QpaIcHkOtmLGbdOTKnxJMdxln9fQbK9WgWs7yg==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr15334224wrr.228.1637738197282;
        Tue, 23 Nov 2021 23:16:37 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:704b:9844:6015:3072? (p200300ea8f1a0f00704b984460153072.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:704b:9844:6015:3072])
        by smtp.googlemail.com with ESMTPSA id f19sm4594619wmq.34.2021.11.23.23.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 23:16:36 -0800 (PST)
Message-ID: <40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com>
Date:   Wed, 24 Nov 2021 08:16:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alessandro B Maurici <abmaurici@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] lan743x: fix deadlock in lan743x_phy_link_status_change()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of phy_ethtool_get_link_ksettings() in the link status change
handler isn't needed, and in combination with the referenced change
it results in a deadlock. Simply remove the call and replace it with
direct access to phydev->speed. The duplex argument of 
lan743x_phy_update_flowcontrol() isn't used and can be removed.

Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 4fc97823b..7d7647481 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -914,8 +914,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 }
 
 static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
-					   u8 duplex, u16 local_adv,
-					   u16 remote_adv)
+					   u16 local_adv, u16 remote_adv)
 {
 	struct lan743x_phy *phy = &adapter->phy;
 	u8 cap;
@@ -943,7 +942,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
-		struct ethtool_link_ksettings ksettings;
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
@@ -980,18 +978,14 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		}
 		lan743x_csr_write(adapter, MAC_CR, data);
 
-		memset(&ksettings, 0, sizeof(ksettings));
-		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->advertising);
 		remote_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);
 
-		lan743x_phy_update_flowcontrol(adapter,
-					       ksettings.base.duplex,
-					       local_advertisement,
+		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
 					       remote_advertisement);
-		lan743x_ptp_update_latency(adapter, ksettings.base.speed);
+		lan743x_ptp_update_latency(adapter, phydev->speed);
 	}
 }
 
-- 
2.34.0

