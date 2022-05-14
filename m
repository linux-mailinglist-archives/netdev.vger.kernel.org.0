Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002A6527061
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 11:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiENJtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiENJto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 05:49:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5FF4F445;
        Sat, 14 May 2022 02:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C9860C7B;
        Sat, 14 May 2022 09:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AF9C340EE;
        Sat, 14 May 2022 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652521769;
        bh=fD/mkjvdISC77Cf8PGTHsmA88B804TFZMCm5qN7kBaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mth4RYLvGgdhMR5tuXBLbTq9kQvo7gu/aJbiEjaVb1PfJv/gwmvhneXxPihIQyUGK
         GxnY32AjxfObxp3T71hJpIQH+sqByeFgxr6USZdLcxGJiWZignGK/SWi/76Hd9sp/O
         6fMXgoeS5+pf/V8nCpOgTz0EGwInsRYn4yq1lFQKNtZhZEW8s6sGEeSl7zjJG1osMl
         VMwgn2Pu/v24gC/feiB+/Xc5HEC7QMq7oOZhferowDQx7OJA2nlUuctB/yKM2qCUxh
         4zmD76z6jbH5zgcvwUcOT1AFZR/Q/iy5pCGdMQma6HEnsg/kebfw+F0Dn2AB/n5hEk
         9Mlg+dSVkZrhA==
Date:   Sat, 14 May 2022 11:49:14 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, landen.chao@mediatek.com
Subject: Re: [PATCH net-next 01/14] arm64: dts: mediatek: mt7986: introduce
 ethernet nodes
Message-ID: <Yn97GqujwYlljkdH@lore-desk>
References: <cover.1651839494.git.lorenzo@kernel.org>
 <1d555fbbac820e9b580da3e8c0db30e7d003c4b6.1651839494.git.lorenzo@kernel.org>
 <YnZ8o46pPdKMCbUF@lunn.ch>
 <YnlC3jvYarpV6BP1@lore-desk>
 <YnlFBr1wgb/hlduy@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="57sKd9UZFq0yO9gn"
Content-Disposition: inline
In-Reply-To: <YnlFBr1wgb/hlduy@lunn.ch>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--57sKd9UZFq0yO9gn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, May 09, 2022 at 06:35:42PM +0200, Lorenzo Bianconi wrote:
> > > > +&eth {
> > > > +	status =3D "okay";
> > > > +
> > > > +	gmac0: mac@0 {
> > > > +		compatible =3D "mediatek,eth-mac";
> > > > +		reg =3D <0>;
> > > > +		phy-mode =3D "2500base-x";
> > > > +
> > > > +		fixed-link {
> > > > +			speed =3D <2500>;
> > > > +			full-duplex;
> > > > +			pause;
> > > > +		};
> > > > +	};
> > > > +
> > > > +	gmac1: mac@1 {
> > > > +		compatible =3D "mediatek,eth-mac";
> > > > +		reg =3D <1>;
> > > > +		phy-mode =3D "2500base-x";
> > > > +
> > > > +		fixed-link {
> > > > +			speed =3D <2500>;
> > > > +			full-duplex;
> > > > +			pause;
> > > > +		};
> > > > +	};
> > >=20
> > > Are both connected to the switch? It just seems unusual two have two
> > > fixed-link ports.
> >=20
> > afaik mac design supports autoneg only in 10M/100M/1G mode and mt7986 g=
mac1
> > is connected to a 2.5Gbps phy on mt7986-ref board.
>=20
> The MAC does not normally perform autoneg, the PHY
> does. phylib/phylink then tells the MAC the result of the
> negotiation. If there is a SERDES/PCS involved, and it is performing
> the autoneg, phylink should get told about the result of the autoneg
> and it will tell the MAC the result.
>=20
> So the gmac1 should just have phy-handle pointing to the PHY, not a
> fixed link.
>=20
>       Andrew

adding Landen to the discussion to provide more hw details.
@Landen: any inputs on it?

Regards,
Lorenzo

--57sKd9UZFq0yO9gn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYn97GgAKCRA6cBh0uS2t
rJi/AQCb9dTLYZ7YoVsaSg9/eM2xO1giATwmWgDgvu7ornUl/wD+Im8XM086QT4k
wTWJpsrIZkt3aACNIfiY34472b6ohAw=
=ZZRY
-----END PGP SIGNATURE-----

--57sKd9UZFq0yO9gn--
