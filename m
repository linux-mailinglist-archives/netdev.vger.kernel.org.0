Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E3D64251E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLEIzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiLEIyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:54:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D017AB7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:53:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D438160FC9
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3025C433C1;
        Mon,  5 Dec 2022 08:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670230425;
        bh=EtznwRvz8UAVCivyEU6T4HPAoLqq4iqUbalneMZd28Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVG8mNVN57hNhEvOemnJDw9QOP2UzWlVtTcjshOnJZK6EVWucGx+KxmbYmwvlWUba
         Yw6aPufPqSiPcYaP11pjzNrj8YSHYo61uLAJA+rMafY6k3MZWSoEh85q1Kj1mdm96r
         JOqSGWBI+HrMWlz6A07gedvvhU82q+lGfIrSQvhiKQOHUdX10CrW3qnIqUNerKb04E
         Rso/WeLthh256th+pX81knwxVSAfEA5LTJZ8SqPRGsB9CBAp9u7AovDMX2DqmXqT5j
         yAhilmAWCqbyFrAOz3JGQQFdqoCJ8R1sgnNXcXub0m/GuIYsBEoCaW0Oz+1itx2zgr
         ePgq237xRPGww==
Date:   Mon, 5 Dec 2022 09:53:41 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: add reset to
 rx_ring_setup callback
Message-ID: <Y42xlcjeuys4pW4j@lore-desk>
References: <26fa16f2f212bff5edfdbe8a4f41dba7a132b0be.1670072570.git.lorenzo@kernel.org>
 <Y42Yz2hhwk1Rw1hz@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TjqV5YrEl6MEkvGb"
Content-Disposition: inline
In-Reply-To: <Y42Yz2hhwk1Rw1hz@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TjqV5YrEl6MEkvGb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, Dec 03, 2022 at 02:06:30PM +0100, Lorenzo Bianconi wrote:
> > Introduce reset parameter to mtk_wed_rx_ring_setup signature.
> > This is a preliminary patch to add Wireless Ethernet Dispatcher reset
> > support.
>=20
> So please submit it as part the relevant series.

I have not included this patch in my previous reset series since mt76 bit
were missing (merged now in net-next). I posted this now as standalone patch
to be aligned with mtk_wed_tx_ring_setup counterpart that is already merged
into net-next.

@Dave,Eric,Jakub,Paolo: I am fine both ways, what do you prefer?

Regards,
Lorenzo

>=20
> Thanks
>=20
> >=20
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_wed.c  | 20 +++++++++++++-------
> >  drivers/net/wireless/mediatek/mt76/dma.c |  2 +-
> >  include/linux/soc/mediatek/mtk_wed.h     |  8 ++++----
> >  3 files changed, 18 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethe=
rnet/mediatek/mtk_wed.c
> > index 6352abd4157e..b1ec3f353b66 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > @@ -1216,7 +1216,8 @@ mtk_wed_wdma_rx_ring_setup(struct mtk_wed_device =
*dev, int idx, int size,
> >  }
> > =20
> >  static int
> > -mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int si=
ze)
> > +mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int si=
ze,
> > +			   bool reset)
> >  {
> >  	u32 desc_size =3D sizeof(struct mtk_wdma_desc) * dev->hw->version;
> >  	struct mtk_wed_ring *wdma;
> > @@ -1225,8 +1226,8 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device =
*dev, int idx, int size)
> >  		return -EINVAL;
> > =20
> >  	wdma =3D &dev->tx_wdma[idx];
> > -	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size,
> > -			       true))
> > +	if (!reset && mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE,
> > +					 desc_size, true))
> >  		return -ENOMEM;
> > =20
> >  	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_BASE,
> > @@ -1236,6 +1237,9 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device =
*dev, int idx, int size)
> >  	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
> >  	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
> > =20
> > +	if (reset)
> > +		mtk_wed_ring_reset(wdma, MTK_WED_WDMA_RING_SIZE, true);
> > +
> >  	if (!idx)  {
> >  		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_BASE,
> >  			wdma->desc_phys);
> > @@ -1577,18 +1581,20 @@ mtk_wed_txfree_ring_setup(struct mtk_wed_device=
 *dev, void __iomem *regs)
