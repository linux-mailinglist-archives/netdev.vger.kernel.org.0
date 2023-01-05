Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5565EA33
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjAELuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbjAELt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:49:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE21458339
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 03:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68BEC619E0
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B454C433D2;
        Thu,  5 Jan 2023 11:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672919393;
        bh=q5ojDJ4ysX7ZcEtZj4OuJphv5Zn+NkLD0zc/vMrUbs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d5H7gy458fviZnQTi2U9kgQxvHj+RftdOe2HduCA6HXnOAUwW69pTJ137/8zh3eVn
         m/DBv4MIYkGaPaSjllwhv/U4jETNI7Se/GBOAmwUGDDaHCePNFeCpwWNwgFsNRTBFm
         vNak+XT33k7zWb1e/ZCjWa8gThIukyOdhGD3Gb5P1+NKyg9lAefnaonU4oSGN1fVkL
         n+2myAH/N7C7BGIVwv6aWvgntaTfFb2+H4+YU+hyGY4mvmwlSrnaUTmlMtTmRfuLOQ
         zBmQPGJnNrne2QZnDzH1HBqhBcjzdeznt7tKZ6XEj6aQZA1lEER198SpcAC2vPyLZe
         LN37QasyGF6IA==
Date:   Thu, 5 Jan 2023 12:49:49 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org, kvalo@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7a5XeLjTj1MNCDz@lore-desk>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
 <Y7WKcdWap3SrLAp3@unreal>
 <Y7WURTK70778grfD@lore-desk>
 <Y7aW3k4xZVfDb6oh@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E3lyM53mZGU78vqp"
Content-Disposition: inline
In-Reply-To: <Y7aW3k4xZVfDb6oh@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--E3lyM53mZGU78vqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 04, 2023 at 03:59:17PM +0100, Lorenzo Bianconi wrote:
> > > On Wed, Jan 04, 2023 at 03:03:14PM +0100, Lorenzo Bianconi wrote:
> > > > Introduce reset and reset_complete wlan callback to schedule WLAN d=
river
> > > > reset when ethernet/wed driver is resetting.
> > > >=20
> > > > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > > > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  6 ++++
> > > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++=
++++
> > > >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> > > >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> > > >  4 files changed, 56 insertions(+)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/=
net/ethernet/mediatek/mtk_eth_soc.c
> > > > index bafae4f0312e..2d74e26f45c9 100644
> > > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > @@ -3913,6 +3913,10 @@ static void mtk_pending_work(struct work_str=
uct *work)
> > > >  		mtk_w32(eth, val, MTK_MAC_MCR(i));
> > > >  	}
> > > > =20
> > > > +	rtnl_unlock();
> > > > +	mtk_wed_fe_reset();
> > > > +	rtnl_lock();
> > >=20
> > > Is it safe to call rtnl_unlock(), perform some work and lock again?
> >=20
> > Yes, mtk_pending_work sets MTK_RESETTING bit and a new reset work is not
> > scheduled until this bit is cleared
>=20
> I'm more worried about opening a window for user-space access while you
> are performing FW reset.

ack, right. I will work on it.

>=20
> <...>
>=20
> > > > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/s=
oc/mediatek/mtk_wed.h
> > > > index db637a13888d..ddff54fc9717 100644
> > > > --- a/include/linux/soc/mediatek/mtk_wed.h
> > > > +++ b/include/linux/soc/mediatek/mtk_wed.h
> > > > @@ -150,6 +150,8 @@ struct mtk_wed_device {
> > > >  		void (*release_rx_buf)(struct mtk_wed_device *wed);
> > > >  		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
> > > >  					   struct mtk_wed_wo_rx_stats *stats);
> > > > +		int (*reset)(struct mtk_wed_device *wed);
> > > > +		int (*reset_complete)(struct mtk_wed_device *wed);
> > >=20
> > > I don't see any driver implementation of these callbacks in this seri=
es.
> > > Did I miss it?
> >=20
> > These callbacks are implemented in the mt76 driver. I have not added th=
ese
> > patches to the series since mt76 patches usually go through Felix/Kalle=
's
> > trees (anyway I am fine to add them to the series if they can go into n=
et-next
> > directly).
>=20
> Usually patches that use specific functionality are submitted together
> with API changes.

I would say it is better mt76 patches go through Felix/Kalle's tree in orde=
r to avoid
conflicts.

@Felix, Kalle: any opinions?

Regards,
Lorenzo

>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > Thanks
> > >=20
> > > >  	} wlan;
> > > >  #endif
> > > >  };
> > > > --=20
> > > > 2.39.0
> > > >=20
>=20
>=20

--E3lyM53mZGU78vqp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7a5XQAKCRA6cBh0uS2t
rLfWAP9gYmk1Td0tQHCYacOs4/NUjYTRBbGzs2JBA7jXq339ygD+IZOkHXd9Pa87
BX8k/w3kDcMALH3vu6gc4IL/u/xfIQU=
=m8uv
-----END PGP SIGNATURE-----

--E3lyM53mZGU78vqp--
