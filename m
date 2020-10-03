Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31A92825A3
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 19:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgJCRfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 13:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJCRff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 13:35:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C915AC0613D0;
        Sat,  3 Oct 2020 10:35:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so3051338pgl.2;
        Sat, 03 Oct 2020 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2D17a00wejIh6SMkTte/xd0hBTvlzW+TGrZeiOnUiA=;
        b=MxhTZenC9HVCUiViU4wpZ+8EAqbTvVycsVBX423eXRxUx/uZTioNT+U6ayqrEcOhzp
         O7hRn4BJNm3hEVpDNo+dEu+wYGw35io74OwUCaPN8YnaqeKYh12fE8yGdQ4pqLfrqZLt
         s0SJp4SAkyez25Vrm5PmoAu4QkdXX9mfLk6TnL/+qO8DPuRqwnxvgK37cWxCfepJ+NR0
         d7ndeDF0Ciw82ZZ+GZdS2Eif5BQRX8/FtAp90JntH4tppPWw4G1aherTU+hb9kmYrbcZ
         lQvx38vPDVCDmy9A14aTuJIbaJhH4BTJwtV98//rOWsDUqGiQnlOg2CSb76lybJq+oMs
         rwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2D17a00wejIh6SMkTte/xd0hBTvlzW+TGrZeiOnUiA=;
        b=TVHxV1nPUo131TwMZARCaLLk+jZfTnUCHi6FtJoeJLNaGCG4p+ROKhJPS4sj16/4kl
         XLF25ujDN+13oDMSlHvzi7l++YYKTJ53dbBHcTJZnHb5pZ/+wZ+/Pz0eAkRSMUZV0uYL
         ZnA7/vXaS2a5A10h5kBGUgxzpeZxzE3nEe0S73srr0Ho5SWmdmkfZLflf7ch7n6CIhGa
         r9WDfXBUgJU0Uf52sNjnT2eimhDId2pWbJ6MZRFJ2vLQyPccBl45LsdJLZD8e/RyE6RI
         I/udlyaETUa9amJGCgVkxU3S7Hj2Lx5+kEfJA9JsnKEb2fms/zqN/3T6oGu0Jn3fYaiX
         NJUA==
X-Gm-Message-State: AOAM531jQcAgUeh+jixPJxv8iXnNILeY+B3KEVUD64e148DaWqZqJK9p
        ytWz3kLJKB0ZxkxRbTdkimmBuBauZAA=
X-Google-Smtp-Source: ABdhPJzl4H1dMHCXa5KYVL+gqispJ+CNKQAFVvw2YUe5w/t5q5sQKKRIp4hNkyMlHqTEycu+VIm10A==
X-Received: by 2002:a62:830c:0:b029:152:3490:c8e6 with SMTP id h12-20020a62830c0000b02901523490c8e6mr7374648pfe.6.1601746535392;
        Sat, 03 Oct 2020 10:35:35 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:25ba:f7b0:670e:518f])
        by smtp.gmail.com with ESMTPSA id c9sm5496445pgl.92.2020.10.03.10.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 10:35:34 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] drivers/net/wan/hdlc_fr: Reduce indentation in pvc_xmit
Date:   Sat,  3 Oct 2020 10:35:28 -0700
Message-Id: <20201003173528.41404-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Keep the code for the normal (non-error) flow at the lowest
indentation level. This reduces indentation and makes the code feels
more natural to read.

2. Use "goto drop" for all error handling. This reduces duplicate code.

3. Change "dev_kfree_skb" to "kfree_skb" in error handling code.
"kfree_skb" is the correct function to call when dropping an skb due to
an error. "dev_kfree_skb", which is an alias of "consume_skb", is for
dropping skbs normally (not due to an error).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 58 ++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 3a44dad87602..48aaf435da50 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -416,38 +416,40 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct pvc_device *pvc = dev->ml_priv;
 
-	if (pvc->state.active) {
-		if (dev->type == ARPHRD_ETHER) {
-			int pad = ETH_ZLEN - skb->len;
-			if (pad > 0) { /* Pad the frame with zeros */
-				int len = skb->len;
-				if (skb_tailroom(skb) < pad)
-					if (pskb_expand_head(skb, 0, pad,
-							     GFP_ATOMIC)) {
-						dev->stats.tx_dropped++;
-						dev_kfree_skb(skb);
-						return NETDEV_TX_OK;
-					}
-				skb_put(skb, pad);
-				memset(skb->data + len, 0, pad);
-			}
-		}
-		skb->dev = dev;
-		if (!fr_hard_header(&skb, pvc->dlci)) {
-			dev->stats.tx_bytes += skb->len;
-			dev->stats.tx_packets++;
-			if (pvc->state.fecn) /* TX Congestion counter */
-				dev->stats.tx_compressed++;
-			skb->dev = pvc->frad;
-			skb->protocol = htons(ETH_P_HDLC);
-			skb_reset_network_header(skb);
-			dev_queue_xmit(skb);
-			return NETDEV_TX_OK;
+	if (!pvc->state.active)
+		goto drop;
+
+	if (dev->type == ARPHRD_ETHER) {
+		int pad = ETH_ZLEN - skb->len;
+
+		if (pad > 0) { /* Pad the frame with zeros */
+			int len = skb->len;
+
+			if (skb_tailroom(skb) < pad)
+				if (pskb_expand_head(skb, 0, pad, GFP_ATOMIC))
+					goto drop;
+			skb_put(skb, pad);
+			memset(skb->data + len, 0, pad);
 		}
 	}
 
+	skb->dev = dev;
+	if (fr_hard_header(&skb, pvc->dlci))
+		goto drop;
+
+	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	if (pvc->state.fecn) /* TX Congestion counter */
+		dev->stats.tx_compressed++;
+	skb->dev = pvc->frad;
+	skb->protocol = htons(ETH_P_HDLC);
+	skb_reset_network_header(skb);
+	dev_queue_xmit(skb);
+	return NETDEV_TX_OK;
+
+drop:
 	dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1

