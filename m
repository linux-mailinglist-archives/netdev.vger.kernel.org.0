Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9492AF1C4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgKKNMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKKNMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:12:48 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE54C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:12:47 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id i6so3111410lfd.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=i1WbfAg1yyuXiRjmBTP7D1L29zG75HMcZ+INQu0J2F8=;
        b=E0beAMvrGka58g7Sx2TwzB07H1KR6ieX1vM5aUlb74ELzBqTb2MLTMmVEo9yct2Hzg
         PGWh3bEwlgaCjjv1ju3LY/gv0ocBGhhmajZ2r+k+EjaN6K6UgJMS+fepLR4UnsBicS3y
         zbKX8e5tkqJihTI5Xv/3JwqXolKm1DhPee+bC2IlGesKinskSEQQAIfyd/gkkCrCM8Jd
         ur9Ae4duiSgCSjMMHZOeKs1SG//LAXnVKDFI3Yc816lfg1IM8PqHNkynk9RQyxeYL69x
         PSPAfZ329WBqg17+aMKcxfW9mOazPr6yAr1A/ohs5lrRF8vgFkHUDzEQT4g/9fm4k+e7
         x8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=i1WbfAg1yyuXiRjmBTP7D1L29zG75HMcZ+INQu0J2F8=;
        b=NMKAxGYY7UTKnCO95fr0RJT76REQF+2FsLmfqal0vUiA0bWMpY4UVzsWkxm6XsbaET
         HGTORUWpZQH1yPBCkLpIl6IJiWQcvE0KxqFxX5UsXVtVpG3zA1uObdmqYzVp+Voxlq+L
         ioHpUR/scsaSn012JweEr6EO7qHXWqbMQGsT0ft9lkKoKRfvccMkexto/PdMYHaCnEmO
         NmPp1PJbTTmEU4F4bcY/S10vSEmCysnqqVjyMVnldb8DKsEn0MLgfU/Su/FfiFmTe+OO
         2kyoBsv/bMjpR7kxTaCh/ZkpnrlRiwHF6btg26ks0fDgGOuzS9TnDPMWimwIS9ENtNun
         +WWw==
X-Gm-Message-State: AOAM530/L9F8/Et0dhzT3bBWDZ+hGrQOpIA5P4CyD1dmLsh7ZfS0e1Ux
        8Uzq3jlajrpQFkYghX9DkTiZVw==
X-Google-Smtp-Source: ABdhPJzswB9TEeqA6S1xY2FWPRiV9/rQQMPo1pCO0/H8RClPm3Pe+EGTx5esvY8jbtf+u9qEC/vZbQ==
X-Received: by 2002:a19:c53:: with SMTP id 80mr10168479lfm.299.1605100365923;
        Wed, 11 Nov 2020 05:12:45 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w22sm231108ljm.20.2020.11.11.05.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:12:45 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: dsa: tag_dsa: Use a consistent comment style
Date:   Wed, 11 Nov 2020 14:11:53 +0100
Message-Id: <20201111131153.3816-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111131153.3816-1-tobias@waldekranz.com>
References: <20201111131153.3816-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a consistent style of one-line/multi-line comments throughout the
file.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/tag_dsa.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index b44b75a4c809..4d5d605f0f57 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -113,21 +113,17 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 *dsa_header;
 
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		/*
-		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
-		 */
 		if (extra) {
 			skb_push(skb, extra);
 			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
 		}
 
+		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
 		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
 		dsa_header[1] = dp->index << 3;
 
-		/*
-		 * Move CFI field from byte 2 to byte 1.
-		 */
+		/* Move CFI field from byte 2 to byte 1. */
 		if (dsa_header[2] & 0x10) {
 			dsa_header[1] |= 0x01;
 			dsa_header[2] &= ~0x10;
@@ -136,9 +132,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		skb_push(skb, DSA_HLEN + extra);
 		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/*
-		 * Construct untagged FROM_CPU DSA tag.
-		 */
+		/* Construct untagged FROM_CPU DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
 		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
 		dsa_header[1] = dp->index << 3;
@@ -157,9 +151,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
 
-	/*
-	 * The ethertype field is part of the DSA header.
-	 */
+	/* The ethertype field is part of the DSA header. */
 	dsa_header = skb->data - 2;
 
 	cmd = dsa_header[0] >> 6;
@@ -222,8 +214,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	if (dsa_header[0] & 0x20) {
 		u8 new_header[4];
 
-		/*
-		 * Insert 802.1q ethertype and copy the VLAN-related
+		/* Insert 802.1Q ethertype and copy the VLAN-related
 		 * fields, but clear the bit that will hold CFI (since
 		 * DSA uses that bit location for another purpose).
 		 */
@@ -232,16 +223,13 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 		new_header[2] = dsa_header[2] & ~0x10;
 		new_header[3] = dsa_header[3];
 
-		/*
-		 * Move CFI bit from its place in the DSA header to
-		 * its 802.1q-designated place.
+		/* Move CFI bit from its place in the DSA header to
+		 * its 802.1Q-designated place.
 		 */
 		if (dsa_header[1] & 0x01)
 			new_header[2] |= 0x10;
 
-		/*
-		 * Update packet checksum if skb is CHECKSUM_COMPLETE.
-		 */
+		/* Update packet checksum if skb is CHECKSUM_COMPLETE. */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
 			__wsum c = skb->csum;
 			c = csum_add(c, csum_partial(new_header + 2, 2, 0));
-- 
2.17.1

