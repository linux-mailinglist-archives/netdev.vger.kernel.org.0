Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B31547DD39
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbhLWBQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:38 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18348 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345813AbhLWBOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=6QXkOacECeXoh5s5NBM40R3qV30Md7UBrpN7t6KOPGo=;
        b=jEsfdGGUqZlOHJ+qiIdYcdiGc8y5cjxsk0E8S4tSYvGbZuBtCtw94/79qfawzR2qfIY0
        wpWdYTloK4wUIeW/etD4crH6ouhIR31tqxcM4v+fPpuwNlWiM7+rgXw8NoyFdFBqHPGHhQ
        xJWxMK7H+5EME/K7ltURYiCX5Eeblq/Ce+21KPeVlycQrQjGiqU6dY7kxiXI1woA1jcEVv
        nQTaXg0StAaZkcYRq299C8ioYioItUJowXKvNNsNFLLIpTU/Po6UU5Cy4gEqmaaMpMmCAl
        a53p0GErHe8lV7d8n1E0iIfD7icUZodNdoDyoq96HNJpn9heDL/xlnkVsxXVCLAg==
Received: by filterdrecv-75ff7b5ffb-96rhp with SMTP id filterdrecv-75ff7b5ffb-96rhp-1-61C3CD5E-1D
        2021-12-23 01:14:06.586363998 +0000 UTC m=+9687226.466870642
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id LDXSjrTJS9u9LcGCsLIr-w
        Thu, 23 Dec 2021 01:14:06.471 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 4AE897013D2; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 21/50] wilc1000: declare read-only ac_preserve_ratio as
 static and const
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-22-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLZxHI1WTv+apMggT?=
 =?us-ascii?Q?xpW6dVO07dWMAWJoY1Bu46DX+LwUkE7cVHmQvQr?=
 =?us-ascii?Q?gtXMbB8mrMynCaXw8lkkNDKys91eMLDJcUho4+D?=
 =?us-ascii?Q?F67OjTcEQJiZJcUm9a8zHoZjbwgohSkhJys+2om?=
 =?us-ascii?Q?oQalc1FSy9z0gxWaRkQz6z7Rb2j0DBpAWKPDGD?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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
index dc6608390591c..bdc31a4fd0f6a 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -636,8 +636,8 @@ static int fill_vmm_table(const struct wilc *wilc,
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

