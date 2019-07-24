Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF32572EED
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfGXMet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:34:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55648 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfGXMes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:34:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so41675936wmj.5;
        Wed, 24 Jul 2019 05:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=v/8U5936Yppl/NnDrcdN5tLesq+ElyOR8SOdDoS+QNQ=;
        b=IPAbDpjiDDF5Dr9o8SYObWFlE7lJ+Kwkpt11mM3K7BrO+fAA9RgrgtKHjgvcIUV1+C
         Sidl3NGyrRU/c2UCIRARHyebN0xtwZMXwmy0f+nDb2bumzhqHNWiGkTqofmcvlCM9Lfi
         30GDMX1RD4CxSm2PkIlJ7cUv9+Ok4v2+ZgCcnjuSYbOZCjEHAr9B9hNCtSbdu7Kk7rMQ
         a8KZoN7cAnc3JTjmPaNsKNDwNwuT1zHSaTLttjy9jfzNBN+a1CKy2KegCNEkxjCYNjEx
         wp/KOYPlrlhoiZq3ZL2lNJuDBzCeq7+Zr33EMWcK95D44GsYvTdJGxVacYnFtsIK2ric
         213w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=v/8U5936Yppl/NnDrcdN5tLesq+ElyOR8SOdDoS+QNQ=;
        b=ddmmXqInbEmglNlt9DoE0r5kT4u2qOSGzz1HGjaDR9NLLbry+cv4td+R2CHWbadxOj
         SUdRmIZXN0o0+JIwACikgrtNpZ69dMojgSFxSJrIkE1MVGVFG9/DgH7PXWLqvsfw1ZOc
         1oRTCChY1SXlfWFqZGjvnVnAKtlGxDVH0w3zK4x+11oUu3W8YWXUTcTOcGBPNEr+Tl3s
         kGtaJvqFd8yKsxdIEcj7/KdioUM8Y4qorfXhD7AJMGzArRzDcDG01vlKYml4b7ShHVh6
         1vUUdzgpapLdgvjUiwcRYNo5MKZEdRaSOmsW33NkCOHcLzzyTf80eWb14iTCgIz3TWO2
         m4uA==
X-Gm-Message-State: APjAAAWg2LPRNTmM7MFgq4N94iC9ounOYfYdgDoP384B/PPEBwPFwL7A
        37mf6xHR5ilHRZEVzptbuMSTfQJKmbRQhg==
X-Google-Smtp-Source: APXvYqzi2O52hxy2jVWOUmnEgPmmn6tRYCgHuFQzmyYm4Tp0Q8iPhTKZQZzcQM3K2gtLgnMlyEPaXg==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr73330309wma.46.1563971686527;
        Wed, 24 Jul 2019 05:34:46 -0700 (PDT)
Received: from user.home (2a01cb058af5ba009405cfd54319e3d1.ipv6.abo.wanadoo.fr. [2a01:cb05:8af5:ba00:9405:cfd5:4319:e3d1])
        by smtp.gmail.com with ESMTPSA id i12sm52026636wrx.61.2019.07.24.05.34.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:34:45 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:34:43 +0200
From:   Corentin Musard <corentinmusard@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trivial@kernel.org
Subject: [PATCH] r8169: fix a typo in a comment
Message-ID: <20190724123443.GA9626@user.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "additonal" by "additional" in a comment.
Typo found by checkpatch.pl.

Signed-off-by: Corentin Musard <corentinmusard@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0637c6752a78..7231ab3573ff 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6334,7 +6334,7 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->multicast	= dev->stats.multicast;
 
 	/*
-	 * Fetch additonal counter values missing in stats collected by driver
+	 * Fetch additional counter values missing in stats collected by driver
 	 * from tally counters.
 	 */
 	if (pm_runtime_active(&pdev->dev))
-- 
2.22.0

