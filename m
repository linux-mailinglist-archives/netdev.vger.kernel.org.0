Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86834E14B6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390602AbfJWIur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390394AbfJWIuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 04:50:46 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00E22C03BC91
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:50:45 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id m68so3518683wme.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 01:50:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UGpHR3YNnSGEJZU7s+h4ckmTsa+OQ5I+i9CjqJw4MrQ=;
        b=i2AU3j7v0CjZxGw1s2sjurY+n0ZjmeGl44UT7vFsNSJxkgpauiw0z5HmuRZ8gnw3Sq
         2cjXdJvAug1G505qb0MSler/Xdflay+oHbKOjOTneGqPtYnYM2XuTo50USSZq/+nsAkN
         SVpBIxiIPpU1S4CEdkjs6sp/nRDN98a3qU/wC4rUOFGeTobjkpotSfxKuMhOhb9tqht3
         L9n12snOJx7g81R6kMVVizTrNZ26XCu6GMeF8E3GlcutibC5Y9TUjqp0OfZEw1gV62Mx
         2mrm/DA1OxMk/Yqz0uCEgIASbJ8lHJCtVzlip2dQv8ZAKB4UnzFI7h5LmCfdI+8YDLOH
         f2ig==
X-Gm-Message-State: APjAAAW19m8pdle1iw4XGhxSGhEtbovGxEJ+f0nM6/TJcjEqNV/LkpYv
        v2cqbr/1w1r3HtGZECV50StsA4aUB/2ziCob6bdH2KUJAF2Ux9YWTYbanG1/SgV0VBf0BmnchAW
        BNa9G3SfVfdkBb7bc
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr6623686wmf.63.1571820644303;
        Wed, 23 Oct 2019 01:50:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyZyTxr/+2CE4qo/T2isgKXb9jxn+6y7k2kj3f7Lz38SlDYDkPehIrxc7YMkW+CGlTnd0PJ/w==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr6623643wmf.63.1571820643899;
        Wed, 23 Oct 2019 01:50:43 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q6sm1206662wrx.30.2019.10.23.01.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 01:50:42 -0700 (PDT)
Date:   Wed, 23 Oct 2019 10:50:39 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
Message-ID: <20191023085039.GB2461@localhost.localdomain>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
 <9d581001e2e6cece418329842b2b0959@natalenko.name>
 <20191012165028.GA8739@lore-desk-wlan.lan>
 <f7695bc79d40bbc96744a639b1243027@natalenko.name>
 <96f43a2103a9f2be152c53f867f5805c@natalenko.name>
 <20191016163842.GA18799@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20191016163842.GA18799@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Hello.
> >=20
> > On 15.10.2019 18:52, Oleksandr Natalenko wrote:
> > > Thanks for the answer and the IRC discussion. As agreed I've applied
> > > [1] and [2], and have just swapped the card to try it again. So far,
> > > it works fine in 5 GHz band in 802.11ac mode as an AP.
> > >=20
> > > I'll give it more load with my phone over evening, and we can discuss
> > > what to do next (if needed) tomorrow again. Or feel free to drop me an
> > > email today.
> > >=20
> > > Thanks for your efforts.
> > >=20
> > > [1]
> > > https://github.com/LorenzoBianconi/wireless-drivers-next/commit/cf343=
6c42a297967235a9c9778620c585100529e.patch
> > > [2]
> > > https://github.com/LorenzoBianconi/wireless-drivers-next/commit/aad25=
6eb62620f9646d39c1aa69234f50c89eed8.patch
> >=20
> > As agreed, here are iperf3 results, AP to STA distance is 2 meters.
> >=20
> > Client sends, TCP:
> >=20
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  70.4 MBytes  59.0 Mbits/sec  3800
> > sender
> > [  5]   0.00-10.03  sec  70.0 MBytes  58.6 Mbits/sec
> > receiver
> >=20
> > Client receives, TCP:
> >=20
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.06  sec   196 MBytes   163 Mbits/sec  3081
> > sender
> > [  5]   0.00-10.01  sec   191 MBytes   160 Mbits/sec
> > receiver
> >=20
> > Client sends, UDP, 128 streams:
> >=20
> > [ ID] Interval           Transfer     Bitrate         Jitter    Lost/To=
tal
> > Datagrams
> > [SUM]   0.00-10.00  sec   160 MBytes   134 Mbits/sec  0.000 ms  0/115894
> > (0%)  sender
> > [SUM]   0.00-10.01  sec   160 MBytes   134 Mbits/sec  0.347 ms  0/115892
> > (0%)  receiver
> >=20
> > Client receives, UDP, 128 streams:
> >=20
> > [ ID] Interval           Transfer     Bitrate         Jitter    Lost/To=
tal
> > Datagrams
> > [SUM]   0.00-10.01  sec   119 MBytes  99.4 Mbits/sec  0.000 ms  0/85888=
 (0%)
> > sender
> > [SUM]   0.00-10.00  sec   119 MBytes  99.5 Mbits/sec  0.877 ms  0/85888=
 (0%)
