Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9834596CE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbhKVViv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbhKVVis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 16:38:48 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FEAC061714
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 13:35:41 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id b12so35214321wrh.4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 13:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=yuOsorZSBP2BSjer5ilOCmWT18c1dGocSYSH21cXAbc=;
        b=iHbPQQhkgOk/Or/P04+/EXPyslV4KvLumOCnvbPj28yjTL6KoHQRXMsYFbkhksc0z5
         i2huLbICnMktpNX2pu2Ng0NNSNT93LqNkdl9gf8hMq/DtfwGYxxy/C90JyUpbpqzKrgd
         EDo67A/2wMPPOpYPTbfl/E3zohzPrICPLYnvAkwXG3DReLT1R8hqmYXRIIiPiDHsn7dE
         meKLFtN3Gh7D6VboLxEkYOuyfa/35v8hDKLT0ggO2n6kvrAy+Gy7RexQEf2tqIl7rxxo
         RgGx+ODk2mSIoKmQo24ABnDpB+sftJzVp/SeJfGk3yDdZFDMSp6c04PO2A1iTGnjry13
         naAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=yuOsorZSBP2BSjer5ilOCmWT18c1dGocSYSH21cXAbc=;
        b=ISG5wigjVPjGbep9AkBUvnohnN51ulrR+G71KzuJKi1C+u3ybsz1ZYlCjs2G185WII
         XXuv4YpGQ2UlCRrVvjeKnS7IDU9BjOF1EnTZVa8+qY38ON8awqu4h+LW3NWLxH/asl7U
         CHBxxgJtzU8PS84BdPSqCFRPJRIyp4oll82Ye2BXxAIvUObnJUWAkFsQVZmhGyMbT2nG
         Uhw5KpDN61QV3nWMohGzdp/vyJUx0ILJz5gcGOthiwkBy/dFKj+Q0+F0jV+ybeMhwZmi
         UOKETuftGdH+KkeBn6Fwuc5d3P71I6m8OflDRNqYbtq20oH/8DkAWAX9Bk+ICkOb0M7G
         e5BA==
X-Gm-Message-State: AOAM533VbfQljjoauC43sJ5MNQpMmGABQQegnbBeEodiwYeq9amkfm2D
        fyyRG63NhaCTQktcnsi6ZnSGVfz3ito=
X-Google-Smtp-Source: ABdhPJymLAGNEKLExPrN8e5LTsbDIichNumaOu9pyCwOaCJSKdjNppokTXbNgg0DWgM0tzD4biV19Q==
X-Received: by 2002:adf:cd89:: with SMTP id q9mr453725wrj.205.1637616939691;
        Mon, 22 Nov 2021 13:35:39 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:addf:401c:5353:591e? (p200300ea8f1a0f00addf401c5353591e.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:addf:401c:5353:591e])
        by smtp.googlemail.com with ESMTPSA id n13sm10256890wrt.44.2021.11.22.13.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 13:35:39 -0800 (PST)
Message-ID: <1100ed0d-7618-f6d6-d762-4c0c6ae6ef40@gmail.com>
Date:   Mon, 22 Nov 2021 22:35:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Herbert <rherbert@sympatico.ca>
Content-Language: en-US
Subject: [PATCH net] r8169: fix incorrect mac address assignment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original changes brakes MAC address assignment on older chip
versions (see bug report [0]), and it brakes random MAC assignment.

is_valid_ether_addr() requires that its argument is word-aligned.
Add the missing alignment to array mac_addr.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=215087

Fixes: 1c5d09d58748 ("ethernet: r8169: use eth_hw_addr_set()")
Reported-by: Richard Herbert <rherbert@sympatico.ca>
Tested-by: Richard Herbert <rherbert@sympatico.ca>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Missing alignment and initialization of MAC address variable may affect
also other drivers where a similar change was made.
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e896e5eca..e9b560051 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5226,8 +5226,8 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
 
 static void rtl_init_mac_address(struct rtl8169_private *tp)
 {
+	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
 	struct net_device *dev = tp->dev;
-	u8 mac_addr[ETH_ALEN];
 	int rc;
 
 	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
@@ -5242,7 +5242,8 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-	eth_hw_addr_random(dev);
+	eth_random_addr(mac_addr);
+	dev->addr_assign_type = NET_ADDR_RANDOM;
 	dev_warn(tp_to_dev(tp), "can't read MAC address, setting random one\n");
 done:
 	eth_hw_addr_set(dev, mac_addr);
-- 
2.34.0

