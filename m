Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99439B60B
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404584AbfHWSDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:03:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40458 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390317AbfHWSDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:03:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so9391451wrd.7
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 11:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/EhauC6IMqwo7LTVA/+KC1Ghtnpqu13c3FlOmzqzbjw=;
        b=F1hGe6HGwaJRBEu4xKaO6FOEkyOpFyJ9XZxhUs5Ir0dBq1nJBc0qWpfjJQjkgEBGII
         lXAXVIwEFtUwyO2UySgmyi4+VScMef96WlRy99wmiF7xrSLPSYZ2tTYJJYiNKVipWyPC
         O1A0AM0vUtqAfr9/vBnTgVZU+zhvRfFqciNr5dcN14fpppTwjoHVmZ9WjEligMxzYHsB
         /0FEFBUWQ9ZH7ogaV5SZwSIz6tSOh+6qiVYqsNeKauekukptYDq0rI/V8b+cZQ24pGq+
         ESD1POHKRoxFC6iK6G9RvC68F0kmeRd5RPEhGtpHgdGruo4C1V4f/LdF2f6eRbcYL2pj
         SSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/EhauC6IMqwo7LTVA/+KC1Ghtnpqu13c3FlOmzqzbjw=;
        b=fLofYAgO4UeWGpCWrFVly1sWF+NgwSFoWGNjoYi/0caUdXXZj9owvkGlJ183tAKqIC
         1UAf/ZA7VoyCwYgm4jS5OTXENv7mz3eUz6gZvJycwRlJ5xM2/UBLJBKC+g4p7uc1UrSE
         zOVyM3CchtAkljFxD2R0Qh3KiSayJj0CMkEhRpUL/edZm3i5fNQ8SKLH/U31zbrnlz5A
         ODlO7hRK5qqDLKQqzR2jUa0R4/2HlW1XhAIozhk7DqkIarLAjeUVwPjpYn1W/3IA7t3J
         /yBu41p6aPQCHj+UgAZL9MhDPXBDDxaJcSYSiET6auFQAWS5Lvn+kWCj1RPQwRt1YhGk
         T1Lw==
X-Gm-Message-State: APjAAAUd/rBjByMpNhYYunvkOWLiLaUgcQKaRiXMUkSCf1XbpMDAgxF3
        83cgiWMdJ0PpsXezXLxOapg=
X-Google-Smtp-Source: APXvYqy4OspoKVoqD0pbfh+GxLYjP7+FDZ/TY4h+d0OR6RFyLPMh3UnX2EJuEZQw5c6iwGDoo7FqpA==
X-Received: by 2002:adf:e94e:: with SMTP id m14mr7047987wrn.230.1566583419944;
        Fri, 23 Aug 2019 11:03:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:6c0a:591:b8f7:9101? (p200300EA8F047C006C0A0591B8F79101.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:6c0a:591:b8f7:9101])
        by smtp.googlemail.com with ESMTPSA id x10sm2731705wrn.39.2019.08.23.11.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 11:03:39 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] Revert "r8169: remove not needed call to
 dma_sync_single_for_device"
Message-ID: <573e5947-3a12-f69d-d1b3-1b0d1c49f367@gmail.com>
Date:   Fri, 23 Aug 2019 19:57:49 +0200
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

This reverts commit f072218cca5b076dd99f3dfa3aaafedfd0023a51.

As reported by Aaro this patch causes network problems on
MIPS Loongson platform. Therefore revert it.

Fixes: f072218cca5b ("r8169: remove not needed call to dma_sync_single_for_device")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
This fix doesn't apply cleanly on net-next, I'll provide a separate one for net-next.
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e1dd6ea60..bae0074ab 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5921,6 +5921,7 @@ static struct sk_buff *rtl8169_try_rx_copy(void *data,
 	skb = napi_alloc_skb(&tp->napi, pkt_size);
 	if (skb)
 		skb_copy_to_linear_data(skb, data, pkt_size);
+	dma_sync_single_for_device(d, addr, pkt_size, DMA_FROM_DEVICE);
 
 	return skb;
 }
-- 
2.23.0

