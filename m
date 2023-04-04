Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BB6D5A4E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjDDIHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjDDIHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:07:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0711C12C;
        Tue,  4 Apr 2023 01:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D1E62FD2;
        Tue,  4 Apr 2023 08:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82385C433D2;
        Tue,  4 Apr 2023 08:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680595623;
        bh=5cJzvnfGpQRXqn/hReJhFCeYOI5sN4EzNm/zoSLcsfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vfw3dBNThRpSX1C+0bO/mc0Lqr5F4rrunUyEsnD5OCiwkoO9mrU9oNSpAMPLHpSsh
         3EHNEwiF7bwBqOo0w+Eb/5hDHExXRZQBEKx0EHR8WZ/MIlyKOszXxY7ULvGHOfgCp9
         LGXu+p5laKZ8xcbScaID9040v7o430llp1epdLC3trb9Elq93XY2UgwXeFMwBIL/7N
         5sL3r5cPKzRN3gFq3xHuUa/5+RXyxE8gUwePOosWqIhQ/Miy8gl9NVorU4ZQNznl/+
         WqxtD0VL/iv7e25zy9blIwTdiYgArZ/IVseNMqtO12MYZcg17p8UtXIXV3AtQm0ps6
         MpPaOKO7f/HAA==
Date:   Tue, 4 Apr 2023 10:06:59 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 02/10] net: ethernet: mtk_wed: move cpuboot
 in a dedicated dts node
Message-ID: <ZCvao0Me+W56aZpw@lore-desk>
References: <cover.1680268101.git.lorenzo@kernel.org>
 <56ed497762b1c031c553210a0e5c7717c6069642.1680268101.git.lorenzo@kernel.org>
 <10e9e8dd6eadf68eca55c5742adf18dad23661dc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DjxG6hRSl/7US9il"
Content-Disposition: inline
In-Reply-To: <10e9e8dd6eadf68eca55c5742adf18dad23661dc.camel@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DjxG6hRSl/7US9il
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 2023-03-31 at 15:12 +0200, Lorenzo Bianconi wrote:
> > Since the cpuboot memory region is not part of the RAM MT7986 SoC,
> > move cpuboot in a deidicated syscon node.
> > Keep backward-compatibility with older dts version where cpuboot was
> > defined as reserved-memory child node.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 34 +++++++++++++++++----
> >  drivers/net/ethernet/mediatek/mtk_wed_wo.h  |  3 +-
> >  2 files changed, 30 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/=
ethernet/mediatek/mtk_wed_mcu.c
> > index 6624f6d6abdd..797c3b412ab6 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > @@ -18,12 +18,23 @@
> > =20
> >  static u32 wo_r32(struct mtk_wed_wo *wo, u32 reg)
> >  {
> > -	return readl(wo->boot.addr + reg);
> > +	u32 val;
> > +
> > +	if (!wo->boot_regmap)
> > +		return readl(wo->boot.addr + reg);
> > +
> > +	if (regmap_read(wo->boot_regmap, reg, &val))
> > +		val =3D ~0;
> > +
> > +	return val;
> >  }
> > =20
> >  static void wo_w32(struct mtk_wed_wo *wo, u32 reg, u32 val)
> >  {
> > -	writel(val, wo->boot.addr + reg);
> > +	if (wo->boot_regmap)
> > +		regmap_write(wo->boot_regmap, reg, val);
> > +	else
> > +		writel(val, wo->boot.addr + reg);
>=20
> Very minor nit: it would be more consistent with the read function
> above if you invert the 2 branches, e.g.:
>=20
> 	if (!wo->boot_regmap)
> 		writel(val, wo->boot.addr + reg);
> 	else
> 		regmap_write(wo->boot_regmap, reg, val);
>=20
> No need to repost just for the above, just take into consideration if a
> new version will be needed for other reasons (DT)

ack, will do.

Regards,
Lorenzo

>=20
> Cheers,
>=20
> Paolo
>=20

--DjxG6hRSl/7US9il
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZCvaowAKCRA6cBh0uS2t
rFWSAQCPmw8AG9PY1HwuQ+8YoFiZD7xMPuUISCtYUQDj+b2+EQD/UrRkEAwPhQ9A
3kwDl6KiG7HSunw03//xLB4ao5uZgQ0=
=e1qy
-----END PGP SIGNATURE-----

--DjxG6hRSl/7US9il--
