Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B24637B8A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKXOir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKXOip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:38:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1086AEFF
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:38:44 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDMy-0001tx-6I; Thu, 24 Nov 2022 15:38:28 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DE8E7128645;
        Thu, 24 Nov 2022 14:38:25 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:38:24 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
Cc:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
Message-ID: <20221124143824.u5lyi3rektjxft7o@pengutronix.de>
References: <20221123194406.80575-1-yashi@spacecubics.com>
 <CAMZ6RqJ2L6YntT23rsYEEUK=YDF2LrhB8hXwvYjciu3vzjx2hQ@mail.gmail.com>
 <CAELBRWLOKW8NCLpV=MG0_=XY4N3BaozsZCacfgaXEs-tyfzoAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2b5oymuqicmyslax"
Content-Disposition: inline
In-Reply-To: <CAELBRWLOKW8NCLpV=MG0_=XY4N3BaozsZCacfgaXEs-tyfzoAA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2b5oymuqicmyslax
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.11.2022 18:52:14, Yasushi SHOJI wrote:
> On Thu, Nov 24, 2022 at 9:53 AM Vincent Mailhol
> <vincent.mailhol@gmail.com> wrote:
> > > diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcb=
a_usb.c
> > > index 218b098b261d..67beff1a3876 100644
> > > --- a/drivers/net/can/usb/mcba_usb.c
> > > +++ b/drivers/net/can/usb/mcba_usb.c
> > > @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device=
 *netdev, u16 term)
> > >         };
> > >
> > >         if (term =3D=3D MCBA_TERMINATION_ENABLED)
> > > -               usb_msg.termination =3D 1;
> > > -       else
> > >                 usb_msg.termination =3D 0;
> > > +       else
> > > +               usb_msg.termination =3D 1;
> > >
> > >         mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
> >
> > Nitpick: does it make sense to rename the field to something like
> > usb_msg.termination_disable or usb_msg.termination_off? This would
> > make it more explicit that this is a "reverse" boolean.
>=20
> I'd rather define the values like
>=20
> #define TERMINATION_ON (0)
> #define TERMINATION_OFF (1)
>=20
> So the block becomes
>=20
> if (term =3D=3D MCBA_TERMINATION_ENABLED)
>     usb_msg.termination =3D TERMINATION_ON;
> else
>     usb_msg.termination =3D TERMINATION_OFF;

Please send a v2 patch, using git send-email, as you did with the first
version. (No compressed attached patches please.)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2b5oymuqicmyslax
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/gd0ACgkQrX5LkNig
0133OwgAlfuDYqc4mfHIa8P9QiLu3aGHzuezoaoZjCyBFGYcA7asa4LMdpf1pjz7
ldCGajT5dJImf+BS5XnUPFpCU5NOvE9lEw8O8am7jF2386YFJz0f5Mb9aQ7ithOy
S6h6t0ltrfbHLEErAk6mWKYtMZAy53yyeVS0goe+SK0KVvPiuMnkoOm6v8pEON/F
y5ob4OD/kiBWfqgt3PT6Cwjc0pRuj/iLvIpgNYOV0zcybjyFubNY0tBinvnXWqPN
ChuBpKD5d/Rpl3faA0enZ+MdfrEEff+NdUvdVSUzmcCZb8740yr76UMBInYys2gu
CIBZm0t5ldgG4XZ440/i/iLs9czdUw==
=Vfvz
-----END PGP SIGNATURE-----

--2b5oymuqicmyslax--
