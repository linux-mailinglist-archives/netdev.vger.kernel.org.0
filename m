Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D82CC56
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE1Qnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:43:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55095 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1Qnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:43:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id i3so3711315wml.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rBEck8AOfArcP685LgSAIkGvheCEHGY3Lnw8fPDNgv8=;
        b=K3lB+6IcFzKS0rycHrNuVEbZ9KVR33PwmdKABSqwFjIOSM/5IMu3QlWfbtKlOH98YT
         YwEDeb7rEMoNSt/fh/aG4XhTS7M/CtQlix/PfnUKvbZn006iP5AKcu/nmTNFsYOyUBPe
         /ex7TQO2A7KLfg3QgUR+Hn/hVf4ZlgWXxzJzd8ujYKsSueDCRCYKodIfADKceX17oi4c
         ThaDdX1FMh/aPsdwVkv+1QF3NmUa31/1Ecb9/q50/9tSQpS0QUpL0SGqaLCMF3SRX3CT
         9TKq8mBuD50f8YHSd0dcAlY1rIiWe7li/yBFi9FnTS0EOpthGhNH0ZhyLUwM92qWU29U
         e17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rBEck8AOfArcP685LgSAIkGvheCEHGY3Lnw8fPDNgv8=;
        b=EUqnFsX4SiBm2sjtNAIYRrAzRF+ttSoMYfG3f1FeIVqRx1gc6OEAJP6o6L1QWpb/M3
         dWGiSu6fEqJchrlMoAYwC+J5sq4mEO7wMeutt1V8/R5mweucYR73VoCaa/siMGjw+oJV
         7eTBRdDThWI5wHQsenW4QrdYT0GO8GkmQVeInRUUGBECi+JHXHz+Xl1l3oFNPRIBJZM1
         NJDdtpGH0b8ueWePk21ynjSVVPn/rdr/8eC2R4QAPoW8ykzCIM+XYEmZ3FOCc8RukQr8
         1dVm1xKt5XD+iDx6Ro07wByhnG7N14aCOMv/7p8+S59BIeBkVUTCKYEAw7KlRGFhAyju
         2lWA==
X-Gm-Message-State: APjAAAUtINacvlFozcnMtYNMXpd2jW4g8sx6wEYNrsC9YcW+At4fsc6i
        z9bQH621JEoxoZaiE9btiGCHSbeZ
X-Google-Smtp-Source: APXvYqxHSbbfquxSlFvvss4uCNYDvC5Ckp+guKvUVh9pqMhsQZmagKxGcc8XbQ/Owxzs94WvUmdVOQ==
X-Received: by 2002:a1c:cfce:: with SMTP id f197mr3686763wmg.56.1559061832898;
        Tue, 28 May 2019 09:43:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id y2sm1667368wra.58.2019.05.28.09.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 09:43:52 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove 1000/Half from supported modes
Message-ID: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
Date:   Tue, 28 May 2019 18:43:46 +0200
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

MAC on the GBit versions supports 1000/Full only, however the PHY
partially claims to support 1000/Half. So let's explicitly remove
this mode.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 61e7eef5e..0239a3de2 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6397,7 +6397,10 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (ret)
 		return ret;
 
-	if (!tp->supports_gmii)
+	if (tp->supports_gmii)
+		phy_remove_link_mode(phydev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	else
 		phy_set_max_speed(phydev, SPEED_100);
 
 	phy_support_asym_pause(phydev);
-- 
2.21.0


