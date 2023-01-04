Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5265D6B8
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjADO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbjADO7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:59:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FD5395FA
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:59:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DE1561738
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DC3C43392;
        Wed,  4 Jan 2023 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672844360;
        bh=PYfgxKIyOdmg2Pg+Mwf2ks9O3ou/hyuug2TUGCnikwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=StDmeHA2okScKaQmnCiN4UsL83yALDCQ0Yqh2QhbrtK/j2QGMA3gXqxC6OZOU2k8t
         oahUEeilbZSxFeJ+bj5bQ6mrl+09eRfC20CYshhgXmZl5PthklS4ZrZAdCSgJ5JRTj
         uTlSS30EmwnWOjovS/0fQ7vQKKymzv38xuBCwQjN65JvB0PvmLqPEKbZ8Kwp8JA/yc
         XD8mV9gps8obXLwwaQoy0r02GmTEyIFbr1e83dQEoRdsCaWJkutQ/Intz+2BV6F7SU
         tMwJqGrhsZeLYCqPy1Raq6kGpMoOM4cw0WdMMzA3dNwZN22TeQ9AlJoDYs2pDwzhMf
         VhDSuxOTD8kBg==
Date:   Wed, 4 Jan 2023 15:59:17 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7WURTK70778grfD@lore-desk>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
 <Y7WKcdWap3SrLAp3@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eRi/TL1OJiTNb7sk"
Content-Disposition: inline
In-Reply-To: <Y7WKcdWap3SrLAp3@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eRi/TL1OJiTNb7sk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 04, 2023 at 03:03:14PM +0100, Lorenzo Bianconi wrote:
> > Introduce reset and reset_complete wlan callback to schedule WLAN driver
> > reset when ethernet/wed driver is resetting.
> >=20
> > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  6 ++++
> >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
> >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> >  4 files changed, 56 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index bafae4f0312e..2d74e26f45c9 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -3913,6 +3913,10 @@ static void mtk_pending_work(struct work_struct =
*work)
> >  		mtk_w32(eth, val, MTK_MAC_MCR(i));
> >  	}
> > =20
> > +	rtnl_unlock();
> > +	mtk_wed_fe_reset();
> > +	rtnl_lock();
>=20
> Is it safe to call rtnl_unlock(), perform some work and lock again?

Yes, mtk_pending_work sets MTK_RESETTING bit and a new reset work is not
scheduled until this bit is cleared

>=20
> > +
> >  	/* stop all devices to make sure that dma is properly shut down */
> >  	for (i =3D 0; i < MTK_MAC_COUNT; i++) {
> >  		if (!eth->netdev[i] || !netif_running(eth->netdev[i]))
> > @@ -3949,6 +3953,8 @@ static void mtk_pending_work(struct work_struct *=
work)
> > =20
> >  	clear_bit(MTK_RESETTING, &eth->state);
> > =20
> > +	mtk_wed_fe_reset_complete();
> > +
> >  	rtnl_unlock();
> >  }
> > =20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethe=
rnet/mediatek/mtk_wed.c
> > index a6271449617f..4854993f2941 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > @@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
> >  	iounmap(reg);
> >  }
> > =20
> > +void mtk_wed_fe_reset(void)
> > +{
> > +	int i;
> > +
> > +	mutex_lock(&hw_lock);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(hw_list); i++) {
> > +		struct mtk_wed_hw *hw =3D hw_list[i];
> > +		struct mtk_wed_device *dev =3D hw->wed_dev;
> > +
> > +		if (!dev || !dev->wlan.reset)
> > +			continue;
> > +
> > +		/* reset callback blocks until WLAN reset is completed */
> > +		if (dev->wlan.reset(dev))
> > +			dev_err(dev->dev, "wlan reset failed\n");
> > +	}
> > +
> > +	mutex_unlock(&hw_lock);
> > +}
> > +
> > +void mtk_wed_fe_reset_complete(void)
> > +{
> > +	int i;
> > +
> > +	mutex_lock(&hw_lock);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(hw_list); i++) {
> > +		struct mtk_wed_hw *hw =3D hw_list[i];
> > +		struct mtk_wed_device *dev =3D hw->wed_dev;
> > +
> > +		if (!dev || !dev->wlan.reset_complete)
> > +			continue;
> > +
> > +		dev->wlan.reset_complete(dev);
> > +	}
> > +
> > +	mutex_unlock(&hw_lock);
> > +}
> > +
> >  static struct mtk_wed_hw *
> >  mtk_wed_assign(struct mtk_wed_device *dev)
> >  {
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethe=
rnet/mediatek/mtk_wed.h
> > index e012b8a82133..6108a7e69a80 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed.h
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed.h
> > @@ -128,6 +128,8 @@ void mtk_wed_add_hw(struct device_node *np, struct =
mtk_eth *eth,
> >  void mtk_wed_exit(void);
> >  int mtk_wed_flow_add(int index);
> >  void mtk_wed_flow_remove(int index);
> > +void mtk_wed_fe_reset(void);
> > +void mtk_wed_fe_reset_complete(void);
> >  #else
> >  static inline void
> >  mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
> > @@ -146,6 +148,12 @@ static inline int mtk_wed_flow_add(int index)
> >  static inline void mtk_wed_flow_remove(int index)
> >  {
> >  }
> > +static inline void mtk_wed_fe_reset(void)
> > +{
> > +}
> > +static inline void mtk_wed_fe_reset_complete(void)
> > +{
> > +}
> > =20
> >  #endif
> > =20
> > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/m=
ediatek/mtk_wed.h
> > index db637a13888d..ddff54fc9717 100644
> > --- a/include/linux/soc/mediatek/mtk_wed.h
> > +++ b/include/linux/soc/mediatek/mtk_wed.h
> > @@ -150,6 +150,8 @@ struct mtk_wed_device {
> >  		void (*release_rx_buf)(struct mtk_wed_device *wed);
> >  		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
> >  					   struct mtk_wed_wo_rx_stats *stats);
> > +		int (*reset)(struct mtk_wed_device *wed);
> > +		int (*reset_complete)(struct mtk_wed_device *wed);
>=20
> I don't see any driver implementation of these callbacks in this series.
> Did I miss it?

These callbacks are implemented in the mt76 driver. I have not added these
patches to the series since mt76 patches usually go through Felix/Kalle's
trees (anyway I am fine to add them to the series if they can go into net-n=
ext
directly).

Regards,
Lorenzo

>=20
> Thanks
>=20
> >  	} wlan;
> >  #endif
> >  };
> > --=20
> > 2.39.0
> >=20

--eRi/TL1OJiTNb7sk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7WURAAKCRA6cBh0uS2t
rKH+AQDgmpv6wb9SGhCxmWBaNCERHvBQ5xOmOLJMPZ5t+TGTjgD9ELH8CKb7S0EJ
ppbRhGZODfWYMFUjETx0gxERMGQp/wY=
=uHmx
-----END PGP SIGNATURE-----

--eRi/TL1OJiTNb7sk--
