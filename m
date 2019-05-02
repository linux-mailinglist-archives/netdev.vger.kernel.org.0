Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9EE12228
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEBSrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 14:47:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41668 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfEBSq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 14:46:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id c12so4786989wrt.8
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 11:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=x6XkIPyUZg7pCnY2WgVGHlyxqyE2CrT+22pz9TDEorY=;
        b=Y0uANagvKkVhaUmI9IR7LJkg6+FD2Yam36JcQuOY4DEBVytcb3PwKYv/a26WATe7wd
         PLV9P/ieEpKnMSZj6fXKmG8LYqBrZ3zL7tyeLcYNUwW7x8Rh0V/YRZVkCwDBblhAnb61
         tVDvN62EEkGNbYrQc8LZ6c/NJWGDk1+wU1Wmf5F9I/+EyqLF8ZENSuxVpdjO1xJu0BXK
         +LHQ14bZIq7ej+8kkn9UokNgYTErT/1gAUTL7xjOiNMFB9R8997ym0+vVXRRYY+A1eT/
         6yPIYITZHMpMvLUGmCNLyr1ep+6397lemMXsArI/fCts9FM5JD0vjO+yCQdJTpBMJQPR
         EVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=x6XkIPyUZg7pCnY2WgVGHlyxqyE2CrT+22pz9TDEorY=;
        b=UrZRchu5uTR9juMI/fHIVq85/CeARdE/o1iZ65Rh3hPT1Mj1SRL0EquasgwMdrwSOK
         OVOjv3zLZMKk9kg4c6M4AIz0lYSYjmN9u3buBNy2CFBQwJvE8st6RQ3UjPhHBb1x39bp
         FCUw2NwYG09jH3BzWCXUjLpDvHYKwtiIhJFbvEAPyU1AkMndSz1CSUJqyER13CMgUVYn
         CgyO7Wf52P7+gWcASp4ghl2yL5xqBH4Q0vJifLvwzKqwZ/qXnNSS/nccK4813blbHneS
         1asOt2LQFrVyP4Xt6eMYY8o0ryERzEcvogyAZuFYkY1W0pbLazypS4ZtMjCctTQ+TI4n
         Opqw==
X-Gm-Message-State: APjAAAVZRDO9EnERhDr/vIIT3d+Z0h6jkD6MbPX0ppUp9sojA9FMUA25
        VpJqvVuDcQaw0k+ZbL+14D3qdmmdh/U=
X-Google-Smtp-Source: APXvYqx515o8T8jMxUa63IZ2tN+JVaBERB7aHEI8LQkyXnVmz7iIFB7eTioRwSRhSgXQzrVBWrFdTw==
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr3853430wrq.183.1556822817817;
        Thu, 02 May 2019 11:46:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d5f:9121:fe0:2821? (p200300EA8BD457000D5F91210FE02821.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d5f:9121:fe0:2821])
        by smtp.googlemail.com with ESMTPSA id f1sm12841907wrc.93.2019.05.02.11.46.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 11:46:57 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove rtl_write_exgmac_batch
Message-ID: <0720a8db-562c-d2cb-b992-8c29385461ac@gmail.com>
Date:   Thu, 2 May 2019 20:46:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl_write_exgmac_batch is used in only one place, so we can remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9200fa8ae..ee16b7782 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1286,21 +1286,6 @@ static void rtl_reset_packet_filter(struct rtl8169_private *tp)
 	rtl_eri_set_bits(tp, 0xdc, ERIAR_MASK_0001, BIT(0));
 }
 
-struct exgmac_reg {
-	u16 addr;
-	u16 mask;
-	u32 val;
-};
-
-static void rtl_write_exgmac_batch(struct rtl8169_private *tp,
-				   const struct exgmac_reg *r, int len)
-{
-	while (len-- > 0) {
-		rtl_eri_write(tp, r->addr, r->mask, r->val);
-		r++;
-	}
-}
-
 DECLARE_RTL_COND(rtl_efusear_cond)
 {
 	return RTL_R32(tp, EFUSEAR) & EFUSEAR_FLAG;
@@ -3288,14 +3273,11 @@ static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 		addr[2] | (addr[3] << 8),
 		addr[4] | (addr[5] << 8)
 	};
-	const struct exgmac_reg e[] = {
-		{ .addr = 0xe0, ERIAR_MASK_1111, .val = w[0] | (w[1] << 16) },
-		{ .addr = 0xe4, ERIAR_MASK_1111, .val = w[2] },
-		{ .addr = 0xf0, ERIAR_MASK_1111, .val = w[0] << 16 },
-		{ .addr = 0xf4, ERIAR_MASK_1111, .val = w[1] | (w[2] << 16) }
-	};
 
-	rtl_write_exgmac_batch(tp, e, ARRAY_SIZE(e));
+	rtl_eri_write(tp, 0xe0, ERIAR_MASK_1111, w[0] | (w[1] << 16));
+	rtl_eri_write(tp, 0xe4, ERIAR_MASK_1111, w[2]);
+	rtl_eri_write(tp, 0xf0, ERIAR_MASK_1111, w[0] << 16);
+	rtl_eri_write(tp, 0xf4, ERIAR_MASK_1111, w[1] | (w[2] << 16));
 }
 
 static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
-- 
2.21.0

