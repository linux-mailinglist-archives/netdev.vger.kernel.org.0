Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C18847447
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfFPKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 06:43:34 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46390 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfFPKne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 06:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X2ZJjUrpmLI/k0p1CCuDVRehHC/AHtceZzE7yAAt2rI=; b=jfEMHIaDopccmWn0dKG07Kjf5B
        vDt1gkxkVWeoB90V5D0hX2tLKg86dsEfk8AavdEDPD4hBX7Dsby8pD5r4r0g64FVNuWg+l3cruisA
        93JGhEF0p7NKuYY21ufUoejEN2vTngYNgmIbHOcIE5hLXuC/+4yl8BfPy/JK26JECuX/yfWMSnnv1
        vlG6nZUxUKRzGEW1tZu3nNQu+xdUQxaDWLkkyaua1MAejaqCE2aOjOCcqCA5p/t0M8MBxfIAbyRwh
        JPcu1i+9tsgKHGsHlaBkelDA0ThwiRYcCtnqaSDcV2HUdVVOQQNUFs7niNEKrsxwDUMDjFFT5As0Q
        ZLj1DupA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hcSdI-00065Q-Kw; Sun, 16 Jun 2019 11:43:32 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] x25_asy: fixed function name in error message.
Date:   Sun, 16 Jun 2019 11:43:32 +0100
Message-Id: <20190616104332.20315-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replaced incorrect hard-coded function-name in error message with
__func__.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 drivers/net/wan/x25_asy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index d78bc838d631..914be5847386 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -602,8 +602,8 @@ static void x25_asy_close_tty(struct tty_struct *tty)
 
 	err = lapb_unregister(sl->dev);
 	if (err != LAPB_OK)
-		pr_err("x25_asy_close: lapb_unregister error: %d\n",
-		       err);
+		pr_err("%s: lapb_unregister error: %d\n",
+		       __func__, err);
 
 	tty->disc_data = NULL;
 	sl->tty = NULL;
-- 
2.20.1

