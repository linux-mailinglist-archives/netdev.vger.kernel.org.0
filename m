Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7A2B3178
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKNXqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgKNXqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:46:23 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DC3C0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:23 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id 142so1764313ljj.10
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=nBUyZsheR+BJ/EUVMST34fYt5tquvlb5opcpb7PceHg=;
        b=Jn/AL00BdoDqQ6SbNi7lwssTHmOweNtLEjZNk/mOx5nTz4buCqmr2yPx2Fz3D8MRiS
         GqcgPJsrCpUuSY1p1qT2ON6QCI3j38w+SAOzBRpZAzCHwXzM9su6dKbhD8VWQGq2ZbpH
         HWubG7j7jxhYl6v35TP6fmYF36uknbhBxFM3kiHEoeMYtTwKHU0OJO6rOyFn5T88aNOf
         2TowCaPk2CHQ2QQKiFsLuUdImN5RrXoaXySflxqlXBQ6q07egHiAz8K/5cEnZI8Y/ttz
         1qy7Ku2/XMPf3k1QIlvKWyWOWrekbY6vdEgNUBvlemLsSGDFBzC1A0lG/SRw/RAml9cw
         imiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=nBUyZsheR+BJ/EUVMST34fYt5tquvlb5opcpb7PceHg=;
        b=cztTgiB4tAVkFdzHq1D90gZ6H/rENvvWeqzQ59c6fV6Y3JOVcuGeW6SctNqyDrpOyo
         as9x/UalSRpTgBGcGOTaXnfCGxOVmZAqSYmfITy2xHeoZ6uHnFn6kSRiwVJRQvBZoLBO
         Lwdv9iv276N8D7h2WgavUe+8KDPRfhIp3QjJjASZLMMoMq2M/UYV7j4uaj9uvNuOc5HS
         fTON3oEGIYespzL7M3LVeOvC64fZ+UZTwkQeu+O0sIphVyUau6xMNHohtMN/TKj2Y2Er
         rZTQzoDXy4cwX9KJGpEevsPz6FPtGgy/SJHmQ6+iUXBnkVUACoIa9ESWCYZT30NyX/x4
         +xrA==
X-Gm-Message-State: AOAM531s2diA6Tyr8OosAwE4W7LXk6yqoUnfD2qv3yqMhnhVyizUPDmQ
        qUpwGxTqMhtncu3qw+KyATHXDw==
X-Google-Smtp-Source: ABdhPJygTFtnfhaDSIroJuIfFi2KOZ7Ck6R514Rus3dXlSebGikeZPxVVawjDcKqj5KnyA7BW3tldw==
X-Received: by 2002:a2e:96d6:: with SMTP id d22mr1410193ljj.295.1605397582023;
        Sat, 14 Nov 2020 15:46:22 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g3sm2112157lfd.209.2020.11.14.15.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 15:46:21 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 3/3] net: dsa: tag_dsa: Use a consistent comment style
Date:   Sun, 15 Nov 2020 00:45:58 +0100
Message-Id: <20201114234558.31203-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201114234558.31203-1-tobias@waldekranz.com>
References: <20201114234558.31203-1-tobias@waldekranz.com>
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
index 04646dd71c6c..112c7c6dd568 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -129,21 +129,17 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
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
@@ -152,9 +148,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		skb_push(skb, DSA_HLEN + extra);
 		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/*
-		 * Construct untagged FROM_CPU DSA tag.
-		 */
+		/* Construct untagged FROM_CPU DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
 		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
 		dsa_header[1] = dp->index << 3;
@@ -173,9 +167,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
 
-	/*
-	 * The ethertype field is part of the DSA header.
-	 */
+	/* The ethertype field is part of the DSA header. */
 	dsa_header = skb->data - 2;
 
 	cmd = dsa_header[0] >> 6;
@@ -236,8 +228,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	if (dsa_header[0] & 0x20) {
 		u8 new_header[4];
 
-		/*
-		 * Insert 802.1q ethertype and copy the VLAN-related
+		/* Insert 802.1Q ethertype and copy the VLAN-related
 		 * fields, but clear the bit that will hold CFI (since
 		 * DSA uses that bit location for another purpose).
 		 */
@@ -246,16 +237,13 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
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

