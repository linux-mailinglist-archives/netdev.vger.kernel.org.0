Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D453567D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFEGAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 02:00:03 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42433 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfFEGAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 02:00:02 -0400
Received: by mail-wr1-f51.google.com with SMTP id x17so62605wrl.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 23:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kddx3wtoTTU96Bhjpd0MMzPWYXBRQyaKJumoKugHT4A=;
        b=LatyH8KmDmtuxfrXAJocDeYYEuYC3hoBppMfyJRrLeikTtDShTU58jqz4f0iYfeAXk
         HAcOkcw5ZYSmrBVuDeL5CxYote81bTJRkhqNF9/pYL+S8+/96ufob7StJbTvojbFkeHG
         2dD19+hzb88V9U8A00YYyJWOU9NJ3CSgfi8cSSIPaJAWwBpukF8QOzaWXYJqo6FQwaNo
         BhPlWeZJAohbwuUe2zzOHVN0FTvfBrHyLV6ZBkafgoSmWDwXWcX/W+bc7cPnLmtamfUf
         iODODm9sUw/PNr4btl0n8Hp4l09yt3vVkeWB7S4MyE9SUTrdIV0M2DerKOvTLAsYCc5A
         OOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kddx3wtoTTU96Bhjpd0MMzPWYXBRQyaKJumoKugHT4A=;
        b=PoZAz7ljsRE0nka4eqQXwz+iOhzMSc4um4DEqj4MpbkgmDjyBqVPz3UVxJo7wly82k
         jVuqnjZDUmRfrtar4F2CIze8Ym7bjC8hMCbO+YEoAWTApdSwCUO+z1XXb1+qbLfHoE8W
         KeaQQZJ3i9k5HAfSRKIt4WOjPca9TieTH9ULBZtMVbZQn7DprbXdF9lro32m5kXoaXp+
         1wZQHmlo8saSRPaP/aPcM98X2BfWWUvs1nyuLY3tPsjHmqShcxG2ChItYfEmMJWWJo6Q
         6If1mrEfxU2tUWLuBr+0wfxgy66NKz2j8Xnb/So1CKrgrVjTrzreQcCMpE8ApsrgUtrG
         9IoQ==
X-Gm-Message-State: APjAAAXEMY1+tG7eLG9hJ5/xpc5ibagHDrzMOWpvXhwdSIGctnj4kRRU
        h4hFXMMkz6GOthTd5vV2eKStHgdY
X-Google-Smtp-Source: APXvYqxCl6gLBmBgWQu8tcJKR28niuZ+FykHeVr9oySRH8GGaFyQmQlYiooTJGKKFh5394ual7Flmw==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr15775260wru.161.1559714400910;
        Tue, 04 Jun 2019 23:00:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1? (p200300EA8BF3BD008871C3CD95C845D1.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1])
        by smtp.googlemail.com with ESMTPSA id z65sm26560707wme.37.2019.06.04.23.00.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 23:00:00 -0700 (PDT)
Subject: [PATCH net-next v2 1/2] r8169: rename r8169.c to r8169_main.c
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <58ea4445-954f-4a97-397f-5d681125b9bb@gmail.com>
Message-ID: <af356006-7f3c-4b16-be95-012a7eef8781@gmail.com>
Date:   Wed, 5 Jun 2019 07:59:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <58ea4445-954f-4a97-397f-5d681125b9bb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out firmware handling rename r8169.c to
r8169_main.c.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- no changes
---
 drivers/net/ethernet/realtek/Makefile                  | 1 +
 drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} (100%)

diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
index 33be8c5ad..c36cd2167 100644
--- a/drivers/net/ethernet/realtek/Makefile
+++ b/drivers/net/ethernet/realtek/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_8139CP) += 8139cp.o
 obj-$(CONFIG_8139TOO) += 8139too.o
 obj-$(CONFIG_ATP) += atp.o
+r8169-objs += r8169_main.o
 obj-$(CONFIG_R8169) += r8169.o
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169_main.c
similarity index 100%
rename from drivers/net/ethernet/realtek/r8169.c
rename to drivers/net/ethernet/realtek/r8169_main.c
-- 
2.21.0



