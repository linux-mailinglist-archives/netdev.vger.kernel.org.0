Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E12B0A00
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgKLQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:31:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:37865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgKLQbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605198706;
        bh=tTRFqY7+LfhKP3w7MJWeNZ1z1Nx1CUlsR439Vn2FIHM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=RyO7xZfJxKdU6uK2sRM68qVy4C1M5x5y3w3+qL6ogJayC/OnedvifA+5Mc8zUnTRT
         iSXA+OShbDMjC9+8klKR/x7vAbmgEyFRL/fFjf//8OD3UgAabRsM35cDewBENyRUep
         GtYmWyHCn1CNhCmWYilghJ3AR6BTam25ffqrX/xs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel.fritz.box ([84.154.210.152]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MOiHf-1kwBGn2WOV-00Q9nH; Thu, 12 Nov 2020 17:31:46 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, joe@perches.com
Subject: [PATCH net-next] lib8390: Use eth_skb_pad()
Date:   Thu, 12 Nov 2020 17:31:34 +0100
Message-Id: <20201112163134.11880-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:A7FK7xbk0I/G5VH3du8Br2Ym012Pa7q8RwWGOHZbYBXF8mebnZx
 A4bhFo+iqgc6gOyc1OM2us6/WtXtuzBXnfd7ciprk+eozUS+mhZrDOc8GoyRceDbsX7MCKd
 V7RKVY0A1Vy+MR2f9++034jgOa4w1aqg79bsbMJuK78sMJBYaBbL/Vj6t6yicuDqMAxbtp3
 curunvjP7Zt8rNFRAaAZQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HQaWdbL9RsM=:qUYcByqKQJt4F9T103HiJd
 +oFY8MWJ+HG2Wx/yxcd8zmt+vOqL3THVMW1IGiCzVca2JTKgxJOuWeI59o0paOMZgK4/jhNL+
 AdJXZ+CnbadNJ9QEkaqSYLH32QYSlFxVaB22bMPbHZyyO5grvLrckcLPJMVS69hdFBD+pvClR
 tHroBrcmL+QtGnHd/G7VGOuYjpm4tNivHK9GzWSS3oqgkcJXZXMqQ7PUw+TSzlXQKJo+y5Hz+
 653LtcuYh2HpkMA85miBhwKnCLsfuCiuFEzyyQtFoezobE07DHUP3Ki7z/yaU7nWaACAZpffJ
 Vz1m1qvxkN4+UxGnKB25lRlq9uVhhu/7u5gcv+N+CqzAMZGIv03AI9EYXN6qvxTiIsTcIE/pe
 41UnVdF1CBRUdTYNS0GHY3ViqbtXu0ZfbidpcY9ktwW7SHedeRUfEjzpYo4rblCF5mfSLfyae
 I/EtVfLOfgGwdwHJFrLJFUKCDJBDLVmrL3FND7V3UR+KG3GomW8VTvyLzx4JMZ9l2275zmezE
 QpmvUHGuM9z/VEM0yjyzHw1gFrc61AqLEwj8Gq7vXyt6NXiHrhbGerRVRWmw6JMnRI/4pAnTH
 DVWUqmGLnPpVuJbOX7Sxs4pwO537tnzb8GjIu9MrNO0H7xq2y6BsHeTch3rva41viTICfLL6i
 NLT7kVeaanf1Si+PNE17Rk9cGdI3qdokjbOCwTrlgzCkNRtnRDs9KR2figMWk1AKgdW6rs9UT
 c7Nm9bBqjfT9ANzZF3MS5nbxvwkKBQbv0YXgPn9H8GTh+zgkWW/SqYb+6198TfdDm+TDrYApu
 DT8H9Ach53W1nSPjhKgkwBbqPwABYkgoAcm6xlC5w4syAU3j1f1q25xWYsIlMQCoPiEIL1Hz4
 tRMFYOhrhv0wlUJ5qPNw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use eth_skb_pad() instead of a custom padding solution
and replace associated variables with skb->* expressions.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index e84021282edf..47e2962eff56 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -305,16 +305,13 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	struct ei_device *ei_local =3D netdev_priv(dev);
-	int send_length =3D skb->len, output_page;
+	int output_page;
 	unsigned long flags;
-	char buf[ETH_ZLEN];
-	char *data =3D skb->data;
-
-	if (skb->len < ETH_ZLEN) {
-		memset(buf, 0, ETH_ZLEN);	/* more efficient than doing just the needed =
bits */
-		memcpy(buf, data, skb->len);
-		send_length =3D ETH_ZLEN;
-		data =3D buf;
+
+	/* The Hardware does not pad undersized frames */
+	if (eth_skb_pad(skb)) {
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
 	}

 	/* Mask interrupts from the ethercard.
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

