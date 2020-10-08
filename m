Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC81A287104
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgJHI5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:57:36 -0400
Received: from ns.lineo.co.jp ([203.141.200.203]:38830 "EHLO mail.lineo.co.jp"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJHI5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 04:57:35 -0400
Received: from [172.31.78.0] (unknown [203.141.200.204])
        by mail.lineo.co.jp (Postfix) with ESMTPSA id EC40F80177BA3;
        Thu,  8 Oct 2020 17:47:31 +0900 (JST)
From:   Naoki Hayama <naoki.hayama@lineo.co.jp>
Subject: [PATCH 1/6] net: tlan: Fix typo abitrary
To:     Samuel Chessman <chessman@tux.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Naoki Hayama <naoki.hayama@lineo.co.jp>
Message-ID: <cb23855e-7745-e807-e482-79d6d4f32478@lineo.co.jp>
Date:   Thu, 8 Oct 2020 17:47:31 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix comment typo.
s/abitrary/arbitrary/

Signed-off-by: Naoki Hayama <naoki.hayama@lineo.co.jp>
---
 drivers/net/ethernet/ti/tlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 76a342ea3797..e922258cae3f 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2511,7 +2511,7 @@ static void tlan_phy_power_down(struct net_device *dev)
 	}
 
 	/* Wait for 50 ms and powerup
-	 * This is abitrary.  It is intended to make sure the
+	 * This is arbitrary.  It is intended to make sure the
 	 * transceiver settles.
 	 */
 	tlan_set_timer(dev, msecs_to_jiffies(50), TLAN_TIMER_PHY_PUP);
-- 
2.17.1
