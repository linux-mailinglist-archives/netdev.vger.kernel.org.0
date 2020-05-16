Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95041D646F
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgEPWFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgEPWFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:05:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A0C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:05:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l11so7546922wru.0
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=h05treqi9CpMXR6T8goYqKzmgFaaLKWRPPev7Isc9rs=;
        b=Mq0MFwcWF3HeeXr+N+UY3ZHQFZLEP8ItLRlg4CFUCGhQasefo+Dgp6tH6CIcGKM0xu
         H4GkBff0A8eCLwRQOr8crz2XpqIYAcFIlg/WYn0BX9f3QoUj9ofyj8h+P7hL7/3uuOvJ
         Wgjcial33ekxIMVh/+3SPYRgO1YK/Q9QURB89x6nc6veoAy9aqveb/vv7ba4/pzCSrpL
         RQJY4iqH64ziqWv9wKEwOSjRd73xdDMixUay4x69CVhg+YhAD+hfClpOMCEYOjsNzaiL
         BvPXG4XRE/QjWuRReBz2pPQrxOpCayxRfhAdDuUv+qDnAE3+ZzyCvHPtdHH22y/d5mPz
         W3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=h05treqi9CpMXR6T8goYqKzmgFaaLKWRPPev7Isc9rs=;
        b=oNXfOaKlRRhqEcxFq8LGJpoJXC8nm3An2E35xsMFf2uM2ifuQrOT6xF4cGGuphZp9N
         Vz7IggnsPRXUY2xvNBI7CIroZCW+5dimr2B/b33vI1VlYgGZwypPQj2EowpDxgfbQpaA
         TS5KwgM9Cwdqqsd6sXu/x+ldLQHWgrL1Wh9jV6xGS2zAYhwmWG+8m8fFb5BxRt1DXx4a
         isOHQ1IKDSk9BYy9q++e63jDDcZNi6Yrg+XrQQio1tPbQo3ayPOdrrEZmKT85rrOX+Ta
         di+mMWtr2XP4ZDwz+j3D+aldSPF0FkiAmVrreDdKOxUR2Dbi6htEvwu3tjxgYTO9cIHI
         KtiA==
X-Gm-Message-State: AOAM531S+TeGBOdCT2/MuqXKRJiEb7J7cYS3UU3KE1DnzTAxBxFPZAqL
        B7ch/UXTKdTZ4gAQrax2bqAryk2M
X-Google-Smtp-Source: ABdhPJygS2vbgdntENOQEv4ZPSq02JTOcG8JVRsoxC6ZLNnRNGiCH+dlrdhm2p2c0WkqSVNusAFEYQ==
X-Received: by 2002:adf:f38b:: with SMTP id m11mr11190660wro.65.1589666715250;
        Sat, 16 May 2020 15:05:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:2154:c7c1:b82f:4f98? (p200300ea8f2852002154c7c1b82f4f98.dip0.t-ipconnect.de. [2003:ea:8f28:5200:2154:c7c1:b82f:4f98])
        by smtp.googlemail.com with ESMTPSA id s17sm9303320wmc.48.2020.05.16.15.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2020 15:05:14 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove remaining call to mdiobus_unregister
Message-ID: <4cf54a6a-cc51-58cf-3ad8-dd488ba44e60@gmail.com>
Date:   Sun, 17 May 2020 00:05:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After having switched to devm_mdiobus_register() also this remaining
call to mdiobus_unregister() can be removed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 97a7e27ff..e35820c72 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4990,7 +4990,6 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	netif_napi_del(&tp->napi);
 
 	unregister_netdev(dev);
-	mdiobus_unregister(tp->phydev->mdio.bus);
 
 	rtl_release_firmware(tp);
 
-- 
2.26.2

