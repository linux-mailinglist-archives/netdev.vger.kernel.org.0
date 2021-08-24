Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D223F6952
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhHXS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:10 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:9901 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231831AbhHXS6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:07 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6DD4F321E50;
        Tue, 24 Aug 2021 18:57:22 +0000 (UTC)
Received: from ares.krystal.co.uk (100-105-161-188.trex.outbound.svc.cluster.local [100.105.161.188])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 40720321FD7;
        Tue, 24 Aug 2021 18:57:20 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.105.161.188 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:22 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-White-Chemical: 3d4e85f72b6dbf46_1629831442101_4219606807
X-MC-Loop-Signature: 1629831442101:3261993375
X-MC-Ingress-Time: 1629831442100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2ccO18sIS75CyOLZ3AKF2fwsL6zXvDVahwfT5UVAWGQ=; b=C0iFSJzgHlu6isy4ZVUxqahz/u
        rbfrKoQq9Cnfx5iwIUNIs9DOZ5x4Elo2QiWO8k3GVpkCDjdVdONQ9FWDcUPlFrrcLBkTCzKzIObZw
        dIsZuJP1Idg9gV9DgC/p17TF0ndxLpTpqBr54fpklESlzz0/iFZUygdib3DvmxT2UonUwU5AE0E7k
        m29bjatBM0RowQ+HSjGyR3gI4moIQCU96FXJS/wbi8zAdjU3jpP+cYFtci5V+v3W7vo/VurtNDO1Y
        BJu+8mQcVu+kAbKhQKL2PXRVbMVZ/SZWOY+AgPr0A9DaoqUKQ2OAclkd1QNJK0/8xc1bdX/1yf+NQ
        G06oR8WA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbr-00BQSi-5l; Tue, 24 Aug 2021 19:57:18 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 02/10] lan78xx: Remove unused timer
Date:   Tue, 24 Aug 2021 19:56:05 +0100
Message-Id: <20210824185613.49545-3-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
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

