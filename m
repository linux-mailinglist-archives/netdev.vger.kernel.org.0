Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D82A692
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfEYSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:45:15 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42099 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfEYSpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:45:15 -0400
Received: by mail-wr1-f49.google.com with SMTP id l2so12994907wrb.9
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUSD8/1bgM98I9Jx088f1SMG9zEG8Rm9P7wEnULXFfQ=;
        b=mOadBMgzfpcgCKkO7avVw9CbaAEn8EP6sypcfFVndN61rQGyR5THbO1rmRpQyV5ak/
         h01e9gUbgvOHpGDNKC2nLATQmVFmP2egoA6VLnIRMPIRFfTCURb8RYx5YsHVn+sNGLyc
         AuWITaNTpaMMgPXJnqkZBgyD00MXAuENH0O74+DaxK6z1WtAwzVorwiBz6sZtDNt87H8
         INQDl/sZlsC96vrmxiGnf9f12fJMYN5E3/EuYX8U2xowPrW5yqH5TEuU658o5K9m9ZKt
         3ZbYpD3vvoJB5otn6UTdwZWQCUcLBijtBjTjxZs1kdbu8KgrBASjBWiglC94yL21rWOj
         8wZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUSD8/1bgM98I9Jx088f1SMG9zEG8Rm9P7wEnULXFfQ=;
        b=XrC+vUpur9hKHvD54eJmUs8sbgSOnyHG8H02JmoJpdT1oQCaIE0fXRiwb0kWu8OrV0
         1rgkfqnfohikX8ENd1qYfHXVFCIwhyD7CgevIdNS5h1hFqWK94XE3xvbjCGFzZ/Xmml2
         aBtHaqiirBRD0z+01FAgB3d57vxZC8a8Nevp+mLiDB9uZ5CJtfWc38G/eLnXDL3BN0dr
         ah711Yjq1rGX6q/0bNt+aWVPVUxzITLMhPezWh++UcNR8snNKB1wC426d99Sgsjm1Q01
         HUnXC2xAPh/6w3RATkcn1uo6eS/9nov7fZQvLc1i6WUSZCjtgBSmvN1O3FGrIFNBNwhh
         qnYg==
X-Gm-Message-State: APjAAAX7ZGvpU5NsODiwJwGDssmM2+gvv7OHy4jQQkRmQOp201gr8gf3
        QXDxYTwTHBfG2THxn3efcWPjDbQw
X-Google-Smtp-Source: APXvYqzHnRGEiaELFRB4Q4T6yaY1oppjbUPC6wgVDa+VCmhr3cCcIa0/qkPC/SE39mX7B59luTJkZg==
X-Received: by 2002:a5d:4d11:: with SMTP id z17mr18511411wrt.308.1558809913547;
        Sat, 25 May 2019 11:45:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id a5sm5071366wrt.10.2019.05.25.11.45.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:45:13 -0700 (PDT)
Subject: [PATCH net-next 2/3] r8169: remove unneeded return statement in
 rtl_hw_init_8168g
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b959316e-562f-c2a8-af20-78e27ba2c8e3@gmail.com>
Message-ID: <efeb548d-0cff-ad6f-7866-a127819b8a1f@gmail.com>
Date:   Sat, 25 May 2019 20:44:01 +0200
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

Remove not needed return statement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index c69694653..e861edca2 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7043,8 +7043,7 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 	data |= (1 << 15);
 	r8168_mac_ocp_write(tp, 0xe8de, data);
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
-		return;
+	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
 
 static void rtl_hw_initialize(struct rtl8169_private *tp)
-- 
2.21.0


