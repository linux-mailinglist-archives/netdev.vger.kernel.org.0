Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67EB614DB
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 14:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfGGMAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 08:00:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38093 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGGMAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 08:00:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so13717358wmj.3
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AIpsY9TL96agvwfZAQfGLAPLyYEJufrw43bmx11bw7Y=;
        b=JRPZmbC4G36SExU+mkixfrS2RlAqe4AS1c/GyWurvcCaLi96djZUlQcCJHeSJXoQ9X
         J/3FVQ0IpSIWMCMhrclIh6wU0JUlp4HqeFXREBHnvZ/2q1xiiel558Nn0enTBxptqnZX
         F2Y+yRVIfqGgvsrQU0HevXdjvdlq/+8SxjODJzhgxVacnBbPrSxlekWo/Kwhbi8yUqqW
         kQdkaKRWCMGk01SRhZRjqdJat+ViBeC+Pbj6dpvHFgz6RHZ7sSgNoRE28RUx+djdzJN/
         BfAukTOZ2iSTlV/MOzB0hJMl0K70QMnQCxirptXTV/u4Lfd1qFdPeWY/lm33tjGpz2F1
         v8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AIpsY9TL96agvwfZAQfGLAPLyYEJufrw43bmx11bw7Y=;
        b=DgvFmW3iHHWzxHzJNHqs3OzP2r/ENFgrZekKQ7Iw+gieHSgfShHMvjvDMl/DIvAC9/
         AfN9cinMqILwFTHaXbMUydMnXJHLqzfb0k5h0SwB1b7dsw9+NbAbpgCjPshjPgC853Pb
         8t4vP4T3OYubFBeKpC7prdLHZMD/SWGe+LgRWZ4uksWV2MaLnm9YF2/simPr4IlGsLV+
         Qs1DgUd3ZBafXGnVa65PAvde/oY2BYUq1pxQnO31gLBsKaalUKi45h+hAL0FH/djWUiY
         iYkJJI5N9WWBKoGIphXfdBFETmRO8qg94qAhndkcS2TDmYva1HqbNxloVim3caeDIkSH
         C63Q==
X-Gm-Message-State: APjAAAXMrdCml9YrXTG+9LnGyu8m+8H7qdUPXJrlUufBJItc5T0L0JgS
        PHE4Kg1s/op359Uvy95eYwRkaY3e
X-Google-Smtp-Source: APXvYqw5o7EofA5PKEoezpbqoJM5E0ghsmyU1S5gpIt/WR79YYEA8rxdtbF58X0yCO5uB/q6aOKnGg==
X-Received: by 2002:a1c:1d4f:: with SMTP id d76mr8231436wmd.127.1562500801084;
        Sun, 07 Jul 2019 05:00:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:dca:6e62:c372:df05? (p200300EA8BD60C000DCA6E62C372DF05.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:dca:6e62:c372:df05])
        by smtp.googlemail.com with ESMTPSA id v124sm13679780wmf.23.2019.07.07.05.00.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 05:00:00 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: sync few chip names with vendor driver
Message-ID: <491cc371-bdaa-a41e-52eb-10ebb3aa4539@gmail.com>
Date:   Sun, 7 Jul 2019 13:59:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch syncs the name of few chip versions with the latest vendor
driver version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 495d40c8f..efef5453b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -157,7 +157,7 @@ static const struct {
 	/* PCI-E devices. */
 	[RTL_GIGA_MAC_VER_07] = {"RTL8102e"				},
 	[RTL_GIGA_MAC_VER_08] = {"RTL8102e"				},
-	[RTL_GIGA_MAC_VER_09] = {"RTL8102e"				},
+	[RTL_GIGA_MAC_VER_09] = {"RTL8102e/RTL8103e"			},
 	[RTL_GIGA_MAC_VER_10] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_12] = {"RTL8168b/8111b"			},
@@ -190,9 +190,9 @@ static const struct {
 	[RTL_GIGA_MAC_VER_39] = {"RTL8106e",		FIRMWARE_8106E_1},
 	[RTL_GIGA_MAC_VER_40] = {"RTL8168g/8111g",	FIRMWARE_8168G_2},
 	[RTL_GIGA_MAC_VER_41] = {"RTL8168g/8111g"			},
-	[RTL_GIGA_MAC_VER_42] = {"RTL8168g/8111g",	FIRMWARE_8168G_3},
-	[RTL_GIGA_MAC_VER_43] = {"RTL8106e",		FIRMWARE_8106E_2},
-	[RTL_GIGA_MAC_VER_44] = {"RTL8411",		FIRMWARE_8411_2 },
+	[RTL_GIGA_MAC_VER_42] = {"RTL8168gu/8111gu",	FIRMWARE_8168G_3},
+	[RTL_GIGA_MAC_VER_43] = {"RTL8106eus",		FIRMWARE_8106E_2},
+	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
 	[RTL_GIGA_MAC_VER_45] = {"RTL8168h/8111h",	FIRMWARE_8168H_1},
 	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
 	[RTL_GIGA_MAC_VER_47] = {"RTL8107e",		FIRMWARE_8107E_1},
-- 
2.22.0

