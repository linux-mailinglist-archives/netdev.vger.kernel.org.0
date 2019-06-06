Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4919236BEA
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFFFw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:52:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37882 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfFFFw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 01:52:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so1003455wrr.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 22:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aFb0rRESBl1RygAtfwM/vE8LMxVIQw0VxKLpyEDk9tk=;
        b=Gumo4oi5+OUTllmeGCEctreJAKc3jSj+BaFohMlGOMaNAQTlhnOG0moWJf0nT4Aa3R
         +Su85YYZkEUkvvakfhPzrs+tRjD+JI6Z1g2+tERHXJiu0Wq3NPMBlMG0SZMLMJueEDDw
         h2veIjobaHzZtuVxMu+hJs8yPWTbc0ZjJENu+NK7Hqj7se4whtxa84RXqzhp3sHUShyR
         WlhOL8/WATW2VO0O7RGN1zQIlOdR6YrChItZb+mBSPpKkXKs5KFkxrIrTSBoTuGxbLCq
         gxjT9AzxHoYZ4myLaWp5MUpxgynsrTbk6I8MEr8/o/p1Za92yoQhRcCvckZ1gSMwmugo
         qH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aFb0rRESBl1RygAtfwM/vE8LMxVIQw0VxKLpyEDk9tk=;
        b=c5x958OcPZEv7Xyndvf9ksxyPk7dBMMv2HvgTKiCO1XlwGHBG0V3pgae3xxrKpP6nR
         vFGF723HUrqOd6m1+BYGamI42dY2M0v8O/Xsi0ECpZchL+vh5mMOlbXgb3wdy42yp3uZ
         gxIEIu7KnTGsKtm698u19QIqJiNm/pD10xbso3/Ltlm/GLwyAtRWC/L3WKmviYSNfLLX
         bz09rgRulN45+1+XliUTpe9yfRJ4KKBQ801wamVV13fUo6ZQEr8YDBARimG3y2oQ95cW
         doACowxJH6Bqtn1gOv99IiYf9KyQ/hWGatbqFEbLSOfvR6USFhckvw5I6uJ3+eapmQFC
         bIew==
X-Gm-Message-State: APjAAAUyqUhVnzuIWEDuUhiajDjO+U/V9AS7DhhzlH22D0BrILxhyfTD
        mC59SWK5iLHxW5DoqQg1xK+FNc68
X-Google-Smtp-Source: APXvYqx8hbN5lCNEw1f9te+UR+dfscocYFPBHtW/DeHMn8126sAMBaJeEI9mgsb8soFdK+6SHWdywA==
X-Received: by 2002:a5d:49d2:: with SMTP id t18mr20081091wrs.281.1559800346429;
        Wed, 05 Jun 2019 22:52:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:4dec:a307:3343:e701? (p200300EA8BF3BD004DECA3073343E701.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:4dec:a307:3343:e701])
        by smtp.googlemail.com with ESMTPSA id a17sm739628wrr.80.2019.06.05.22.52.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 22:52:25 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: silence sparse warning in rtl8169_start_xmit
Message-ID: <be510df0-ef66-ee10-eb04-c919b14b2794@gmail.com>
Date:   Thu, 6 Jun 2019 07:49:17 +0200
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

The opts[] array is of type u32. Therefore remove the wrong
cpu_to_le32(). The opts[] array members are converted to little endian
later when being assigned to the respective descriptor fields.

This is not a new issue, it just popped up due to r8169.c having
been renamed and more thoroughly checked. Due to the renaming
this patch applies to net-next only.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d34cc855f..8b7d45ff1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5621,7 +5621,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
-	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(skb));
+	opts[1] = rtl8169_tx_vlan_tag(skb);
 	opts[0] = DescOwn;
 
 	if (rtl_chip_supports_csum_v2(tp)) {
-- 
2.21.0

