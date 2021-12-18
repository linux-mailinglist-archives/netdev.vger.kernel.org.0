Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E683479E57
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhLRXyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:36 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25758 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbhLRXy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=NIm9rxhOLkpRgRFKJtyRTp7JTwyLk6yRswQbMG0UUTo=;
        b=voIRU6slURfuVeo2wOTfAkEwyphIm6JEwrC5sdgsa8ZKhxsTWlEh9eLP/4DcN43wA/Iq
        OGICVnDIdiMKzVerGfDg+7XQWQgUOEU8JtlbpbcFtAlK7k6l5SCarmMk9U9Vktw/k0c19q
        cWKPYbTMwBAY0qicqukGhkD14PPLd0D58eUtBEs6F7Hy4t8aWsXBEpvE8qqMHpS4MovyPo
        Imd7YVh3C3ZJ+D0K7KwfRQQ045OkODvdhZrVZNUbaQiAHyc7jG0CqxwihbYHzkIIiJ7Ysd
        B/asARevSESSNEqJxOpvUUf1gSCl0NiFmoTFaobOF0dPuW+a7/EUOC8S/PPiPaIQ==
Received: by filterdrecv-75ff7b5ffb-dtr6p with SMTP id filterdrecv-75ff7b5ffb-dtr6p-1-61BE74A9-6
        2021-12-18 23:54:17.223635968 +0000 UTC m=+9336808.918388692
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id bI8oJ2quQkaR_GpQKIKhaA
        Sat, 18 Dec 2021 23:54:17.102 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D824370144B; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 21/23] wilc1000: declare read-only ac_preserve_ratio as static
 and const
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-22-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFVBzuJ05dy4HNGst?=
 =?us-ascii?Q?cfpDHzb=2FqHb+wbJQVql955ae=2FixbOi74n=2FKtcks?=
 =?us-ascii?Q?OtXq5NVGKd+ISwwjQO0Y52QoGGKbuQf69d33KR6?=
 =?us-ascii?Q?zX5oaAlcFbFghcTeKRpJz3hQLeETBecCp5mPmdX?=
 =?us-ascii?Q?MPZIClysaaWJR8WWrPLpU5zOgoi891WwprsFEk?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from being slightly more efficient, this makes the code easier
to follow.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 88a981b00bda2..debed2f159215 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -633,8 +633,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 	int i;
 	u8 k, ac;
 	u32 sum;
-	u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
-	u8 *num_pkts_to_add;
+	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
+	const u8 *num_pkts_to_add;
 	bool ac_exist = 0;
 	int vmm_sz = 0;
 	struct sk_buff *tqe_q[NQUEUES];
-- 
2.25.1

