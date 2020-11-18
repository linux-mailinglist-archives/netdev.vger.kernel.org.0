Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567D32B8259
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgKRQv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:51:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:37347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgKRQv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605718306;
        bh=er5T1TaopyHwQjYumtcOzRR5jgOSxSy7MPppmgo5t+4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dr94ghwWCKEgFMwYdPetBUh6+VLDjLphvJ/Q6UWsaU9albqjcjZbxsD7kPDPKjq5s
         oGQkpbX8jGBX9DXDfyeGfFpo0Pd3UKGCYlmsZOAQA1o9hesQIj5SL6T9Zh90SbfChQ
         atKYILUom+j8U0cJwy8uu6KWeGAmRsseaBbWNtAM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel.fritz.box ([79.242.191.181]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mof5H-1jv7VL2N5t-00p8qU; Wed, 18 Nov 2020 17:51:46 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        joe@perches.com
Subject: [PATCH net-next v2 2/2] lib8390: Cleanup variables
Date:   Wed, 18 Nov 2020 17:51:07 +0100
Message-Id: <20201118165107.12419-3-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118165107.12419-1-W_Armin@gmx.de>
References: <20201118165107.12419-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wMCtpzEJDJTu45T0paQDAUfIOZC8SIplxIiYqFTwCznJDkEbCEi
 vuj7jeBLqNGvtVmMywgZK4AHeJSBVDpEfGN6GbrVSdE+C4IcR3ok6qMSpeGQoLq4jDReHnI
 Wf0ce2FK7lI1zOeYcnLhakeFFkIlkRU2OgD1dxhfSJCe4FF9FAzkg0fq1ldp+ooeNfFndHH
 hcP3i9RGLUfZ7yTXpsmrA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6erplLVqo6o=:3mUpbl8DtIgwknKVO6dI+i
 /f6D2x0g+mwcDntHa5EvOUL1MLwEwlct39bq5Wh6nUhQ/+mIIfrB4WZ/eXHvF2RFCMjPG1c7J
 iRDpOFs7m+yjoMSe6DfzlV0KGP6rC/TpSdDkmBZUmwimEliNnx1FnbFxHW9E7Kxl3SYNJ2I4P
 Yjg2zLyNYVptZYYumKG4jBv1QJNJ4mAvRiT5XlQPDF8p/R/FX5N12/Run6VDij9lsHtpciq1+
 fvEMm54rtLHrrBH+MCKNhSnYoKbnpxOlV8Wz1OXzCiHtJHCK6WauzY0Q1WpZ9H7ARk+EVBwKt
 65YZtwuR6BMlVugxvtMjylwNmYWqQ9O2lfRWA8+OY2f2hBqC7I4wIoYs9F6WyYXCyy7nwsSLE
 lWGutuGhCZFoQ3NUIlhxbRzdnRdeYp7wjIA+ucGxenu8M1nVjbNWbqc1kjJScDhURpge/yWJB
 8BA3y4jTMcPNF/Gkt6e372PLIkDUnzKQ/NNywwt/UQ1RTpdt3wxq9p0qSYgCvbCxvfQ4A9vHL
 RWE11OeFzzKvNfqfL8B/LXs1VFDyexBA/72NGRetu32JrE0NZ3T2uQpJTawHpU1UkpBvROrZB
 RamNp+6skTz7/lsxXyWL2862GIF0P9ldRAAImBUEPBKtKoFbszsxoIAsyrQip/xtaUzSMj376
 xDk4DCZmL/qbj1UzEnF8rzLk3vGFKS/z8GxxigXfBUrWhHt2NZsrdISNIDk9m7cw6Md1DlyHr
 aWgCz3pJwziNyEJ5VvKzPVn8Yki8Cg0fwHzQ69PEhDOMaPR7XvvOJmJnATOKK9XRkM3NUo2ef
 dNY/U/1KRZvZhm5LrE0dJJOE+HvNC7zxWuQN3/2E4DCW66aDqpJ4+x/QJKbER+aVMTtppcZ5W
 YsLt1+vddbG0jSZcVpdg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace variables associated with the former padding
solution with skb->* expressions. They are not needed
anymore.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index b3499714f7e0..47e2962eff56 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -305,17 +305,14 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	struct ei_device *ei_local =3D netdev_priv(dev);
-	int send_length, output_page;
+	int output_page;
 	unsigned long flags;
-	char *data;

 	/* The Hardware does not pad undersized frames */
 	if (eth_skb_pad(skb)) {
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
 	}
-	data =3D skb->data;
-	send_length =3D skb->len;

 	/* Mask interrupts from the ethercard.
 	   SMP: We have to grab the lock here otherwise the IRQ handler
@@ -347,7 +344,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,

 	if (ei_local->tx1 =3D=3D 0) {
 		output_page =3D ei_local->tx_start_page;
-		ei_local->tx1 =3D send_length;
+		ei_local->tx1 =3D skb->len;
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx2 > 0)
 			netdev_dbg(dev,
@@ -355,7 +352,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 				   ei_local->tx2, ei_local->lasttx, ei_local->txing);
 	} else if (ei_local->tx2 =3D=3D 0) {
 		output_page =3D ei_local->tx_start_page + TX_PAGES/2;
-		ei_local->tx2 =3D send_length;
+		ei_local->tx2 =3D skb->len;
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx1 > 0)
 			netdev_dbg(dev,
@@ -380,11 +377,11 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 	 * trigger the send later, upon receiving a Tx done interrupt.
 	 */

-	ei_block_output(dev, send_length, data, output_page);
+	ei_block_output(dev, skb->len, skb->data, output_page);

 	if (!ei_local->txing) {
 		ei_local->txing =3D 1;
-		NS8390_trigger_send(dev, send_length, output_page);
+		NS8390_trigger_send(dev, skb->len, output_page);
 		if (output_page =3D=3D ei_local->tx_start_page) {
 			ei_local->tx1 =3D -1;
 			ei_local->lasttx =3D -1;
@@ -407,8 +404,8 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 	spin_unlock(&ei_local->page_lock);
 	enable_irq_lockdep_irqrestore(dev->irq, &flags);
 	skb_tx_timestamp(skb);
+	dev->stats.tx_bytes +=3D skb->len;
 	dev_consume_skb_any(skb);
-	dev->stats.tx_bytes +=3D send_length;

 	return NETDEV_TX_OK;
 }
=2D-
2.20.1

