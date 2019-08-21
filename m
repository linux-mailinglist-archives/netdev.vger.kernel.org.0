Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21C79837A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbfHUSpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:45:44 -0400
Received: from mout.web.de ([217.72.192.78]:35403 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfHUSpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 14:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566413112;
        bh=Eokj4/dGveTY43m2jdkJoZSE3kMn9PBFEqOcaiphGUM=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=jutwR2eiz2109XM8V3rCnhid4vnGN6tiNemZlrlGaQk/3LXtp+LOtLX7xT22Ebc3Y
         NzCFOeTaWPAAQA07usj5LYV64t+60SbsUAbItdTqjUcueTbtloKVxZmvbv36sEE6MY
         d7lT1xuXvfoV+84WR7ne+Q2oAudlJ3alV34aPfxs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.9.44]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M9XUJ-1i6KcZ1cND-00D02j; Wed, 21
 Aug 2019 20:45:12 +0200
To:     netdev@vger.kernel.org, Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kangjie Lu <kjlu@umn.edu>, Karsten Keil <isdn@linux-pingi.de>,
        Thomas Gleixner <tglx@linutronix.de>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_mISDN=3a_Delete_unnecessary_checks_before_the?=
 =?UTF-8?B?IG1hY3JvIGNhbGwg4oCcZGV2X2tmcmVlX3NrYuKAnQ==?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <689e51d5-9a43-45a4-5d33-75a34eba928a@web.de>
Date:   Wed, 21 Aug 2019 20:45:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tfdwBbPeOWePy27r9PwGdU/kLMoC3bUX8xhhCbRIdhXGahPB0zo
 vMnMaiFtA63rO08Zph4PUaAyrRO3urn+8dt3+mZu4EzI96xTKRpCw5enexlJPCSijDNT9Zn
 Kl4yTeWAPlv9NguJr8qpehigosRFxIF1gOq0WIuV+kHWPtg5Dn7464KvSnTSgG/OlPhTMuZ
 5kRFQuITC5a4/kyLxmUDA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:v9JPFSz4oDU=:HaemPJ8cg82mByc7200lAV
 XBCAvpfhGT+OQj/P0SlBW9bA1o7J/rPfRecyVxXzHtJnxf1dI1DQWlgys2+gvUGx/XkLLEUSG
 BGco5sbANVUK1cvEET3rOnf4GqOOmdmVJGF2kcyjyznKvJtZvMzNTsyW7pRyVjFwkrTz8vdFS
 kyl4FuhyGRcGHLonJetTHuFkMk6wsezRf7fEirf0v2miR/+hlLuL1s+Htgkb0tAWGpmFb+mud
 2+uj2HAOIOd1h7/VUTpe4pCZ1wjjHTL2Ek8AMrfN/IW7oITuD7xixgAA8YuuVKhd0buCpp4E8
 ACEY8lSi+Pf9/QBEYZWAr7MjI9zAn5ZqwkTaQ0R57eJ4jaa5I4MlPTmp2JGZKcXL89FYgO05x
 Nlu0dZNeHdW21s8pIYS+/TanRCtrMNl8dr3vRYPrLFxQRKTGrA0S26Tp8nXuxISKnBwa4kY5P
 fwoR5THacvtjVL3r21RGzBpH+8UeCGWiYu8PFmxPmlAnDmd4kyKrI4g2h3j2KprMd+kDhdU2/
 sQz89wOsYgdAEmAtzY6RoX6u6eMPYXitqbW175UHUDrTSFKsEP6sqZePpZOX3T01NV2dkUV7S
 YznwprNG7XvpSydrUnbLU2VwIt7IYhB7LcJ2xzKZq4M+osYV+VteyblvXOW4Fe2ufIAm9+JtI
 QvZ3WUBNIkFPb1/UNTxAFB2/bI2gVnX8jOSzhwaBpE0d9dAcBl2AazVnJCsvi2vJvtjBL+mFE
 DAYRr3+yYNPTe9vhpsqS68MfJ3XlfmqbKzJPzImniDGlCuLLBVejqH/5/li37ybX/n9gJRm3h
 gM2074i2nPJemOK+rO3kGUlhiHAhLUJZde+pATQgHF5a+oXzN+lsvf4DOPNTEldFozs4FhHVT
 zMO4AgAtXtG4OFT1azxlYjswrqfahhSmlgiZAIDBJzaUDdlYXxrzsKs1ip2ndRSQFd7NKdpB0
 JuUvVXkeM5jak3VoRf5RraqWaSJbTliZu0UrfnTxfWkduyZo4zEAFa1svLAsJlVuOEQKS4VDY
 mH4L6dGFFeQDErZ7BU0h8OlSfQh8RaLTgnILwX8hFmB33RTTMQL6x+lQXEKGHiBEKv4gRZKsJ
 4qkohW4eW/uzxIyShRSDDP+UYLQrVdmgqHDTHMgpSE89RawVqcViIqFHKfoSflwYCc2010lyx
 /V0TQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 21 Aug 2019 20:10:56 +0200

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/isdn/hardware/mISDN/avmfritz.c  |  3 +--
 drivers/isdn/hardware/mISDN/hfcpci.c    |  6 ++----
 drivers/isdn/hardware/mISDN/mISDNipac.c | 12 ++++--------
 drivers/isdn/hardware/mISDN/mISDNisar.c |  3 +--
 drivers/isdn/hardware/mISDN/netjet.c    |  3 +--
 drivers/isdn/hardware/mISDN/w6692.c     |  9 +++------
 drivers/isdn/mISDN/l1oip_core.c         |  3 +--
 drivers/isdn/mISDN/layer2.c             |  9 +++------
 drivers/isdn/mISDN/stack.c              |  6 ++----
 drivers/isdn/mISDN/tei.c                |  6 ++----
 10 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/avmfritz.c b/drivers/isdn/hardwar=
