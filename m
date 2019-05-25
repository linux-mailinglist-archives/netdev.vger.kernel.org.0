Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903B22A693
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEYSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:45:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55320 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEYSpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:45:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id x64so12352492wmb.5
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijULekmnbNEDlx1vBWv8xQCVTXOnW6+zoNSXYGivFQ0=;
        b=c44yT691CDqs7TzhNO8EWGg4nL/UkA4cKk6XmWOXaosfcMNwL00IGOVN9DuknVcspv
         jevbmBoTkFlkK6dCuAENgBy+NEnwloS+kYb0qhoeHJUver12ggpRKQ2ErPIitWKUYrss
         gftkn/WZQYtFhSoL4U6ZYQsnIVHrbc6JUeuXZOqSf8gW3WMjzue8uhdZOYW9EUTem9oM
         Ip1str1T1yy6k+JNhOXi9Rm4uVqTE5g0+Y4miS+xbdIxmQnhfq6MZgW/uyVxkzhoDIgN
         QGVQ6rZPfC5VSSxTpFVqfeTiwdhSCxUYGIz6G0mEYMmAHy/6oFEHkuy4aXZCtDt4uLBW
         Zc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijULekmnbNEDlx1vBWv8xQCVTXOnW6+zoNSXYGivFQ0=;
        b=SHVWxsZ2JVRpLrOuYmOi7Jbg9YqbFpIv9mV/S2+xAc8WAq2VsEpRQKBknIN+/9d7kk
         ttoNLSTX71VvgZfOFuGSVqC3umt7NHTpa81vxX7HtzwBcF8w2OwC95gBwopB1f20so7N
         m9MjNvBpmBPUGSqKWmRn5GczhaKY0SsPFIgmmQ6R8P7jvc4RFbC/j275PfUj93RmQaJV
         smhUshIKt/dsUIKEdq582dLAXbCNYj0CDbDd1OtKxwDi6A1jU+iZlRm5a3CKa2cO+v70
         5OEADlYF38Uvrw7eay0UsD65qbRaZVRyeeRwe0Y26+vp+jD+vV2SA4SVW5gHJKfe+3G6
         0iLA==
X-Gm-Message-State: APjAAAV+qlzaY/GKANdAvQCSrSIF8x7e5l5yfzoaGZPOUfwaM5ldeIk8
        +R3i1Oc+P1HqPuZi6SdVQfPvVPRF
X-Google-Smtp-Source: APXvYqzom3LYdH6WV0Q/x+IaMWOCI1Z85J2C0qvUzy38bn15J9++cuQGK5YOyfrnx/N6Bq1rW8jc4g==
X-Received: by 2002:a1c:3:: with SMTP id 3mr21640430wma.44.1558809912251;
        Sat, 25 May 2019 11:45:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id o12sm393787wmh.12.2019.05.25.11.45.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:45:11 -0700 (PDT)
Subject: [PATCH net-next 1/3] r8169: remove rtl_hw_init_8168ep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b959316e-562f-c2a8-af20-78e27ba2c8e3@gmail.com>
Message-ID: <7f717d00-16a0-4811-90ad-7ca61ba7e96c@gmail.com>
Date:   Sat, 25 May 2019 20:43:25 +0200
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

rtl_hw_init_8168ep() can be removed, this simplifies the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 8e404186e..c69694653 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7047,21 +7047,15 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 		return;
 }
 
-static void rtl_hw_init_8168ep(struct rtl8169_private *tp)
-{
-	rtl8168ep_stop_cmac(tp);
-	rtl_hw_init_8168g(tp);
-}
-
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_51:
+		rtl8168ep_stop_cmac(tp);
+		/* fall through */
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
 		rtl_hw_init_8168g(tp);
 		break;
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_51:
-		rtl_hw_init_8168ep(tp);
-		break;
 	default:
 		break;
 	}
-- 
2.21.0


