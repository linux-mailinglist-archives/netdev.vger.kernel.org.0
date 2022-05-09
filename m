Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB908520287
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiEIQjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiEIQjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:39:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECEB19C3E;
        Mon,  9 May 2022 09:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 785C6B817FB;
        Mon,  9 May 2022 16:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2CCC385AC;
        Mon,  9 May 2022 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652114146;
        bh=owjaYKDd7LVWoycl8NoSTqAJLTcH372kDTQxpt06x9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=med84aMy1ptAH/qEVtFQjVurO+LKsXhDopOnBigxUX/dIJg0ffmHKc3chCXKBiy2o
         /4XXRyx1M+T9dh889LABwu4I0fQwZ0TnXUEHCZhLBvaTKv2Yw/RRexWJRsX+Ai835P
         N5ZKESjnzYRq5zTqsXgLIhTUe9JVjIH12JqsIfhnGwMdrSFB14nrgts+FLyslkQlPQ
         xc8+tGNSXcQGAy0cWEx4i2KRJZ5DChBAMi/NhuUCSXxinSJ050eaSRarA6bLxyK3C5
         Blp/SluhmO/EfGYvy05JaaLQmSek0v3bmccp9W1FJx76ahX2jnXIBXrw4O16LglMtq
         XzizDwIhdU1ew==
Date:   Mon, 9 May 2022 18:35:42 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: Re: [PATCH net-next 01/14] arm64: dts: mediatek: mt7986: introduce
 ethernet nodes
Message-ID: <YnlC3jvYarpV6BP1@lore-desk>
References: <cover.1651839494.git.lorenzo@kernel.org>
 <1d555fbbac820e9b580da3e8c0db30e7d003c4b6.1651839494.git.lorenzo@kernel.org>
 <YnZ8o46pPdKMCbUF@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PCSMGdiYoHExCj3r"
Content-Disposition: inline
In-Reply-To: <YnZ8o46pPdKMCbUF@lunn.ch>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PCSMGdiYoHExCj3r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +&eth {
> > +	status =3D "okay";
> > +
> > +	gmac0: mac@0 {
> > +		compatible =3D "mediatek,eth-mac";
> > +		reg =3D <0>;
> > +		phy-mode =3D "2500base-x";
> > +
> > +		fixed-link {
> > +			speed =3D <2500>;
> > +			full-duplex;
> > +			pause;
> > +		};
> > +	};
> > +
> > +	gmac1: mac@1 {
> > +		compatible =3D "mediatek,eth-mac";
> > +		reg =3D <1>;
> > +		phy-mode =3D "2500base-x";
> > +
> > +		fixed-link {
> > +			speed =3D <2500>;
> > +			full-duplex;
> > +			pause;
> > +		};
> > +	};
>=20
> Are both connected to the switch? It just seems unusual two have two
> fixed-link ports.

afaik mac design supports autoneg only in 10M/100M/1G mode and mt7986 gmac1
is connected to a 2.5Gbps phy on mt7986-ref board.

Regards,
Lorenzo

>=20
> 	   Andrew

--PCSMGdiYoHExCj3r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYnlC3gAKCRA6cBh0uS2t
rCm/AP9WkMTnnhB1Nu9L5BHoNXdksU1GeqgTZsI/h6bUpuonaAD9H/lNxLig+hSg
y4K/G0OA6qVY+cSX9gevZ9vIHjaAFAA=
=+S5h
-----END PGP SIGNATURE-----

--PCSMGdiYoHExCj3r--
