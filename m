Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723025C8F8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfGBF7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:59:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39049 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfGBF7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 01:59:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so16236519wrt.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 22:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JarJ3d5k32mkG4Xjq3ZOqdnEd6nWGE8yZCJuBSCZ9jA=;
        b=HaYBeO97z+m0sCsgBhu5xnKbl5VWaPRfFQYiV+i09LQ5J8TuiZ9Qeb2pMFIlqEV55L
         IiglmnbFBKY+0I/SyytQL7deHavchHn8MB6mWX6Q4YQ2CcQF+FU92W6mPgNDd56/ZtdL
         bG+XGEiSl/9tCj2dS4pPScRPNmZo1vtOF6thgBMJvCF8p5b5qwzdSI3CyHlm3RWqcgqK
         xEOzjwpB7vgpkCBEht469EX9GKEYNBx4F006mCnHhKB/Nkrbsrg+FAvLJsX6+06hoRo4
         PBa49AvYTgS8HtouY8nm0hfMcTNz1FKs/xotCfQjgbm6Va6Yn6bnJNg2zpR4VmKWkFh4
         ypGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JarJ3d5k32mkG4Xjq3ZOqdnEd6nWGE8yZCJuBSCZ9jA=;
        b=ps8spgC3RYUtBD/CcFqFPIhZT/LCh9WWRrsVuQA4Cnf+I1vUuVQfm4CYnifGsaR3xL
         l3DnCFFMmmVJscXx/nJdPqeTEDra7lLRNSRnGY7Xi/D/v8yLyH1OSfvQ8dS62rcwEEGT
         v0kxDdUIFUs9m5O1h/blUYER+gyqiNPgu6fUbn6wui2A3yu8mK69a5o0d5AVeA1aaIlA
         7iKpPfkppN7wx2YoSq7fYbLRpIq/cbVCyY9ankLkev9IfC2dS8lCLXA3yh3Vvv4CCm76
         wHPH3VlIXWLUDjt/aE/1MrNjJFUDII4PGf2YPowCXedNKSjKAJ0l2rcGY8xRdyztsN0T
         p/vQ==
X-Gm-Message-State: APjAAAVRUaDf1Yt6e0oK+ALxP5udarKXerakymRxX2qp+ly2TfwwWOnB
        AmlLlhGtNRlRLvSCN82zslOPDUp8
X-Google-Smtp-Source: APXvYqxM7/I9EiwfVgrYdlpkGK+GTJlncDZc+QXcAa01U+Xa3xQoD/J8qJvSWFZSm1MYyHkWmt0hHQ==
X-Received: by 2002:a5d:4642:: with SMTP id j2mr20570543wrs.211.1562047163101;
        Mon, 01 Jul 2019 22:59:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:d5f3:78fc:5357:f218? (p200300EA8BD60C00D5F378FC5357F218.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:d5f3:78fc:5357:f218])
        by smtp.googlemail.com with ESMTPSA id d9sm15941943wrb.71.2019.07.01.22.59.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 22:59:22 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] Revert "r8169: improve handling VLAN tag"
Message-ID: <df6fcca2-6db6-0d76-deb2-6b2e98e8bf54@gmail.com>
Date:   Tue, 2 Jul 2019 07:59:17 +0200
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

This reverts commit 759d095741721888b6ee51afa74e0a66ce65e974.

The patch was based on a misunderstanding. As Al Viro pointed out [0]
it's simply wrong on big endian. So let's revert it.

[0] https://marc.info/?t=156200975600004&r=1&w=2

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73f25321..22b2f3dcb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1528,7 +1528,7 @@ static int rtl8169_set_features(struct net_device *dev,
 static inline u32 rtl8169_tx_vlan_tag(struct sk_buff *skb)
 {
 	return (skb_vlan_tag_present(skb)) ?
-		TxVlanTag | htons(skb_vlan_tag_get(skb)) : 0x00;
+		TxVlanTag | swab16(skb_vlan_tag_get(skb)) : 0x00;
 }
 
 static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
@@ -1536,8 +1536,7 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 	u32 opts2 = le32_to_cpu(desc->opts2);
 
 	if (opts2 & RxVlanTag)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       ntohs(opts2 & 0xffff));
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), swab16(opts2 & 0xffff));
 }
 
 static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
-- 
2.22.0