> > receiver
> >=20
> > Given the HW is not the most powerful, the key point here is that nothi=
ng
> > crashed after doing these tests.
>=20
> Hi Oleksandr,
>=20
> thx a lot for testing these 2 patches. Now we need to understand why the =
chip
> hangs if we enable scatter gather dma transfer on x86 while it is working=
 fine
> on multiple mips/arm devices (patch 2/2 just disable it for debugging).

Hi Oleksandr,

I think I spotted the SG issue on mt76x2e. Could you please:
- keep pcie_aspm patch I sent
- remove the debug patch where I disabled TX Scatter-Gather on mt76x2e
- apply the following patch

Regards,
Lorenzo

mt76: dma: fix buffer unmap with non-linear skbs

mt76 dma layer is supposed to unmap skb data buffers while keep txwi mapped
on hw dma ring. At the moment mt76 wrongly unmap txwi or does not unmap data
fragments in even positions for non-linear skbs. This issue may result in hw
hangs with A-MSUD if the system relies on IOMMU or SWIOTLB.
Fix this behaviour marking first and last queue entries introducing
MT_QUEUE_ENTRY_FIRST and MT_QUEUE_ENTRY_LAST flags and properly unmap
data fragments

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipset=
s")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 33 +++++++++++++----------
 drivers/net/wireless/mediatek/mt76/mt76.h |  3 +++
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireles=
s/mediatek/mt76/dma.c
index 4da7cffbab29..a3026a0ca8c5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -54,7 +54,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue =
*q,
 	int i, idx =3D -1;
=20
 	if (txwi)
-		q->entry[q->head].txwi =3D DMA_DUMMY_DATA;
+		q->entry[q->head].flags =3D MT_QUEUE_ENTRY_FIRST;
=20
 	for (i =3D 0; i < nbufs; i +=3D 2, buf +=3D 2) {
 		u32 buf0 =3D buf[0].addr, buf1 =3D 0;
@@ -83,6 +83,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue =
*q,
 		q->queued++;
 	}
=20
+	q->entry[idx].flags |=3D MT_QUEUE_ENTRY_LAST;
 	q->entry[idx].txwi =3D txwi;
 	q->entry[idx].skb =3D skb;
=20
@@ -93,27 +94,31 @@ static void
 mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int id=
x,
 			struct mt76_queue_entry *prev_e)
 {
+	__le32 addr, __ctrl =3D READ_ONCE(q->desc[idx].ctrl);
 	struct mt76_queue_entry *e =3D &q->entry[idx];
-	__le32 __ctrl =3D READ_ONCE(q->desc[idx].ctrl);
-	u32 ctrl =3D le32_to_cpu(__ctrl);
-
-	if (!e->txwi || !e->skb) {
-		__le32 addr =3D READ_ONCE(q->desc[idx].buf0);
-		u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
+	u32 len, ctrl =3D le32_to_cpu(__ctrl);
=20
+	if (e->flags & MT_QUEUE_ENTRY_FIRST) {
+		addr =3D READ_ONCE(q->desc[idx].buf1);
+		len =3D FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
 		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
 				 DMA_TO_DEVICE);
-	}
-
-	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
-		__le32 addr =3D READ_ONCE(q->desc[idx].buf1);
-		u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
-
+	} else {
+		addr =3D READ_ONCE(q->desc[idx].buf0);
+		len =3D FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
 		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
 				 DMA_TO_DEVICE);
+		if (e->txwi &&
+		    ((ctrl & MT_DMA_CTL_LAST_SEC1) ||
+		     !(e->flags & MT_QUEUE_ENTRY_LAST))) {
+			addr =3D READ_ONCE(q->desc[idx].buf1);
+			len =3D FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
+			dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
+					 DMA_TO_DEVICE);
+		}
 	}
=20
-	if (e->txwi =3D=3D DMA_DUMMY_DATA)
+	if (!(e->flags & MT_QUEUE_ENTRY_LAST))
 		e->txwi =3D NULL;
=20
 	if (e->skb =3D=3D DMA_DUMMY_DATA)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wirele=
ss/mediatek/mt76/mt76.h
index e95a5893f93b..b0ac82b31789 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -83,6 +83,8 @@ struct mt76_tx_info {
 	u32 info;
 };
=20
+#define MT_QUEUE_ENTRY_FIRST	BIT(0)
+#define MT_QUEUE_ENTRY_LAST	BIT(1)
 struct mt76_queue_entry {
 	union {
 		void *buf;
@@ -95,6 +97,7 @@ struct mt76_queue_entry {
 	enum mt76_txq_id qid;
 	bool schedule;
 	bool done;
+	u32 flags;
 };
=20
 struct mt76_queue_regs {
--=20
2.21.0

>=20
> Regards,
> Lorenzo
>=20
> >=20
> > --=20
> >   Oleksandr Natalenko (post-factum)



--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbAUXAAKCRA6cBh0uS2t
rF/rAQCyhLupkRPLUnZ/u8RTazD0fai2XfAUiYa6BP9pmufiIQD+K53LBN+/QpAE
3JTEkMlFUtOM8jVQtF8L4kueXoshyg0=
=t1jf
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
