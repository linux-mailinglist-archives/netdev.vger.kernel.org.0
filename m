Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD183F4BFF
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhHWN7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:59:52 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:59653 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhHWN7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:59:51 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 212CE5437CF;
        Mon, 23 Aug 2021 13:53:34 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-18-119.trex.outbound.svc.cluster.local [100.96.18.119])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 7E4AC5437A3;
        Mon, 23 Aug 2021 13:53:32 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.18.119 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Slimy-Versed: 489b462e0c13385e_1629726813930_3728698331
X-MC-Loop-Signature: 1629726813929:3995452386
X-MC-Ingress-Time: 1629726813929
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5Kzol4AmIih7irLvoFK1VMpJ7mh6ToiDqT3dewBp/VI=; b=yzP4bV41toUdcCEedGF2XkNPtA
        cAX8L7UXD6SwKWHXavxbI2ssRZDmxV931RQ3bQTVAo+tgr4vhc0db3ZkcjfJzV6OYlHbE2gdrX8IH
        jiaiHTeBxPfceiRxGvXpMSF8Eicx1qHytH1mG08ROUf8lHmIhAgWG8CAS8w9ak+/YaubHgMgw18Gj
        9Z2+zvwmX7z9Ambay78LEuyE9AaFw7YDT0rx2yWhusvnfbIBgWvau+QWPqg8O7TVMif3QFkTeu3aL
        cZ3ueryMZA+yOki52zTogXWC79g+pyS7WbAcI0GZ692zSkv2TI3n1B8EL4An+MeZ8ZJy7zXMQrV9A
        gKRtpfog==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOI-003PzY-SE; Mon, 23 Aug 2021 14:53:30 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 04/10] lan78xx: Remove unused pause frame queue
Date:   Mon, 23 Aug 2021 14:52:23 +0100
Message-Id: <20210823135229.36581-5-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the pause frame queue from the driver. It is initialised
but not actually used.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index ccfb2d47932d..746aeeaa9d6e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -383,7 +383,6 @@ struct lan78xx_net {
 	struct sk_buff_head	rxq;
 	struct sk_buff_head	txq;
 	struct sk_buff_head	done;
-	struct sk_buff_head	rxq_pause;
 	struct sk_buff_head	txq_pend;
 
 	struct tasklet_struct	bh;
@@ -2710,8 +2709,6 @@ static int lan78xx_stop(struct net_device *net)
 
 	usb_kill_urb(dev->urb_intr);
 
-	skb_queue_purge(&dev->rxq_pause);
-
 	/* deferred work (task, timer, softirq) must also stop.
 	 * can't flush_scheduled_work() until we drop rtnl (later),
 	 * else workers could deadlock; so make workers a NOP.
@@ -3003,11 +3000,6 @@ static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 {
 	int status;
 
-	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
-		skb_queue_tail(&dev->rxq_pause, skb);
-		return;
-	}
-
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += skb->len;
 
@@ -3674,7 +3666,6 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->rxq);
 	skb_queue_head_init(&dev->txq);
 	skb_queue_head_init(&dev->done);
-	skb_queue_head_init(&dev->rxq_pause);
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 
-- 
2.25.1