e/mISDN/avmfritz.c
index 81f2b183acc8..1137dd152b5c 100644
=2D-- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -509,8 +509,7 @@ HDLC_irq_xpr(struct bchannel *bch)
 	if (bch->tx_skb && bch->tx_idx < bch->tx_skb->len) {
 		hdlc_fill_fifo(bch);
 	} else {
-		if (bch->tx_skb)
-			dev_kfree_skb(bch->tx_skb);
+		dev_kfree_skb(bch->tx_skb);
 		if (get_next_bframe(bch)) {
 			hdlc_fill_fifo(bch);
 			test_and_clear_bit(FLG_TX_EMPTY, &bch->Flags);
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/=
mISDN/hfcpci.c
index 4a069582fc6b..2330a7d24267 100644
=2D-- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1119,8 +1119,7 @@ tx_birq(struct bchannel *bch)
 	if (bch->tx_skb && bch->tx_idx < bch->tx_skb->len)
 		hfcpci_fill_fifo(bch);
 	else {
-		if (bch->tx_skb)
-			dev_kfree_skb(bch->tx_skb);
+		dev_kfree_skb(bch->tx_skb);
 		if (get_next_bframe(bch))
 			hfcpci_fill_fifo(bch);
 	}
@@ -1132,8 +1131,7 @@ tx_dirq(struct dchannel *dch)
 	if (dch->tx_skb && dch->tx_idx < dch->tx_skb->len)
 		hfcpci_fill_dfifo(dch->hw);
 	else {
-		if (dch->tx_skb)
-			dev_kfree_skb(dch->tx_skb);
+		dev_kfree_skb(dch->tx_skb);
 		if (get_next_dframe(dch))
 			hfcpci_fill_dfifo(dch->hw);
 	}
diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardwa=
re/mISDN/mISDNipac.c
index f915399d75ca..bca880213e91 100644
=2D-- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -190,8 +190,7 @@ isac_rme_irq(struct isac_hw *isac)
 #endif
 		}
 		WriteISAC(isac, ISAC_CMDR, 0x80);
-		if (isac->dch.rx_skb)
-			dev_kfree_skb(isac->dch.rx_skb);
+		dev_kfree_skb(isac->dch.rx_skb);
 		isac->dch.rx_skb =3D NULL;
 	} else {
 		count =3D ReadISAC(isac, ISAC_RBCL) & 0x1f;
@@ -210,8 +209,7 @@ isac_xpr_irq(struct isac_hw *isac)
 	if (isac->dch.tx_skb && isac->dch.tx_idx < isac->dch.tx_skb->len) {
 		isac_fill_fifo(isac);
 	} else {
-		if (isac->dch.tx_skb)
-			dev_kfree_skb(isac->dch.tx_skb);
+		dev_kfree_skb(isac->dch.tx_skb);
 		if (get_next_dframe(&isac->dch))
 			isac_fill_fifo(isac);
 	}
@@ -464,8 +462,7 @@ isacsx_rme_irq(struct isac_hw *isac)
 			isac->dch.err_crc++;
 #endif
 		WriteISAC(isac, ISACX_CMDRD, ISACX_CMDRD_RMC);
-		if (isac->dch.rx_skb)
-			dev_kfree_skb(isac->dch.rx_skb);
+		dev_kfree_skb(isac->dch.rx_skb);
 		isac->dch.rx_skb =3D NULL;
 	} else {
 		count =3D ReadISAC(isac, ISACX_RBCLD) & 0x1f;
@@ -1012,8 +1009,7 @@ hscx_xpr(struct hscx_hw *hx)
 	if (hx->bch.tx_skb && hx->bch.tx_idx < hx->bch.tx_skb->len) {
 		hscx_fill_fifo(hx);
 	} else {
-		if (hx->bch.tx_skb)
-			dev_kfree_skb(hx->bch.tx_skb);
+		dev_kfree_skb(hx->bch.tx_skb);
 		if (get_next_bframe(&hx->bch)) {
 			hscx_fill_fifo(hx);
 			test_and_clear_bit(FLG_TX_EMPTY, &hx->bch.Flags);
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardwa=
re/mISDN/mISDNisar.c
index fd5c52f37802..4a3e748a1c26 100644
=2D-- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -690,8 +690,7 @@ send_next(struct isar_ch *ch)
 			}
 		}
 	}
