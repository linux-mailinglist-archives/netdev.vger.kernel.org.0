Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F621F4F51
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKHPUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:20:43 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40803 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHPUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:20:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id z16so5569426qkg.7;
        Fri, 08 Nov 2019 07:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b2126fd4YC8W/bbuzmb7jSc88Zo3Jrrtko50Ol11fSU=;
        b=LChmcK/PQf51+GD0y6vAxvdjiNBz51CifKdsFPcLaEULktET3DjlnS1cNFIQghWs/w
         d8SC0kGXh7CqM40riOQsbySu5GhJy86pCVFXdWPUlsuj49+n4rNW5f/e2st3PLsCXb/Y
         Z9Ud12DdurRW8Cd5eVa5L9BG/QjYM0r2phSSZC8cY3ZHCyK6WuIWmETfZ2M/CIuuHUaw
         rhD0I1DnosVKJqmVF00cgHWh6/jRceK8SqBzJrIJV8GfiSt337Pd3gja1qSdyikYMudw
         KFT1LCX2F+ZhjzdmGvlxx0NrW8Grkxoxn8WE9IwBDjP6BHh9xNg88tXaApzOFhzVlqeA
         puIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b2126fd4YC8W/bbuzmb7jSc88Zo3Jrrtko50Ol11fSU=;
        b=FhhpzKsn9+93g1R7pTejywfXqkzJXP3pT6b1hCUI2vw9YzjTsU20Hn4yaOlMF5I9vG
         uLWvqkcAOJEqWB4oF6wCBv2gnJaAiJmPAfl/rm2pQXd3Ob70F4N2qMKbBuExfHyVr/Tl
         oM9L3u1evt3XRhPRE1NVwo+ecNO9TZMUNe6KGJ+/Z6QhAuCxlWrCSOUdpFqRgARrB1RL
         GAYsextCKHcjzuWtu8x2PR84pAw/csMnPWLci9ihLDkHyRkFTLv2twTyhqKt/GaJxGiB
         rpBCz3HeNSvbtAGkl94/40o8/xtRc0LYXRKxlKXkOBs1AhZWcnG7p2jewu0DJFjnRT8k
         MTSg==
X-Gm-Message-State: APjAAAVlfABy9mmWnSS4/kCtqG2e7HaTyZX3R4OS8WKaI6JuzrqFgnQ3
        e47SWRkWLlgkuFCq+i4igvGw+9VH
X-Google-Smtp-Source: APXvYqykTm1ckHRJO089qGMaBPP7Je+PTnhJNYEq1pFpGU+91DWezpdKVUJZE4Yqy01OE1tiyBVlyg==
X-Received: by 2002:a37:a250:: with SMTP id l77mr9458501qke.455.1573226440419;
        Fri, 08 Nov 2019 07:20:40 -0800 (PST)
Received: from alpha-Inspiron-5480.lan ([170.84.225.113])
        by smtp.gmail.com with ESMTPSA id t127sm3164392qkf.43.2019.11.08.07.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 07:20:39 -0800 (PST)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: set the maximum EIRP output power for 5GHz
Date:   Fri,  8 Nov 2019 12:20:13 -0300
Message-Id: <20191108152013.13418-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETSI has been set the maximum EIRP output power to 36 dBm (4000 mW)
Source: https://www.etsi.org/deliver/etsi_en/302500_302599/302502/01.02.01_60/en_302502v010201p.pdf

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 14f562cd7..af83791df 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -305,7 +305,7 @@ static struct net_device *hwsim_mon; /* global monitor netdev */
 	.band = NL80211_BAND_5GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_freq), \
-	.max_power = 20, \
+	.max_power = 36, \
 }
 
 static const struct ieee80211_channel hwsim_channels_2ghz[] = {
-- 
2.17.1

