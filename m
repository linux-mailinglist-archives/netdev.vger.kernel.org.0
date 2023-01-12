Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B970F667ACA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjALQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjALQ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A7212767
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:26:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 941DB62081
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 16:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BCCC433D2;
        Thu, 12 Jan 2023 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673540787;
        bh=bumzwwWkiGIZZ32CUCHmgcXJ8wzJz2sUupvENjzUiAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G53b1Fnt2Hf7MTnGeXsA9foG4W+6pg6C2/LeKRsZD7NjQu5p5jWLi47UALryk123J
         X6NNsrzo1zPNtVCV4zy2CjBJPW2mabbVkVvdmMkKw2pFi0tt0ItgPZKo9w4yLYLRPx
         0HQqpMh5fI10/aLrJo41p5VyMvi7fc2IpAwOlAPxK/JFLfQJCnIvck/1vBRz4jaP7Y
         Qd98znUPTg3jQ6kXTZSsu6YchcU5G/cEKlqfll5+2IBDG+dmI7aydxvJFLFCM3MHMk
         njUsUTSuQFnT7V0V75z0PkMXrRDbEmub0MIPBQbtMRqOR6TnIWWOJIJnI0hqanWfFM
         BdcScCxbMMocw==
Date:   Thu, 12 Jan 2023 17:26:23 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org, leon@kernel.org
Subject: Re: [PATCH v5 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y8A0r6IA+l5RzDXq@lore-desk>
References: <cover.1673457624.git.lorenzo@kernel.org>
 <0a22f0c81e87fde34e3444e1bc83012a17498e8e.1673457624.git.lorenzo@kernel.org>
 <02cfb1dd78f6efb1ae3077de24fa357091168d39.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ru9AOcqN83N8L+Y4"
Content-Disposition: inline
In-Reply-To: <02cfb1dd78f6efb1ae3077de24fa357091168d39.camel@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ru9AOcqN83N8L+Y4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 2023-01-11 at 18:22 +0100, Lorenzo Bianconi wrote:
> > Introduce reset and reset_complete wlan callback to schedule WLAN driver
> > reset when ethernet/wed driver is resetting.
> >=20
> > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
> >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
> >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> >  4 files changed, 57 insertions(+)
> >=20
>=20
> Do we have any updates on the implementation that would be making use
> of this? It looks like there was a discussion for the v2 of this set to
> include a link to an RFC posting that would make use of this set.

I posted the series to linux-wireless mailing list adding netdev one in cc:
https://lore.kernel.org/linux-wireless/cover.1673103214.git.lorenzo@kernel.=
org/T/#md34b4ffcb07056794378fa4e8079458ecca69109

>=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index 1af74e9a6cd3..0147e98009c2 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -3924,6 +3924,11 @@ static void mtk_pending_work(struct work_struct =
*work)
> >  	set_bit(MTK_RESETTING, &eth->state);
> > =20
> >  	mtk_prepare_for_reset(eth);
> > +	mtk_wed_fe_reset();
> > +	/* Run again reset preliminary configuration in order to avoid any
> > +	 * possible race during FE reset since it can run releasing RTNL lock.
> > +	 */
> > +	mtk_prepare_for_reset(eth);
> > =20
> >  	/* stop all devices to make sure that dma is properly shut down */
> >  	for (i =3D 0; i < MTK_MAC_COUNT; i++) {
> > @@ -3961,6 +3966,8 @@ static void mtk_pending_work(struct work_struct *=
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
>=20
> The reason why having the consumer would be useful are cases like this.
> My main concern is if the error value might be useful to actually
> expose rather than just treating it as a boolean. Usually for things
> like this I prefer to see the result captured and if it indicates error
> we return the error value since this could be one of several possible
> causes for the error assuming this returns an int and not a bool.

we can have 2 independent wireless chips connected here so, if the first one
fails, should we exit or just log the error?

Regards,
Lorenzo

>=20
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
>=20

--ru9AOcqN83N8L+Y4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8A0rwAKCRA6cBh0uS2t
rI8QAQC8nbHZJHzfiQ0aEIyo/XCX09rm6FvsQjMBQFZr22VZ/QD8Crk2/zKClaMd
3r1ieMzgD+NMtqPYP48roldLcp8iFAs=
=hPex
-----END PGP SIGNATURE-----

--ru9AOcqN83N8L+Y4--