-	if (ch->bch.tx_skb)
-		dev_kfree_skb(ch->bch.tx_skb);
+	dev_kfree_skb(ch->bch.tx_skb);
 	if (get_next_bframe(&ch->bch)) {
 		isar_fill_fifo(ch);
 		test_and_clear_bit(FLG_TX_EMPTY, &ch->bch.Flags);
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/=
mISDN/netjet.c
index 4e30affd1a7c..61caa7e50b9a 100644
=2D-- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -605,8 +605,7 @@ bc_next_frame(struct tiger_ch *bc)
 	if (bc->bch.tx_skb && bc->bch.tx_idx < bc->bch.tx_skb->len) {
 		fill_dma(bc);
 	} else {
-		if (bc->bch.tx_skb)
-			dev_kfree_skb(bc->bch.tx_skb);
+		dev_kfree_skb(bc->bch.tx_skb);
 		if (get_next_bframe(&bc->bch)) {
 			fill_dma(bc);
 			test_and_clear_bit(FLG_TX_EMPTY, &bc->bch.Flags);
diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/m=
ISDN/w6692.c
index 2402608dc98d..bad55fdacd36 100644
=2D-- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -356,8 +356,7 @@ handle_rxD(struct w6692_hw *card) {
 			card->dch.err_rx++;
 #endif
 		}
-		if (card->dch.rx_skb)
-			dev_kfree_skb(card->dch.rx_skb);
+		dev_kfree_skb(card->dch.rx_skb);
 		card->dch.rx_skb =3D NULL;
 		WriteW6692(card, W_D_CMDR, W_D_CMDR_RACK | W_D_CMDR_RRST);
 	} else {
@@ -376,8 +375,7 @@ handle_txD(struct w6692_hw *card) {
 	if (card->dch.tx_skb && card->dch.tx_idx < card->dch.tx_skb->len) {
 		W6692_fill_Dfifo(card);
 	} else {
-		if (card->dch.tx_skb)
-			dev_kfree_skb(card->dch.tx_skb);
+		dev_kfree_skb(card->dch.tx_skb);
 		if (get_next_dframe(&card->dch))
 			W6692_fill_Dfifo(card);
 	}
@@ -636,8 +634,7 @@ send_next(struct w6692_ch *wch)
 	if (wch->bch.tx_skb && wch->bch.tx_idx < wch->bch.tx_skb->len) {
 		W6692_fill_Bfifo(wch);
 	} else {
-		if (wch->bch.tx_skb)
-			dev_kfree_skb(wch->bch.tx_skb);
+		dev_kfree_skb(wch->bch.tx_skb);
 		if (get_next_bframe(&wch->bch)) {
 			W6692_fill_Bfifo(wch);
 			test_and_clear_bit(FLG_TX_EMPTY, &wch->bch.Flags);
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_co=
re.c
index 447f241467bd..b57dcb834594 100644
=2D-- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1254,8 +1254,7 @@ release_card(struct l1oip *hc)
 			mISDN_freebchannel(hc->chan[ch].bch);
 			kfree(hc->chan[ch].bch);
 #ifdef REORDER_DEBUG
-			if (hc->chan[ch].disorder_skb)
-				dev_kfree_skb(hc->chan[ch].disorder_skb);
+			dev_kfree_skb(hc->chan[ch].disorder_skb);
 #endif
 		}
 	}
diff --git a/drivers/isdn/mISDN/layer2.c b/drivers/isdn/mISDN/layer2.c
index 68a481516729..5bf7fcb282c4 100644
=2D-- a/drivers/isdn/mISDN/layer2.c
+++ b/drivers/isdn/mISDN/layer2.c
@@ -900,8 +900,7 @@ l2_disconnect(struct FsmInst *fi, int event, void *arg=
)
 	send_uframe(l2, NULL, DISC | 0x10, CMD);
 	mISDN_FsmDelTimer(&l2->t203, 1);
 	restart_t200(l2, 2);
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 }

 static void
@@ -1722,8 +1721,7 @@ l2_set_own_busy(struct FsmInst *fi, int event, void =
*arg)
 		enquiry_cr(l2, RNR, RSP, 0);
 		test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
 	}
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 }

 static void
@@ -1736,8 +1734,7 @@ l2_clear_own_busy(struct FsmInst *fi, int event, voi=
d *arg)
 		enquiry_cr(l2, RR, RSP, 0);
 		test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
 	}
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 }

 static void
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index fa2237e7bcf8..27aa32914425 100644
=2D-- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -75,8 +75,7 @@ send_socklist(struct mISDN_sock_list *sl, struct sk_buff=
 *skb)
 			cskb =3D NULL;
 	}
 	read_unlock(&sl->lock);
-	if (cskb)
-		dev_kfree_skb(cskb);
+	dev_kfree_skb(cskb);
 }

 static void
@@ -134,8 +133,7 @@ send_layer2(struct mISDNstack *st, struct sk_buff *skb=
)
 	}
 out:
 	mutex_unlock(&st->lmutex);
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 }

 static inline int
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index a4fa594e1caf..59d28cb19738 100644
=2D-- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -1328,10 +1328,8 @@ mgr_bcast(struct mISDNchannel *ch, struct sk_buff *=
skb)
 	}
 out:
 	read_unlock_irqrestore(&mgr->lock, flags);
-	if (cskb)
-		dev_kfree_skb(cskb);
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(cskb);
+	dev_kfree_skb(skb);
 	return 0;
 }

=2D-
2.23.0

