Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371424AA9CD
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbiBEP57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiBEP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:57:59 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19500C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 07:57:58 -0800 (PST)
Received: (qmail 7077 invoked from network); 5 Feb 2022 15:56:13 -0000
Received: from p200300cf0744fd00709fcefffe16676f.dip0.t-ipconnect.de ([2003:cf:744:fd00:709f:ceff:fe16:676f]:56542 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <andrew@lunn.ch>; Sat, 05 Feb 2022 16:56:13 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct ethtool_drvinfo
Date:   Sat, 05 Feb 2022 16:57:50 +0100
Message-ID: <2227796.ElGaqSPkdT@eto.sf-tec.de>
In-Reply-To: <Yf6OSc78JScHNgag@lunn.ch>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de> <5538622.DvuYhMxLoT@eto.sf-tec.de> <Yf6OSc78JScHNgag@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4687044.GXAFRqVoOG"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4687044.GXAFRqVoOG
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Samstag, 5. Februar 2022, 15:48:41 CET schrieb Andrew Lunn:
> > > > struct ethtool_drvinfo *info>
> > > >=20
> > > >  {
> > > > =20
> > > >  	struct happy_meal *hp =3D netdev_priv(dev);
> > > >=20
> > > > -	strlcpy(info->driver, "sunhme", sizeof(info->driver));
> > > > -	strlcpy(info->version, "2.02", sizeof(info->version));
> > > > +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> > > > +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
> > >=20
> > > I would suggest you drop setting info->version. The kernel will fill
> > > it with the current kernel version, which is much more meaningful.
> >=20
> > Would it make sense to completely remove the version number from the
> > driver
> > then?
>=20
> If it is not used anywhere else, yes, you can remove it.

Of course it prints the number on module load=E2=80=A6 but otherwise it doe=
s nothing=20
with it.
--nextPart4687044.GXAFRqVoOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYf6efgAKCRBcpIk+abn8
TocDAKCbNCbYb0zxNzLx4ltSKbmqXgAPLwCfStkc5ALhEXbuOYzte6c0D5L69wQ=
=1LVG
-----END PGP SIGNATURE-----

--nextPart4687044.GXAFRqVoOG--



