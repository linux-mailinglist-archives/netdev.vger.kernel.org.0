Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8488DF5EE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfJUTYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:24:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53599 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfJUTYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:24:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so14613889wmd.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+Ic/HGENnelG5ZCTnHW1oE1Pq1xJViMc4giEAi8JAg=;
        b=NyTWLL7+YTWRWLD/bZTXqRo/PcdS/be49XhjUAaaK2x8P5G3z114dkeWAh28uZ1YOC
         J1lOqs8814Yo6nlL4ArP5/4e7e/tpq/XSBidUdIRbC9bLwPAJ5aQ2teFBIInNoOCL4wO
         rMveAyEvN2nQS249IRWUkc0ajdZtVPDQk9+AoqpdBFIWIbi0AAPr34JvtNUWvj6FRpXB
         izhzvFnJITRabsx/hpMgyClpaqDpUVFMKNcjovhSgzlAFHsNgo1f3jfb9SgSBiDd+hNs
         Rmcklvyi1sPP2MP69lnWtevg7ps1Dm/fDsiIsOafNDYQXom8oJnOhEKMb4+NqfFrEZaR
         +MWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+Ic/HGENnelG5ZCTnHW1oE1Pq1xJViMc4giEAi8JAg=;
        b=hQ8utxX+y4NawnQLUZEavZspXs7gkI3dsqQ5KcU1KHyG+oMa7Ipr1DKh7Y5Pa1BuZf
         6fGvFPceDNzGaNtn9xqVpnOOi/9Vb+aGLMA8kObRo/E0q5uIlVfnOvjvpXI6IaYjHYsP
         LWQB/Dvwb3AdHjIsqLMmPFXyKmYdZBZ/2PM/UGhFmRvDqR+/Z9kqUcrKbOhfAyjFiqxJ
         N4SObzESnfcDadlp3P53dMu5lvtL7Fp5il1DUN5FpMnpLa2LHBuR7xCXMR69RIKZZnMH
         wYa9HnK/zks7rpoqirTK+gjZC1iU8Sh1mNTRMxNhcKdeCizeFCh8gsIF5023mABKAk7C
         CAYg==
X-Gm-Message-State: APjAAAUCN5od5DnBdw9DF0G4b2kMIbo1Nfth9iLCNFQUgVBe+O3OH9+p
        rhUzuTb7QDTVRzgIpV3LwJlNu5Yq
X-Google-Smtp-Source: APXvYqxRGgUFqC02w0BWleQspjy29G9rhc7NZ9+kFQmrAWGkdi46S/luQYTUFSPKuXZ3WVWWXn0LDg==
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr8634673wmg.109.1571685871537;
        Mon, 21 Oct 2019 12:24:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id j19sm29575324wre.0.2019.10.21.12.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:24:31 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: remove rtl_hw_start_8168bef
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Message-ID: <ec5c58cf-4d88-d8a4-1d53-f4813e25c31d@gmail.com>
Date:   Mon, 21 Oct 2019 21:24:15 +0200
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

We can remove rtl_hw_start_8168bef() and use rtl_hw_start_8168b()
instead because setting register Config4 is done in
rtl_jumbo_config(), being called from rtl_hw_start().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 481a6df59..57942383b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4415,18 +4415,11 @@ static void rtl8168g_set_pause_thresholds(struct rtl8169_private *tp,
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, high);
 }
 
-static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
+static void rtl_hw_start_8168b(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 }
 
-static void rtl_hw_start_8168bef(struct rtl8169_private *tp)
-{
-	rtl_hw_start_8168bb(tp);
-
-	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
-}
-
 static void __rtl_hw_start_8168cp(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config1, RTL_R8(tp, Config1) | Speed_down);
@@ -5290,13 +5283,13 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_08] = rtl_hw_start_8102e_3,
 		[RTL_GIGA_MAC_VER_09] = rtl_hw_start_8102e_2,
 		[RTL_GIGA_MAC_VER_10] = NULL,
-		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168bb,
-		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168bef,
+		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168b,
+		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_13] = NULL,
 		[RTL_GIGA_MAC_VER_14] = NULL,
 		[RTL_GIGA_MAC_VER_15] = NULL,
 		[RTL_GIGA_MAC_VER_16] = NULL,
-		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168bef,
+		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
 		[RTL_GIGA_MAC_VER_19] = rtl_hw_start_8168c_1,
 		[RTL_GIGA_MAC_VER_20] = rtl_hw_start_8168c_2,
-- 
2.23.0


