Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E619343AEF0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJZJZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhJZJZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:25:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0D0C061745;
        Tue, 26 Oct 2021 02:22:42 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e12so17953571wra.4;
        Tue, 26 Oct 2021 02:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDuUSwzJ43UKHobbjW2e1EDI83gOPv1zGmwvqM5iqZo=;
        b=XMP3SkwwqCk3Wdc2iz3dpUODylA8YKfxe056Z1k6BxwOgBYshXC/TjQgU1M11XK0fN
         kAJZEUPFBUamqxKSubOIVzRJAU7lGUbZZInvHnFvh88plKODE6mbPoQMj3R5lKfjauJS
         v5tRyaHLISYKlkZQ+Gj8V3g8ewSoCU5BSurPJTSHsRmYqU02s/UThCz0qRGzobMMHXxE
         xAHzwnef3CCavecMIbcBXYYxsfRLYtt21hBV9J9yI0kMdgHlwVzDWOxMtx46qcUMOqzG
         QT18oWi5XCxrIa1ECQ/64eFy+m4zpMARQf0u7m6uSLXVpCS6NNGYViv6QfdyMMsgWwPd
         79qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDuUSwzJ43UKHobbjW2e1EDI83gOPv1zGmwvqM5iqZo=;
        b=0xYmqJTsTC6qF5IJ5EsXVumhJkqPzvopaKFJSfFWJQbGXwnt6PubRdAL8DsRgHqn33
         PvF8fM8R+jedzO3tKCQWV12yRU9axrFbA2NjMslgcRSW/JXrI8m6MMovx5eg9FaSjHRT
         daiVyyvnoEa80gNsE+Pe6GIua+1+3fxGFruL77C3CdphbqgONPEEjBLKiLjD5DInTlOW
         8dVEfBI0jJP1OnwjdYWtD2hpajN7SFvaTdxo4VyAYLYWAwEtyqFIAXbp79BEdXPC5Gd+
         bCeB47ANpLQKF9eq8m0MV80jH3JAnvh0WEBG4IsIB5U3fOAuz9aKxoMOpCscjVdCySUi
         aEUw==
X-Gm-Message-State: AOAM531xwy7r9pFTn6gQCB3g16x5HcwJnZNl+TXENgxu4G37y0mDhAhh
        N1XnxDN6AJ+5bg==
X-Google-Smtp-Source: ABdhPJzaxcgFF6fkdadGZqZER0gzqd0KgT/ysOo6V93J1cwz3ul3KQegAtq7JxXRChqqCZ8SoGc3nw==
X-Received: by 2002:a5d:5747:: with SMTP id q7mr21204074wrw.103.1635240160467;
        Tue, 26 Oct 2021 02:22:40 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id o26sm45809wmc.17.2021.10.26.02.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 02:22:40 -0700 (PDT)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] gve: Fix spelling mistake "droping" -> "dropping"
Date:   Tue, 26 Oct 2021 10:22:39 +0100
Message-Id: <20211026092239.208781-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a netdev_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c8500babbd1d..ef4aa6487c55 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -438,7 +438,7 @@ static bool gve_rx_ctx_init(struct gve_rx_ctx *ctx, struct gve_rx_ring *rx)
 		if (frag_size > rx->packet_buffer_size) {
 			packet_size_error = true;
 			netdev_warn(priv->dev,
-				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, droping packet.",
+				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, dropping packet.",
 				    rx->packet_buffer_size, be16_to_cpu(desc->len));
 		}
 		page_info = &rx->data.page_info[idx];
-- 
2.32.0

