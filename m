Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A068DF5ED
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbfJUTYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:24:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40455 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbfJUTYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:24:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so13894118wmj.5
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CeghWqfMXbQ05nzcP6GWWxrfkdPg3+jIEe3AXLeIOis=;
        b=pSm5vUpS0qU7uxAFxI77K1MWNU+4UyPswUhyzL+ULjdNkhfdsSf2ljcw8WrudDN8Q9
         S4K09qmbNOg1jwItjhxZa/DnNXT3ebk8lkJPfQlJ3rH013kD3J79c2jwn+AoZJmCdmBj
         2F28bU9LqNM9Y4hhpyl3i5PqKTdLOKdLtqs1feWRBuj0+A0dt5LO4arqUgnHs9qK6jC4
         a6nU33/DMwPY9/PZuT1mFDOVV93LfE9v8glpis4RnHms3a6tLW1+0Oy5ZwB82vb3w+gb
         27USC++k/keJlzIvD3VpPsComynkAmbNYbEYSjviaFvdC1aPBTWlTkLKbQMSCvzMt5M3
         aEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CeghWqfMXbQ05nzcP6GWWxrfkdPg3+jIEe3AXLeIOis=;
        b=aYSNrYPrI0ZQbyBhWGoffgBEo7Dp9UnRyaR+oe1/axOYXjO4VxfryLh9vc7kquwwG1
         CcKv5E2hatG6ifmKZJTByUpHXJa9DdCAgTQQ166VSS3ANT8wqvdOmVyFjcOVNeHU5nnd
         6XdKOoHsq3KKA54SHKLu+9RWJRxYtV1TSh9oVIsMHcn3vrs2jQ2s9s1bfQU2jI/zAOwg
         Qv3pyWW00ABe2svCKEHkg8kFMCV/G9ssOsKiTMczSi1RY7zeMmy8HfTepMAku1hU2h5t
         ByBdRTPgYG0j2s7FrIn/dsYDDSzw0Orgbb8+UZjPskjq0jdLmg2prSPy2BJqhLzLhFyw
         WqtQ==
X-Gm-Message-State: APjAAAV3sIwbhvcrxA0iojSwOrjCBqHtGfNd/5Q46t/0Ubt6pu8Ydafe
        Evy8is9brOJKQY1d8czBw9MD//B1
X-Google-Smtp-Source: APXvYqxCsPQsRH/gPsO7LYI71qMWreVEm5NHEpbEVdM2CyUwbCehIzQ9zuhcJT+eXgxEFbT/MMnteA==
X-Received: by 2002:a7b:cc06:: with SMTP id f6mr19969022wmh.158.1571685870541;
        Mon, 21 Oct 2019 12:24:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id w9sm9111279wrt.85.2019.10.21.12.24.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:24:30 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: remove rtl_hw_start_8168dp
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Message-ID: <8402ceef-c380-564b-7682-9b48e4234848@gmail.com>
Date:   Mon, 21 Oct 2019 21:23:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove rtl_hw_start_8168dp() because it's the same as
rtl_hw_start_8168dp() now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 990b941f5..481a6df59 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4520,13 +4520,6 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 	rtl_disable_clock_request(tp);
 }
 
-static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
-{
-	rtl_set_def_aspm_entry_latency(tp);
-
-	rtl_disable_clock_request(tp);
-}
-
 static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168d_4[] = {
@@ -5317,7 +5310,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_28] = rtl_hw_start_8168d_4,
 		[RTL_GIGA_MAC_VER_29] = rtl_hw_start_8105e_1,
 		[RTL_GIGA_MAC_VER_30] = rtl_hw_start_8105e_2,
-		[RTL_GIGA_MAC_VER_31] = rtl_hw_start_8168dp,
+		[RTL_GIGA_MAC_VER_31] = rtl_hw_start_8168d,
 		[RTL_GIGA_MAC_VER_32] = rtl_hw_start_8168e_1,
 		[RTL_GIGA_MAC_VER_33] = rtl_hw_start_8168e_1,
 		[RTL_GIGA_MAC_VER_34] = rtl_hw_start_8168e_2,
-- 
2.23.0


