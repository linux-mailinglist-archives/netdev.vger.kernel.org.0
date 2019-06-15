Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1864546EE2
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfFOH63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 03:58:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36647 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfFOH63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 03:58:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so4787078wrs.3
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 00:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i/t2vbB1sRAB8sDP8+1MIQnezYktxcemQ//T9jjfqPA=;
        b=n9BHaCKwUsDVsBlgqhadagT1fRvRy7Rbjo7SGZD+p8FZRQXA3h5Jxsop4U1GD6rOIV
         41rrNAxzvSO+qCPDa1xNC4XpnLzMUZBA/2eMlGfDlVBVB0fDwd8f3BJC3hV1xYA2+xiF
         H6UBk0mZUyCXTp7SibcRMNe//4u6b9xgfEIV2POPSp+Jx2eahXaVWuv72KoRxaNEjKf+
         neJOhY2XoC6mQXZIyGdSjiXzmxn7ctw09LGXrmksDjjA8VTiz1hZqCxbKPYEdlSneX1m
         wtzHRUbDo8B3geug1pYkchhySaT9e4VKlpx/HHpGGD6yYufV5OIrMXztdv8DY6j9dEVk
         ez1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=i/t2vbB1sRAB8sDP8+1MIQnezYktxcemQ//T9jjfqPA=;
        b=Pbsxe5tEHktLvkGOM7Wg2OUQnFCLR3Llnzdi9TjOPSgQPUK6JqJPtQLDqH3DD/bCyQ
         eAHsQ7TsKtnD0RUoW3v5Helb17KSl2AzHEDESuDlpZZ5EHdF1xOIQxK745GRejelwMkF
         V+7oBhYdbbTt0Ktmf662Y1f1YeUbsqNfVd0yF5VpeQHsiUftiNnsKrNC1L5pPokGKK1k
         NA2MNGJIHAurHLmKnqJ+i+7Gb/A6e0ngZLbwjJcGvAIaXf2cP8WYosPdA3/PLzBqazxG
         VDr6bDtTkkWhQZ/+dKsShhcao/Ko0kjwNSR/WqDZUX1Hchr9Iz4CobBPJFgUhPP9wZTT
         JyGg==
X-Gm-Message-State: APjAAAUC1N8jmNi0eU3MJ5yZ1NZBnBNFIE/ElN1bRv1TsPCtM6A6JhgG
        //a6cYG7sS6EwCn0fp860rnaODnl
X-Google-Smtp-Source: APXvYqyC70hjj2eLJrNM3fFVuw9gt+egMZKnVbuXOZqueL5q4MUYnkkUhoNPvmNTMVevr7oOPo9whQ==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr63831796wrp.149.1560585506617;
        Sat, 15 Jun 2019 00:58:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:4dbd:8368:62b2:6b96? (p200300EA8BF3BD004DBD836862B26B96.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:4dbd:8368:62b2:6b96])
        by smtp.googlemail.com with ESMTPSA id z77sm3087859wmc.25.2019.06.15.00.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 00:58:25 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve handling of Abit Fatal1ty F-190HD
Message-ID: <dd47434d-a928-6595-7be3-fd28eb3377ca@gmail.com>
Date:   Sat, 15 Jun 2019 09:58:21 +0200
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

The Abit Fatal1ty F-190HD has a PCI ID quirk and the entry marks this
board as not GBit-capable, what is wrong. According to [0] the board
has a RTL8111B that is GBit-capable, therefore remove the
RTL_CFG_NO_GBIT flag.

[0] https://www.centos.org/forums/viewtopic.php?t=23390

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 259faf7eb..5c36d92cb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -214,14 +214,12 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
 	{ PCI_VDEVICE(REALTEK,	0x8169) },
 	{ PCI_VENDOR_ID_DLINK,	0x4300,
 		PCI_VENDOR_ID_DLINK, 0x4b10, 0, 0 },
-	{ PCI_VDEVICE(DLINK,	0x4300), },
-	{ PCI_VDEVICE(DLINK,	0x4302), },
-	{ PCI_VDEVICE(AT,	0xc107), },
-	{ PCI_VDEVICE(USR,	0x0116), },
-	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
-		PCI_ANY_ID, 0x0024, 0, 0 },
-	{ 0x0001,				0x8168,
-		PCI_ANY_ID, 0x2410, 0, 0, RTL_CFG_NO_GBIT },
+	{ PCI_VDEVICE(DLINK,	0x4300) },
+	{ PCI_VDEVICE(DLINK,	0x4302) },
+	{ PCI_VDEVICE(AT,	0xc107) },
+	{ PCI_VDEVICE(USR,	0x0116) },
+	{ PCI_VENDOR_ID_LINKSYS, 0x1032, PCI_ANY_ID, 0x0024 },
+	{ 0x0001, 0x8168, PCI_ANY_ID, 0x2410 },
 	{}
 };
 
-- 
2.22.0

