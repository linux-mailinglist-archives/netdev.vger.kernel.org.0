Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC0133BBC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 07:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgAHGg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 01:36:28 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35935 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgAHGg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 01:36:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so1243227wma.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 22:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BeKj5O3Xib5ZCx804gMXC/Kng3AUdCyFQK4esyIDfCc=;
        b=GuRnmOvVlaTjwaeQ/RWfyFaWM/i9KvqY0GdSWbH3ePHtcjDSHH8mh84i1MjzI8cXOz
         jy6O11FimLrRvtTnF7y8OMkXQpZP5xocEhsEDGqLkv8IMAh9KYCY+weRosnxDX6KEeQU
         chm2bS7W4hwK3wE6RbCG9FO2ujHoLNROfU5iHR8vYYNKJnEuR3wY4J6TwG/OQOwinGnk
         wUhGiMPGXhCZ7jbyD4j5JIv+QAL2ScpFjOCYtO7BC29MARPD4XQN7bTiBbGZIZ5jukfV
         Sv3pwIzD0r+SFoIL89cEQ/N4QXWHCgoLIGol8POMvGIxABSi8s9rkbkoDlgnL7t9T9GK
         pXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BeKj5O3Xib5ZCx804gMXC/Kng3AUdCyFQK4esyIDfCc=;
        b=LO2CZO+pRRSIrMRbvufjW2b2V3+pxJlfs87aLJvWxyCsugBwt0qyeif0m5ke1RQkw9
         WxYHspIJcdDSD2av/P6d9L4lrqHitPKt4+QQwxBtcWpJ/BB5EdxwrtVF83nUyb6SoxdU
         gF+7FdeBgNSAu5INeTSNj1K+0BtjihfeXNzYgFJqu3B3gLcOMHppEjp+pM8F6rkUt7zP
         2nd4zkGnXkI7wOw2K1NZLRlc7yLXOJ0lrZBXcoxoqV0ycQnoF6uipn3xOCIRflw18GTA
         FwOZswZzupB7VI9r5T+yNZlsf0+/N0P3AIG+01lq/E3valz6UB2Wrn1qXNYVvk5P5G5I
         0ptQ==
X-Gm-Message-State: APjAAAVgrb2+o3O4DiQwoHEWuMVvrIcwzAoSo0fL4GK7WfrT6VAXg/2n
        c0H91yXTolz011IUYsb6YO14quw0
X-Google-Smtp-Source: APXvYqyxYnTt5z6LAjvCqskJ/ZXIIdJMx9Or5a8JDLIKF3KlsAlx2GrLpuboVGVPm0b0SI/vXtBZwg==
X-Received: by 2002:a1c:3d07:: with SMTP id k7mr1916003wma.79.1578465386293;
        Tue, 07 Jan 2020 22:36:26 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id g25sm34873503wmh.3.2020.01.07.22.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 22:36:25 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: add constant EnAnaPLL
Message-ID: <14a9a6bd-ff54-0912-07ec-a38e3dfd55f2@gmail.com>
Date:   Wed, 8 Jan 2020 07:36:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use constant EnAnaPLL for bit 14 as in vendor driver. The vendor
driver sets this bit for chip version 02 only, but I'm not aware of
any issues, so better leave it as it is.
In addition remove the useless debug message.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0161d839f..9c61ce294 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -492,6 +492,7 @@ enum rtl_register_content {
 	/* CPlusCmd p.31 */
 	EnableBist	= (1 << 15),	// 8168 8101
 	Mac_dbgo_oe	= (1 << 14),	// 8168 8101
+	EnAnaPLL	= (1 << 14),	// 8169
 	Normal_mode	= (1 << 13),	// unused
 	Force_half_dup	= (1 << 12),	// 8168 8101
 	Force_rxflow_en	= (1 << 11),	// 8168 8101
@@ -5212,11 +5213,8 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 	tp->cp_cmd |= PCIMulRW;
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_02 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_03) {
-		netif_dbg(tp, drv, tp->dev,
-			  "Set MAC Reg C+CR Offset 0xe0. Bit 3 and Bit 14 MUST be 1\n");
-		tp->cp_cmd |= (1 << 14);
-	}
+	    tp->mac_version == RTL_GIGA_MAC_VER_03)
+		tp->cp_cmd |= EnAnaPLL;
 
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 
-- 
2.24.1

