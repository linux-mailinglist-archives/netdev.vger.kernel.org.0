Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180062A694
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfEYSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:45:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36657 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfEYSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:45:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so13020989wru.3
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2+4ohZL4z1rlx0pDdGnHeYDQfvNoLVvEg0a66mYmSI=;
        b=hI5YGtIpDOAI9ckljVbnZ8YWUlMvsUZPVyoi1ZmIE/ayzkF1emCFoKm0ZB6MRXs74Q
         Pa6VWcRATz3bN3DSiq0HSdvwyCNPJrTt3wIGx4w+1CAI60HGPBgpKsSPtgxbpa1EpElH
         VenpiQkuBA9zwvP483Dshgaee4CLDDvttYgDKMIoGS3uUHfBPCPNCjz0nLHRDYl6764k
         4skFTd/zOkZ8muViOdmE42xCJaDgI6ByT6pHwBM4/FDY6RiTIgoUHeJAq5TMt37SFp7/
         SCE/7mhzpl/WLi/fstuucW0gKRvqGabc3ldRDty7f/Z8HQbJQW0s+GvwzJtaywSZrwRj
         X4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2+4ohZL4z1rlx0pDdGnHeYDQfvNoLVvEg0a66mYmSI=;
        b=s0kmauBP7AOOp3bMU/q6T4MhJwX9NLG9p/5Sfh4/MMpbk/IMlEXo64694BOurC4Yd8
         dXCJBg+lm1ln2/JIy3vdtxdiePf1L3ysaJJW6CmMRDyXpyRDq6G+HOTugTBVhPKP3W+6
         p/BujugRFUeJ9SfGI52Hcpzua4xn3DPtgJiE1VJu3CsfDYyLSb1TmWln5wLkq9Aoupg7
         ZQzzcwl+mJEwjyt6ruXbBLviznRz05kMo/q6IZXkms4ynxqwZAt0/3kMinjo99thnATX
         B5IZ+8TSxW8+l/Ix4HNnEXj/TxRDMgDXqBNwfzdKd9VwjVq4k9Q0hI0SV9Hc47nexHoO
         Fn9Q==
X-Gm-Message-State: APjAAAXUT1aL7u8SqwIRdv5QjjRH/Kw/Drk7H2uqqbcWAo9qfJ4+V8u6
        IzZD9kFKW48yH7ScitTpmE3r6BhY
X-Google-Smtp-Source: APXvYqzQ7qUQnuROgThI1mrVYd/275FRDZQEQZnje8J3Gtab2iQryghK0D9Proqoi2z4knawm0PEUQ==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr53796663wrj.121.1558809915039;
        Sat, 25 May 2019 11:45:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id y18sm6602884wmd.29.2019.05.25.11.45.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:45:14 -0700 (PDT)
Subject: [PATCH net-next 3/3] r8169: change type of member mac_version in
 rtl8169_private
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b959316e-562f-c2a8-af20-78e27ba2c8e3@gmail.com>
Message-ID: <0e0c6178-855a-7732-cfcc-43555e1c6178@gmail.com>
Date:   Sat, 25 May 2019 20:45:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b959316e-562f-c2a8-af20-78e27ba2c8e3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the appropriate enum type for member mac_version. And don't assign
a fixed value to RTL_GIGA_MAC_NONE, there's no benefit in it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e861edca2..1a6b50c3f 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -132,7 +132,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
-	RTL_GIGA_MAC_NONE   = 0xff,
+	RTL_GIGA_MAC_NONE
 };
 
 #define JUMBO_1K	ETH_DATA_LEN
@@ -639,7 +639,7 @@ struct rtl8169_private {
 	struct phy_device *phydev;
 	struct napi_struct napi;
 	u32 msg_enable;
-	u16 mac_version;
+	enum mac_version mac_version;
 	u32 cur_rx; /* Index into the Rx descriptor buffer of next Rx pkt. */
 	u32 cur_tx; /* Index into the Tx descriptor buffer of next Rx pkt. */
 	u32 dirty_tx;
@@ -4203,6 +4203,8 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 		rtl_eri_clear_bits(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000);
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
+	default:
+		break;
 	}
 }
 
@@ -4230,6 +4232,8 @@ static void r8168_pll_power_up(struct rtl8169_private *tp)
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
 		rtl_eri_set_bits(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000);
 		break;
+	default:
+		break;
 	}
 
 	phy_resume(tp->phydev);
-- 
2.21.0


