Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BE2156984
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 08:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgBIHg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 02:36:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41958 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgBIHg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 02:36:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id j9so2037659pfa.8
        for <netdev@vger.kernel.org>; Sat, 08 Feb 2020 23:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vs40ech2nqzZecsscoUYDUd7q5qMLMdyUKvxJgn5+wg=;
        b=TgzaF+zIiOJhR0oJR2Cn5Mxw0wYQAog9i8mQhKUMRySHmKqTZTMjAM1oUGZrBTQIOl
         G0y2g+K/jQS4H03zp8FSi/4z6uqUnt6QWsCUommNmJzPMs58ferWNQ8Tx66wibrdBU2A
         /bZOlEp6gE/91tHvydyeRFO+cDNupSIS0TY5B27QDtlNh56NyXWCOmCFETDi/kSFk5jz
         8M9pTRZtjTALghJQv4wlzvbL4kE1z9sDRGvHoX7/PWDzqM8WS+j15SrnM9gzU7yK/xLU
         TVo059ogw/MpTj2QNbRhGzdLfScUPRcRH+Klf++3ADMcRW3YJ7c8CVKv2m2sVL40Ae/U
         1vXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vs40ech2nqzZecsscoUYDUd7q5qMLMdyUKvxJgn5+wg=;
        b=roNQcyzNqsL346JyUBiPvJ4nPWoGoO1s3KGkb5Nps3GcDSIO94CXKRTwRGLtALUKoS
         7djzSJs/72tsARlpIyC20bvjfs2qzekyv0cR0BuvNS8uJHJsRgTMe6zEH4KlljRKERcj
         1X+d4OdjSMsCbBKzohsGVp9vjqrvNbt6grhuk0RXEm6LabmfhIoFDGzankqsR0x6/vvS
         g6kJWnK2QmVYP1znNv5F4NnZhxDbFDkXgoNkXLzU2PkJrT2OZNjLSGhWg11JmnUSNAZ+
         ux6oD+8Io0UHvu2yZ8xeZrf8FaqE4syYKOPaOnZtE71e1K38uRS+CsboKyusra75QByi
         ZRVA==
X-Gm-Message-State: APjAAAUucmRdY+5hWkV4tlG+HrFZF+qErxV/QNOXfcQqNEIueAqJ0ywQ
        x11ScuuQUvWVemp/kC8OnSIEqQj4
X-Google-Smtp-Source: APXvYqypMXFwhPVrkTVJLygmKcOuBJN1wj+mfT1KyIr5TW1Z6vfVOLIUb2brUg3sZzJV65o62Qry9Q==
X-Received: by 2002:a63:e044:: with SMTP id n4mr7961359pgj.338.1581233785160;
        Sat, 08 Feb 2020 23:36:25 -0800 (PST)
Received: from localhost.localdomain (S0106bcd16567bb27.ed.shawcable.net. [68.150.202.68])
        by smtp.gmail.com with ESMTPSA id y64sm7926175pgb.25.2020.02.08.23.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 23:36:24 -0800 (PST)
From:   Jarrett Knauer <jrtknauer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jarrett Knauer <jrtknauer@gmail.com>
Subject: [PATCH] staging: qlge: Fixed extra indentation in qlget_get_stats()
Date:   Sun,  9 Feb 2020 00:36:21 -0700
Message-Id: <20200209073621.30026-1-jrtknauer@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlge TODO cited weird indentation all over qlge files, with
qlget_get_stats() as an example. With this fix the TODO will need to be
updated as well.

This is also a re-submission, as I incorrectly sent my first patch
directly to the maintainers instead of to the correct mailing list.
Apologies.

Signed-off-by: Jarrett Knauer <jrtknauer@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef8037d0b52e..a56bd69afd35 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4123,11 +4123,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get RX stats. */
 	pkts = mcast = dropped = errors = bytes = 0;
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
-			pkts += rx_ring->rx_packets;
-			bytes += rx_ring->rx_bytes;
-			dropped += rx_ring->rx_dropped;
-			errors += rx_ring->rx_errors;
-			mcast += rx_ring->rx_multicast;
+		pkts += rx_ring->rx_packets;
+		bytes += rx_ring->rx_bytes;
+		dropped += rx_ring->rx_dropped;
+		errors += rx_ring->rx_errors;
+		mcast += rx_ring->rx_multicast;
 	}
 	ndev->stats.rx_packets = pkts;
 	ndev->stats.rx_bytes = bytes;
@@ -4138,9 +4138,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get TX stats. */
 	pkts = errors = bytes = 0;
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
-			pkts += tx_ring->tx_packets;
-			bytes += tx_ring->tx_bytes;
-			errors += tx_ring->tx_errors;
+		pkts += tx_ring->tx_packets;
+		bytes += tx_ring->tx_bytes;
+		errors += tx_ring->tx_errors;
 	}
 	ndev->stats.tx_packets = pkts;
 	ndev->stats.tx_bytes = bytes;
-- 
2.17.1

