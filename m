Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04F1C0F2D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgEAILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAILj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:11:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D78C035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:11:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o27so5340662wra.12
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ypdC5bFiTQ6W4Eylc1bXnH57NDGvqvtM4m9p/fFJmvc=;
        b=SzWp7pn3sk5z2OAR2P/JEpOzjDEBNnINsLHbLf5pkxUHlKqXr5srl3QQhgP9s8pS/j
         uwNNfCd7lGpNn1oy3RRQiCkexhCFUt4dENUttQaCRu0hIRvzYuaGT8V2K95PfDjT64bY
         BqC9VHgAn0iALi45NE6JLmoSk2h75g1LzyPt4ZwpomAMGTuzO3Cx3/DcVFmDMt0aj32c
         1Sn0sG4Qibf4x+18kSbUnXVd6qDjU9AAn+FJCOiWdXEPXEHiDRyv9e+1YydXzhFmh+/D
         RCfIXdry0F8xiwW4roKzzl8jCe26KX3IpbN49k9wmtMgbDDDnYTEtvSqGPh6PthWkMSw
         RR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ypdC5bFiTQ6W4Eylc1bXnH57NDGvqvtM4m9p/fFJmvc=;
        b=ENwZk2eQRS76rNu0z9ednkB7O219faHuzpNk56TlrgPaCdKtrCUa2wWf36OQlbz/9T
         bpPi7FoVbSuCeZFIbbM9lf+uLi+uGeHUwAHFHxoBlUrCtcFW3dH98QQ+XI8gQFjglKMT
         aZqjK1CDeZ8v50dFycLOanqqM7Qqs6vx1DcipsGh7zy6ogK1SVEfcdaVkT7NVeBWQ60Q
         bmEHtJA3zOGy0OrIt8PGzKROkldHRa7qGQLQ/ePyk/Hzf/ZibBnx7BhSgkIc5KUBUS1P
         HeL5ip2HTU/Eg03BTJcJpACwsO1l2K7qJPIDeu1u1+qEJS0/jyvHespQSDEtp5r7E64D
         DHPQ==
X-Gm-Message-State: AGi0Pub1M5/ELVK37pBBM2djbmLMHPpkpb+bVAkIAr8x2bJr5BOgv7qP
        rx5Vk4Ck0/XXNvsnVuF2BfVp0IB5
X-Google-Smtp-Source: APiQypJ5RySf5KFDv1wrZOG+ovBzT3iLmEiD+r7AV8zRwyll7yeG6BszP7Vvp9fFbx520b8OQS5MlA==
X-Received: by 2002:adf:84c1:: with SMTP id 59mr2973499wrg.350.1588320696131;
        Fri, 01 May 2020 01:11:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:dc97:352a:650c:351d? (p200300EA8F06EE00DC97352A650C351D.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:dc97:352a:650c:351d])
        by smtp.googlemail.com with ESMTPSA id j17sm3430683wrb.46.2020.05.01.01.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 01:11:35 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove not needed parameter in
 rtl8169_set_magic_reg
Message-ID: <52b40061-60d2-d517-4e82-bb2077ede8d8@gmail.com>
Date:   Fri, 1 May 2020 10:11:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a not needed parameter in rtl8169_set_magic_reg.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0ac3976e3..0f869a761 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2608,7 +2608,7 @@ static void rtl_set_rx_tx_desc_registers(struct rtl8169_private *tp)
 	RTL_W32(tp, RxDescAddrLow, ((u64) tp->RxPhyAddr) & DMA_BIT_MASK(32));
 }
 
-static void rtl8169_set_magic_reg(struct rtl8169_private *tp, unsigned mac_version)
+static void rtl8169_set_magic_reg(struct rtl8169_private *tp)
 {
 	u32 val;
 
@@ -3811,7 +3811,7 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 
-	rtl8169_set_magic_reg(tp, tp->mac_version);
+	rtl8169_set_magic_reg(tp);
 
 	/* disable interrupt coalescing */
 	RTL_W16(tp, IntrMitigate, 0x0000);
-- 
2.26.2

