Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7CE660F8A
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjAGOjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAGOji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:39:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C9552766
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:39:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66439B8170D
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE076C433D2;
        Sat,  7 Jan 2023 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673102374;
        bh=oHq0O7NipgURzsGXKLUqewVXp8Tt2ikWbIknloP3sf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcF5G0T0lEyyRgFgNm4FkfXGGkBa8HZq1qdE0c30FxiNvSLGWoVQBvCWiw+YBcLAY
         7adpxUC+At8yHYivnFHv6Rd9lXNBeGnScprHWxeFeCc+HJpem93qyL3ttdoj2V+913
         HlMV6sosGrS0/0OwIAsDm3R2QCieF61llvfQ1Tg3w752t+TZv26FmpKLbs4rT1Mp8a
         yv+4JYL5+cyH7Q3/KU7Cboi9FTdYzxZceuIGNe79jb2hJWLuA/tlmVShKy56ySO+rK
         g8NSGyTQPSc4cba7WTqzt1q+fQnGIMvJAQa8RL4gYLOxkqz9ensQPBmYxZ/jcZfSeE
         AADZR84m9hbRg==
Date:   Sat, 7 Jan 2023 15:39:30 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7mEItAb41ANfDS+@lore-desk>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
 <Y7WKcdWap3SrLAp3@unreal>
 <Y7WURTK70778grfD@lore-desk>
 <Y7aW3k4xZVfDb6oh@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o3HJf4cBXGnqiUAV"
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


--o3HJf4cBXGnqiUAV
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

looking at mtk_pending_work() I guess running mtk_wed_fe_reset() releasing =
RTNL
lock is not harmful since we just perform few actions (ppe reset, ...)  bef=
ore
running mtk_wed_fe_reset(). Moreover, the core reset part in mtk_pending_wo=
rk()
(mtk_stop(), mtk_open(), ..) is done after mtk_wed_fe_reset() where we reac=
quired
RTNL lock.
In order to avoid any possible race, I guess we can just re-do the prelimin=
ary
reset configuration done before mtk_wed_fe_reset() just after re-acquiring =
RTNL
lock.

Regards,
Lorenzo

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

--o3HJf4cBXGnqiUAV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7mEIgAKCRA6cBh0uS2t
rFuzAP0QRWMIoSUroMKspSE7LRWxsZcfe2Jn0tqjd5q4sEip7QD+KaVTSVpERduG
zXvn/gla31BiRhl4xeBRi87kyIwDgA8=
=i3cU
-----END PGP SIGNATURE-----

--o3HJf4cBXGnqiUAV--
