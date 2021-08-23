Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC63F4F42
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 19:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhHWRQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 13:16:33 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:51056 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231797AbhHWRQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 13:16:32 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8F34E343352;
        Mon, 23 Aug 2021 13:53:33 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-99-6.trex-nlb.outbound.svc.cluster.local [100.96.99.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 431D83432C8;
        Mon, 23 Aug 2021 13:53:32 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.99.6 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Bored-Lonely: 3143f5535fef036d_1629726813375_2145666347
X-MC-Loop-Signature: 1629726813374:233205373
X-MC-Ingress-Time: 1629726813374
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2ccO18sIS75CyOLZ3AKF2fwsL6zXvDVahwfT5UVAWGQ=; b=ixl/rBJs+WBClBz7HGdo/uNfCK
        HFTPSGcn/B19waP4Gep152QxQrxo8RqEmUonmmeQW9Ma8p4Uq0Qv6aCLAF2lAbPfK9TNfKQllVKKv
        ZD2j8koiao/LJtZAjLrdDodgXRVADAJa5z5jDAR771DVa2+m82rAqMfytU4V0/GUwD4F3PyPXbpNY
        ygWajGRgzuMsUBX1YChFst02CG7u0YQItzCA4ECCXslk9v1o4W+PJZBtj46VClX78IEoTGQSDmfX7
        YI2M1EL9Kue1vT8DgAEA2qFf7dh4A5suTGe/Qp2KRHypodcBrJ6P3S/JyE+fYbqkkioGtgT1AqljA
        tQ+JUxAg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOI-003PzY-Gd; Mon, 23 Aug 2021 14:53:30 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 02/10] lan78xx: Remove unused timer
Date:   Mon, 23 Aug 2021 14:52:21 +0100
Message-Id: <20210823135229.36581-3-john.efstathiades@pebblebay.com>
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

Remove kernel timer that is not used by the driver.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index ece044dd0236..2896d31e5573 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -393,7 +393,6 @@ struct lan78xx_net {
 	unsigned char		suspend_count;
 
 	unsigned int		maxpacket;
-	struct timer_list	delay;
 	struct timer_list	stat_monitor;
 
 	unsigned long		data[5];
@@ -3425,8 +3424,7 @@ static void lan78xx_bh(struct tasklet_struct *t)
 		if (!skb_queue_empty(&dev->txq_pend))
 			lan78xx_tx_bh(dev);
 
-		if (!timer_pending(&dev->delay) &&
-		    !test_bit(EVENT_RX_HALT, &dev->flags))
+		if (!test_bit(EVENT_RX_HALT, &dev->flags))
 			lan78xx_rx_bh(dev);
 	}
 }
-- 
2.25.1

