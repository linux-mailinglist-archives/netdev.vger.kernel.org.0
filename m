Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095EDE3F60
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbfJXWao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:30:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40881 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730931AbfJXWao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:30:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so160679wro.7
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 15:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4KzriDJcXaXaEnwAxD1fnrB1LOU2HhcWSWQcUFQh8e8=;
        b=EN8IJChz5ZKW2kRwtPrj23+xNIkjYhA+Kan1SrIRnRK0K2D0iNHx8ivb8DlaTQTZNd
         QJAU+fjmvfvT6ENNPlC3AiWUKwsldxcpuWT5N3dPAG7dIYhN1kCpaG4jna/U9cjB/STm
         Ffq9slDsquFtJ9z9lP28pjIM1O2guxqSEjq1HrqpuNEV+MgWXkat+9Zt8B/t/eUpYfvk
         UjdQoTXOL5mVw5abHv5k8SwH4V3HQ2QOLrWGdZdgj5Yc3gaSvBHRdHH/4KdZMoRd1aHH
         n9A5YQGUvLN93cQCwFVqOAfwnF713h/AqkIBuBcP+QY2IYi1B9Zl6RmjJURvxzwaEtk7
         obCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4KzriDJcXaXaEnwAxD1fnrB1LOU2HhcWSWQcUFQh8e8=;
        b=Eu5WnkTf1RsSuOLgyAf2GgzVF5FpbfP+QL09nul1v7IRyrcQ121e3T4k8uOa2X6mVE
         J0HtygX0QjUXmUx9lnmaQZvd2IoepeYgsfjY7cXXrrLbHE00UT6ymOedm3xzAHxRFsdc
         GYLbiAJIGgdonPuo8ydGu1IY2leqZTd6BDLhNozASc6UQAa0M1tBF/WidKw57302pTir
         7DIuRuuKSI5ifSCNopa5t5WjOPSEca3dHazd+0AeHeM+ezUuhH4iOXWk3Pzaxv9OlD+A
         GmIg/wU7D3bkyg1UATzcOuF38reDTKe7vkza5+ttymp2mWg2PJyOQEIdNNX44achrQWY
         mypw==
X-Gm-Message-State: APjAAAXUbhUF8dsX1SW6b5V0EzFtV3DelEdzJ2lUOj34NMTGXI5OjLUd
        RcksmcvMUO43Bq9VBQa1hUEpSAHx
X-Google-Smtp-Source: APXvYqxk9+8gDLFstBjP3mqjZEv7YVvVLQ3eEP2AZQUkVwrOtCB5qGIYMREp5dkbEK0jK55NiaIpaQ==
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr6331012wre.232.1571956242272;
        Thu, 24 Oct 2019 15:30:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ac52:2d04:d8e7:8f98? (p200300EA8F266400AC522D04D8E78F98.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ac52:2d04:d8e7:8f98])
        by smtp.googlemail.com with ESMTPSA id r27sm308971wrc.55.2019.10.24.15.30.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 15:30:41 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: use helper rtl_hw_aspm_clkreq_enable also in
 rtl_hw_start_8168g_2
Message-ID: <d561a7a9-e50f-6be5-b574-38833e29334d@gmail.com>
Date:   Fri, 25 Oct 2019 00:30:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One place in the driver was left where the open-coded functionality
hasn't been replaced with helper rtl_hw_aspm_clkreq_enable yet.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 91978ce92..dfd92f61e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4710,8 +4710,7 @@ static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
 	rtl_hw_start_8168g(tp);
 
 	/* disable aspm and clock request before access ephy */
-	RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
+	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168g_2);
 }
 
-- 
2.23.0