> >  }
> > =20
> >  static int
> > -mtk_wed_rx_ring_setup(struct mtk_wed_device *dev, int idx, void __iome=
m *regs)
> > +mtk_wed_rx_ring_setup(struct mtk_wed_device *dev, int idx, void __iome=
m *regs,
> > +		      bool reset)
> >  {
> >  	struct mtk_wed_ring *ring =3D &dev->rx_ring[idx];
> > =20
> >  	if (WARN_ON(idx >=3D ARRAY_SIZE(dev->rx_ring)))
> >  		return -EINVAL;
> > =20
> > -	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_RX_RING_SIZE,
> > -			       sizeof(*ring->desc), false))
> > +	if (!reset && mtk_wed_ring_alloc(dev, ring, MTK_WED_RX_RING_SIZE,
> > +					 sizeof(*ring->desc), false))
> >  		return -ENOMEM;
> > =20
> > -	if (mtk_wed_wdma_tx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
> > +	if (mtk_wed_wdma_tx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE,
> > +				       reset))
> >  		return -ENOMEM;
> > =20
> >  	ring->reg_base =3D MTK_WED_RING_RX_DATA(idx);
> > diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wir=
eless/mediatek/mt76/dma.c
> > index 3f8c0845fcca..f795548562f5 100644
> > --- a/drivers/net/wireless/mediatek/mt76/dma.c
> > +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> > @@ -648,7 +648,7 @@ mt76_dma_wed_setup(struct mt76_dev *dev, struct mt7=
6_queue *q)
> >  			q->wed_regs =3D wed->txfree_ring.reg_base;
> >  		break;
> >  	case MT76_WED_Q_RX:
> > -		ret =3D mtk_wed_device_rx_ring_setup(wed, ring, q->regs);
> > +		ret =3D mtk_wed_device_rx_ring_setup(wed, ring, q->regs, false);
> >  		if (!ret)
> >  			q->wed_regs =3D wed->rx_ring[ring].reg_base;
> >  		break;
> > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/m=
ediatek/mtk_wed.h
> > index beb190449704..a0746d4aec20 100644
> > --- a/include/linux/soc/mediatek/mtk_wed.h
> > +++ b/include/linux/soc/mediatek/mtk_wed.h
> > @@ -160,7 +160,7 @@ struct mtk_wed_ops {
> >  	int (*tx_ring_setup)(struct mtk_wed_device *dev, int ring,
> >  			     void __iomem *regs, bool reset);
> >  	int (*rx_ring_setup)(struct mtk_wed_device *dev, int ring,
> > -			     void __iomem *regs);
> > +			     void __iomem *regs, bool reset);
> >  	int (*txfree_ring_setup)(struct mtk_wed_device *dev,
> >  				 void __iomem *regs);
> >  	int (*msg_update)(struct mtk_wed_device *dev, int cmd_id,
> > @@ -228,8 +228,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
> >  	(_dev)->ops->irq_get(_dev, _mask)
> >  #define mtk_wed_device_irq_set_mask(_dev, _mask) \
> >  	(_dev)->ops->irq_set_mask(_dev, _mask)
> > -#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) \
> > -	(_dev)->ops->rx_ring_setup(_dev, _ring, _regs)
> > +#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs, _reset) \
> > +	(_dev)->ops->rx_ring_setup(_dev, _ring, _regs, _reset)
> >  #define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash) \
> >  	(_dev)->ops->ppe_check(_dev, _skb, _reason, _hash)
> >  #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) \
> > @@ -249,7 +249,7 @@ static inline bool mtk_wed_device_active(struct mtk=
_wed_device *dev)
> >  #define mtk_wed_device_reg_write(_dev, _reg, _val) do {} while (0)
> >  #define mtk_wed_device_irq_get(_dev, _mask) 0
> >  #define mtk_wed_device_irq_set_mask(_dev, _mask) do {} while (0)
> > -#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) -ENODEV
> > +#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs, _reset) -ENOD=
EV
> >  #define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash)  do {} wh=
ile (0)
> >  #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) -ENODEV
> >  #define mtk_wed_device_stop(_dev) do {} while (0)
> > --=20
> > 2.38.1
> >=20

--TjqV5YrEl6MEkvGb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY42xlQAKCRA6cBh0uS2t
rJgaAP9kv0/+JLbR9QEjj6HsjdO9Ql7QebZmOjn76zWLGfV7CQEAj0ZMPnM6Pe3M
8zuPR3Foi4dBlkB9An95CkysZlcIoAM=
=UYmD
-----END PGP SIGNATURE-----

--TjqV5YrEl6MEkvGb--
