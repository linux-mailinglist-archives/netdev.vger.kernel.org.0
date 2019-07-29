Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE6778E5D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfG2OtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:49:04 -0400
Received: from gateway36.websitewelcome.com ([192.185.195.25]:26584 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbfG2OtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:49:03 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 10:49:03 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id AD4F0400C8F52
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:49:12 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id s6aJhrfd790ons6aJhjIzq; Mon, 29 Jul 2019 09:25:07 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NBg3ypbm56vJ5nByaMp1eHrBG/oKINIBK+Vq+wESKT0=; b=A7uomH9Hb4wDBRLWnhYsJYAm7d
        FNXmzwRvmbx2dE54sBW398poQFOThzC6Re1aLy1TBI6QAZY7G0ixMNgyT2/rOih1iZoS3XTrw8Vdw
        9mKhy+5taaBkKjM7FdByOfZT6fnYet9UevPJUQHn5HurjFBKCTNEEwjLJwcseIv2bfMlGyj25/34d
        8J36GY+IAE90BzW425xXPtX+ellj4uw+yTI1sxvvOOBTUzQD4lv/2ZGbR4u3+9CI2IDMx8x4ZFLuq
        NTTej80qtXt2gs+dgDXZaZqxU0y5/CvgC8MeIh7LCdl4SgQz7cCdnExD8KT+mn++DHVxpHvXEOU69
        YeWTw38Q==;
Received: from [187.192.11.120] (port=50414 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hs6aH-002Hdm-Vp; Mon, 29 Jul 2019 09:25:06 -0500
Date:   Mon, 29 Jul 2019 09:25:03 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] arcnet: com20020-isa: Mark expected switch fall-throughs
Message-ID: <20190729142503.GA7917@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hs6aH-002Hdm-Vp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:50414
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/net/arcnet/com20020-isa.c: warning: this statement may fall
through [-Wimplicit-fallthrough=]:  => 205:13, 203:10, 209:7, 201:11,
207:8

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/arcnet/com20020-isa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index 28510e33924f..cd27fdc1059b 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -197,16 +197,22 @@ static int __init com20020isa_setup(char *s)
 	switch (ints[0]) {
 	default:		/* ERROR */
 		pr_info("Too many arguments\n");
+		/* Fall through */
 	case 6:		/* Timeout */
 		timeout = ints[6];
+		/* Fall through */
 	case 5:		/* CKP value */
 		clockp = ints[5];
+		/* Fall through */
 	case 4:		/* Backplane flag */
 		backplane = ints[4];
+		/* Fall through */
 	case 3:		/* Node ID */
 		node = ints[3];
+		/* Fall through */
 	case 2:		/* IRQ */
 		irq = ints[2];
+		/* Fall through */
 	case 1:		/* IO address */
 		io = ints[1];
 	}
-- 
2.22.0

